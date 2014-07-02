#!/usr/bin/env bash

# Credits:
# Partially based on https://github.com/wayneeseguin/rvm

shopt -s extglob  # Extend pattern matching

# --- Global Constants and Variables ---

angular_owner=ubuntu
angular_project_root_dir=/home/ubuntu/src

# --- Functions ---

which_cmd() { which "$@" || return $?; true; }
phase_log() { printf "$(tput bold)$(tput setaf 1)$*$(tput sgr 0)\n"; }

# -- Main Function ---

check_prerequisites() {
  if [ ${EUID} != 0 ]
  then
    echo "Run as user ubuntu, and run the script with sudo"
    exit
  fi

  which_cmd wget > /dev/null || {
    echo "This script requires 'wget'. Please install 'wget' and try again."
    return 100
  }
}

install_packages() {
  # Install X-window and Xvfb.
  phase_log "Installing x-window and xvfb..."
  apt-get install -y xvfb x11-xkb-utils xfonts-100dpi \
  xfonts-75dpi xfonts-scalable xfonts-cyrillic xserver-xorg-core dbus-x11 libfontconfig1-dev

  # Install other software.
  phase_log "Installing other software..."
  apt-get install -y imagemagick default-jdk unzip git wget

  # Install node.js.
  phase_log "Installing node.js..."
  apt-get install -y nodejs npm nodejs-legacy

  # Install (Google) chrome.
  phase_log "Installing (Google) chrome..."
  cd /tmp
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb
  apt-get -fy install
  rm google-chrome-stable_current_amd64.deb

  # Install chromedriver.
  phase_log "Installing chromedriver..."
  cd /usr/local/bin
  wget http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip
  unzip chromedriver_linux64.zip
  mv chromedriver chromedriver-2.10
  rm chromedriver_linux64.zip
  ln -s chromedriver-2.10 chromedriver
  chmod +rx  chromedriver-2.10

  # Instll selenium.
  phase_log "Installing selenium..."
  mkdir -p /usr/local/lib/selenium
  cd /usr/local/lib/selenium
  wget http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar
  ln -s selenium-server-standalone-2.42.2.jar selenium-server-standalone.jar
} 

install_angularjs() {
  if [[ -e $angular_project_root_dir ]]
  then
    cd $angular_project_root_dir/angular-seed
  else
    # Create an AngularJS project directory.
    phase_log "Installing an AngularJS directory..."
    sudo -u $angular_owner mkdir $angular_project_root_dir
    cd $angular_project_root_dir
    sudo -u $angular_owner git clone https://github.com/angular/angular-seed.git
    cd angular-seed
  fi

  # Edit config files in AngularJS project directory.
  # package.json
  phase_log "Changing AngularJS confing files..."
  sudo -u $angular_owner sed -i '/devDependencies/a \
\ \ \ \ "karma-phantomjs-launcher": "~0.1.4",
  ' package.json
  sudo -u $angular_owner sed -i 's/"bower\ install"/"bower install --config.interactive=false"/' package.json

  # karma.conf.js
  sudo -u $angular_owner sed -i "s/\['Chrome'\]/\['PhantomJS'\]/" test/karma.conf.js
  sudo -u $angular_owner sed -i '/plugins/a \
\ \ \ \ \ \ \ \ \ \ \ \ '\''karma-phantomjs-launcher'\'',
  ' test/karma.conf.js

  # protractor-conf.js
  sudo -u $angular_owner sed -i '3 a\
\ \ seleniumAddress: '\''http://localhost:4444/wd/hub'\'',
  ' test/protractor-conf.js

  # Install node modules.
  phase_log "Install node.js modules..."
  cd $angular_project_root_dir/angular-seed
  npm install -g protractor
  sudo -u $angular_owner npm install
}

setup_testagent() {
  check_prerequisites
  install_packages
  install_angularjs
}

setup_testagent "$@"