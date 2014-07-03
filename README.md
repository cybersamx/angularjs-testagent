angularjs-testagent
===================

Install and setup an Ubuntu host as a headless (X-window) test agent for Angular unit and e2e testing using Karma and Protractor.

## Use

Install and set up the environment.

```sh
$ curl -sSL https://raw.githubusercontent.com/cybersamx/angularjs-testagent/master/setup-testagent.sh | sudo bash
```

The script will perform the following operations:

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

I have only tested the script in Ubuntu 14 on AWS EC2.

* Write a Dockerfile for this operation. It should be cleaner.
* Write Chef cookbook to install/configure a headless host for CI and automated testing AngularJS code.
