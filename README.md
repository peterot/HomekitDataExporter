# HomekitDataExporter

This is a simple utility application created to store Homekit device properties over time such that historic data can easily be explored in charts and graphs.

## Setup

### InfluxDB and Grafana

The application can send data to any InfluxDB instance. The following steps indicate how to set this up using Docker containers for both the InfluxDB and Grafana

1. Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
1. Install [Homebrew](https://docs.brew.sh/Installation) - while not strictly neccessary Homebrew makes package management much simpler.
1. Open a terminal and use the newly installed Homebrew to install docker-compose 

### Building the application

The application has not been packaged for distribution on the app store. That save on the anual subscription fee. However, it does unfortunately mean that anyone wishing to run the project will have to build it themselves. Once built the project can then only then be run from within Xcode. 

1. Download Xcode on the computer the app will run on. Xcode can be found on the Apple appstore.
