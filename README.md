# HomekitDataExporter

This is a simple utility application created to store Homekit device properties over time such that historic data can easily be explored in charts and graphs.

## Setup

### Installing InfluxDB and Grafana

The application can send data to any InfluxDB instance. The following steps indicate how to set this up using Docker containers for both the InfluxDB and Grafana

1. Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
1. Install [Homebrew](https://docs.brew.sh/Installation) - while not strictly neccessary Homebrew makes package management much simpler.
1. Open a terminal and use the newly installed Homebrew to install docker-compose - `brew install docker-compose`
1. To run docker-compose a number of the docker executables need to be on the terminal's path. These are likely in the following locations:
1.- Apple Silicon `/Applications/Docker.app/Contents/Resources/bin/`
1.- Intel Mac `~/.docker/bin/`
1. To add the location to the terminal's path simply run export `export PATH=$PATH:~/.docker/bin/` (using the appropriate location). 
1. Download the [docker-statsd-influxdb-grafana git project](https://github.com/samuelebistoletti/docker-statsd-influxdb-grafana). If you don't use git regularly you can just download the zip archive of the project.
1. In a terminal navigate to the location of the root of the 'docker-statsd-influxdb-grafana' project.
1. Run `COMPOSE_PROFILES=grafana docker-compose up -d` to start the containers.

### Configure InfluxDB

The default parameters in the InfluxDB container should work well. However, if you wish to change anything you can access InfluxDB from any browser at http://localhost:8086/. The default username is `admin` and the password is `admin123456`.

### Configure Grafana

Grafana should be preconfigured to have the InfluxDB instance as a datasource. To access the Grafana instance visit http://localhost:3000 from any browser. The default username is `admin` and the password is `admin`.

### Building the application

The application has not been packaged for distribution on the app store. That saves on the anual Apple Developer subscription fee. However, it does unfortunately mean that anyone wishing to run the project will have to build it themselves. Once built the project can then only then be run from within Xcode. 

1. Download Xcode on the computer the app will run on. Xcode can be found on the Apple appstore.
1. Open Xcode and when asked choose to install the iOS 17 resources
1. You will need a personal certificate to sign the application.
1.1. Go to Settings / Accounts
1.1. Your Apple ID should be listed or you can add it by clicking on the `+` in the bottom corner.
1.1. Choose `Manage Certificates` and add a new developer certificate. 
1.1. You should see 'FirstName LastName (Personal Team)' listed
1.1. Close the settings and return to the project
1. Click on `HomekitDataExporter` in the project navigator to open the project settings.
1. Open the `Signing and Capabilities` tab
1. For `Team` choose 'FirstName LastName (Personal Team)'
1. Now build and run the project using the play button at the top of the Xcode window. If not preselected the target should be 'My Mac (Mac Catalyst)`
1. If all goes well the app window should open
