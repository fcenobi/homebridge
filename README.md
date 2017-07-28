# Dockerized Homebridge
![doc9](https://user-images.githubusercontent.com/24189833/28737747-53f5fc58-73f0-11e7-90dd-fa553ed299f7.png)

[This Docker image](https://hub.docker.com/r/marcoraddatz/homebridge/) helps you to easily setup [Homebridge](https://github.com/nfarina/homebridge) on your Synology, but also runs on QNAP devices or Raspberry Pies. If you're using a Synology, please make sure to run at least DSM 6, otherwise you [might have to go the harder way](https://marcoraddatz.com/en/2016/07/13/run-homebridge-on-a-synology/) via SSH/shell scripts.
![doc8](https://user-images.githubusercontent.com/24189833/28738197-58d00258-73f2-11e7-8849-5def9e19bfaa.png)

## Installation (via Synology DSM)

### 1. Download Image


### 2. Prepare your scripts

Create a folder via DSM File Station at `/volume1/docker/homebridge` and put your `config.json` and **either** your `package.json` or `install.sh` (recommended) in there. If you'd like to develop an own plugin or debug Homebridge, also copy the `.env` file.

Here are two examples of how your setup files may look like:

#### [package.json](samples/package.json)

```json
{
  "name": "DiskStationHomeBridge",
  "description": "HomeKit support for the impatient.",
  "version": "0.1.1",
  "license": "ISC",
  "dependencies": {
    "homebridge-harmonyhub": "0.2.0-alpha",
    "homebridge-netatmo": "^0.0.4",
    "homebridge-nukiio": "^0.0.3",
    "homebridge-synology": "^0.1.0"
  }
}
```

#### [install.sh](samples/install.sh)

*Note that you can also use this file to install server dependencies!*

```shell
#!/bin/bash

npm install -g homebridge-harmonyhub
npm install -g homebridge-netatmo
npm install -g homebridge-nukiio
npm install -g homebridge-synology
```

Since version 2.1 all commands get executed as root.

### 3. Start Container

Once the plugins have been set up, the Docker container is ready to launch.

Link the `/volume1/docker/homebridge` to `/root/.homebridge`, otherwise, the configuration files won’t be loaded (within DSM the path is only shown as `/docker/homebridge`.


Once you launch (or restart) the container, Homebridge and all its dependencies will get installed. To verify that Homebridge is running or if an error occurs, you can use the container's log (Container → Details → Log) to receive further information on the process.

## Command line

There are many Docker commands that can be run via the `homebridge.sh` script. Please have a look [at the file](homebridge.sh), it should be self-explaining.

## Plugin development

If you intend to develop a plugin or Homebridge is not running as it's supposed to, you might want to start Homebridge with debugging options. To do so, copy the sample `.env` file to `/volume1/docker/homebridge` and set the desired environment. Don't forget to place your plugins manually under `/volume1/docker/homebridge/plugins` and (re-) start the container. See the [Homebridge docs](https://github.com/nfarina/homebridge#plugin-development) for details.

### .env options

All `.env` variables are optional.

#### HOMEBRIDGE_ENV

- **production** _(default)_
Starts Homebridge without any options.
- **development**
Starts Homebridge with plugin support.
- **debug**
Starts Homebridge with plugin support and maximum debugging info.

#### HOMEBRIDGE_VERSION

To avoid breaks with either new Homebridge releases or iOS updates, you can force the installation of a specific Homebridge version. `HOMEBRIDGE_VERSION` accepts any release tag (f.e "0.4.17") or valid NPM version range.

## Troubleshooting

In case, that Homebridge doesn't run as expected, please follow these steps for debugging:

### 1. Verify your `config.json`

Many issues appear because of invalid JSON. Before you open a ticket, please make sure that the syntax is ok. A good way to verify your config is to use the [jsonlint.com](http://jsonlint.com) validator.

### 2. Disable Plugins

Most issues aren't related to this package, nor to Homebridge --  they are created by outdated plugins or wrong configuration. This package focuses on making Homebridge run as easy as possible. So if Homebridge runs without any plugins, enable them step by step until you find out, which plugin creates the error. You should then contact the plugin's creator.

### 3. Open ports

Make sure that ports 5353 and 51826 (both TCP) aren't blocked by your firewall.

### 4. Adjust paths

If you're using a non-Synology device, you might need to adjust the paths to your config (`/volume1/docker/homebridge`).

## License

This project is licensed under Apache License V2 (see [LICENSE](LICENSE)).



