Bash Script to Set up a Headless Host as AngularJS Test Agent
=============================================================

Here is a bash script that allows you to set up an Ubuntu server host as a headless (X-window) test agent for AngularJS unit and e2e testing using Karma and Protractor.

## Requirements

I have only tested the script in Ubuntu 14 on AWS EC2. But you can certainly modify and adapt the script for Docker, Chef, Puppet, or any other provisioning/VM environments. Even though the script is written to install test frameworks for AngularJS, you can modify it for other Selemnium-dependent test frameworks.

## Use

Install and set up the environment.

```sh
$ curl -sSL https://raw.githubusercontent.com/cybersamx/angularjs-testagent/master/setup-testagent.sh | sudo bash
```

## Overview

The script performs the following operations:

1. Installs X-Window and Xvfb framebuffer for running X-Window in a headless configuration by performing X-Windows graphical operations in the main memory buffer as opposed to a framebuffer, consequently enabling X-Window applications to run in a server setting
2. Installs the Chrome web browser. The script installs Google Chrome instead of the open-source version Chromium
3. Installs imagemagick to allow us to automate the process of taking snapshots each test spec as they are executed on the web browser
4. Installs Selenium and its dependencies including Java SDK
5. Installs Chrome Driver
6. Installs Node.js and NPM
7. Creates a skeleton AngularJS application using angular-seed
7. Installs Karma
8. Installs Protractor

You can test if Karma is working by running the following:

```
$ cd ~ubuntu/src/angular-seed
$ npm test
```

You can test if Protractor is working by running the following:

```
$ cd ~ubuntu/src/angular-seed
$ npm start
```

Open another SSH connection and do the following:

```
$ npm run protractor
```

## Further work

* Write a Dockerfile
* Write Chef cookbook
