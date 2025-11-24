# HomeKit Data Exporter
Export HomeKit sensor readings into **InfluxDB 2.x** and visualise them in **Grafana**.

This is a small Swift utility that connects to your local HomeKit accessories, collects sensor values, and writes them into an InfluxDB bucket. Typical use cases include logging:

- temperature
- humidity
- power consumption
- contact sensors
- motion events

…and anything else exposed via HomeKit characteristics.

## ✨ Features

- Native HomeKit access via `HMHomeManager`
- Writes directly to **InfluxDB 2.x** using bucket/org/token auth
- Flux-ready time-series schema
- Simple CLI configuration
- Works alongside Grafana dashboards for visualisation
- Includes an optional `docker-compose.yml` for running InfluxDB + Grafana locally with persistent storage

# 🚀 Quick Start

This setup runs entirely locally on your machine using Docker Desktop.

## 1. Clone the repository

```bash
git clone https://github.com/peterot/HomekitDataExporter.git
cd HomekitDataExporter
```

## 2. Start InfluxDB and Grafana

A modern `docker-compose.yml` is provided.
It uses **bind mounts** so all data lives under `./data/` on your host (safe across updates).

Start everything:

```bash
docker compose up -d
```

### What this does

- Starts **InfluxDB 2.x** on `http://localhost:8086`
- Starts **Grafana OSS** on `http://localhost:3000`
- Initialises Influx with:
  - Org: `myorganization`
  - Bucket: `mybucket`
  - Token: `myadmintoken`
  - Username: `admin`
  - Password: `change-me-admin-password`

You can (and should) change these in `docker-compose.yml` for your own environment.

### Data Persistence

All state is stored in:

```
data/
  influxdb-data/
  influxdb-config/
  grafana-storage/
```

This means you can safely update container versions with:

```bash
docker compose pull
docker compose up -d
```

…and your data is preserved.

# 📦 Docker Compose Reference

```yaml
version: "3.9"

services:
  influxdb:
    image: influxdb:2.7
    container_name: influxdb
    restart: unless-stopped
    ports:
      - "8086:8086"
    volumes:
      - ./data/influxdb-data:/var/lib/influxdb2
      - ./data/influxdb-config:/etc/influxdb2
    environment:
      DOCKER_INFLUXDB_INIT_MODE: setup
      DOCKER_INFLUXDB_INIT_USERNAME: admin
      DOCKER_INFLUXDB_INIT_PASSWORD: change-me-admin-password
      DOCKER_INFLUXDB_INIT_ORG: myorganization
      DOCKER_INFLUXDB_INIT_BUCKET: mybucket
      DOCKER_INFLUXDB_INIT_ADMIN_TOKEN: myadmintoken

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    restart: unless-stopped
    depends_on:
      - influxdb
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: change-me-grafana
    volumes:
      - ./data/grafana-storage:/var/lib/grafana
```

Add `data/` to `.gitignore` so you never accidentally commit database files.

# 🟦 Configure InfluxDB

Once containers are running:

1. Go to **http://localhost:8086**
2. Log in with the credentials from the compose file
3. You should already have:
   - Org: `myorganization`
   - Bucket: `mybucket`
   - Token: `myadmintoken`

If you need more tokens:

- Settings → API Tokens → “Generate API Token”

# 📊 Configure Grafana

1. Visit **http://localhost:3000**
2. Log in as:
   - **User:** `admin`
   - **Password:** `change-me-grafana`

3. Add a data source:
   - Data Source Type: **InfluxDB**
   - Query Language: **Flux**
   - URL: `http://influxdb:8086`
   - Organisation: `myorganization`
   - Bucket: `mybucket`
   - Token: `myadmintoken`

Click **Save & Test**.

# 🔧 Running the Exporter

The exporter expects your HomeKit environment to be available on the machine running the app (iOS, macOS, or Catalyst build).

### Configuration Values

| Setting        | Example value         |
|----------------|------------------------|
| Influx URL     | `http://localhost:8086` |
| Organisation   | `myorganization`      |
| Bucket         | `mybucket`            |
| Token          | `myadmintoken`        |

These same defaults are already shown in the README and inside the app UI.

### Build and Run (macOS)

Open the project in Xcode:

```
open HomekitDataExporter.xcodeproj
```

Choose the macOS target, build, and run.

The exporter will:

1. Request HomeKit permission
2. Enumerate accessories
3. Log readings to InfluxDB
4. Confirm writes via the status bar in the UI

# 📈 Building Dashboards

Example Flux queries:

Temperature:

```flux
from(bucket: "mybucket")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "temperature")
  |> filter(fn: (r) => r.accessory == "Bedroom")
```

Humidity:

```flux
from(bucket: "mybucket")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "humidity")
```

Motion events per hour:

```flux
from(bucket: "mybucket")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "motion")
  |> aggregateWindow(every: 1h, fn: count)
```

# 🔐 Security Notes

- The credentials in `docker-compose.yml` are **development defaults** — change them for any real deployment.
- Don’t expose InfluxDB or Grafana to the internet without authentication.
- Consider placing secrets in `docker-compose.override.yml` (not committed).

# 🗄️ Backups & Upgrades

All data sits under the `./data` directory.

Backup everything:

```bash
tar -czf influx_grafana_backup.tar.gz data/
```

Upgrade:

```bash
docker compose pull
docker compose up -d
```

# 🧰 Requirements

- macOS or iOS device with HomeKit access
- Xcode 14+
- Docker Desktop
- InfluxDB 2.x
- Grafana OSS

# 📄 License

MIT
