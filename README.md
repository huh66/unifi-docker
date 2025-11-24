# UniFi Network Application Docker Image

This Docker image contains UniFi Network Application 9.5.21 with all required dependencies.

## ⚠️ Important Notice

**The UniFi Network Application software is proprietary software owned by Ubiquiti Inc.**  
The `.deb` package is **NOT** included in this repository and may not be redistributed.

You must download the UniFi Network Application package from the official Ubiquiti website:
- **Official Download Page**: https://www.ui.com/download/unifi
- Select: UniFi Network Application → Debian/Ubuntu Linux → Version 9.5.21

## Prerequisites

- Docker and Docker Compose installed
- The UniFi .deb package (`unifi_sysvinit_all.deb`) must be downloaded from Ubiquiti and placed in the same directory as the Dockerfile

## Installation

1. Download the UniFi .deb package from the [official Ubiquiti website](https://www.ui.com/download/unifi)
   - Select: UniFi Network Application → Debian/Ubuntu Linux → Version 9.5.21
   - Filename: `unifi_sysvinit_all.deb`

2. Place the downloaded `.deb` package in this directory:
   ```bash
   cp ~/Downloads/unifi_sysvinit_all.deb .
   ```

3. Build the Docker image:
   ```bash
   docker compose build
   ```

   Or manually:
   ```bash
   docker build --build-arg UNIFI_DEB=unifi_sysvinit_all.deb -t unifi:9.5.21 .
   ```

4. Start the container:
   ```bash
   docker compose up -d
   ```

## Access

- Web Interface (HTTP): http://localhost:8081
- Web Interface (HTTPS): https://localhost:8443
- Portal HTTP: http://localhost:8880
- Portal HTTPS: https://localhost:8843

## Data Persistence

All UniFi data is stored in the Docker volume `unifi-data` and persists across container restarts.

## Ports

The following ports are used:
- **8081**: HTTP (adjusted from default 8080 due to potential conflicts)
- **8443**: HTTPS
- **8880**: Portal HTTP
- **8843**: Portal HTTPS
- **27117/udp**: MongoDB
- **5656/udp**: STUN
- **10001/udp**: Discovery

## Maintenance

### View logs:
```bash
docker compose logs -f unifi
```

### Stop container:
```bash
docker compose down
```

### Restart container:
```bash
docker compose restart
```

### Data backup:
```bash
docker run --rm -v unifi-data:/data -v $(pwd):/backup debian:12-slim tar czf /backup/unifi-backup-$(date +%Y%m%d).tar.gz /data
```

## Notes

- Image is based on Debian 12 (bookworm)
- MongoDB 7.0 is used (compatible with UniFi 9.5.21)
- OpenJDK 17 is used as Java Runtime
- libssl1.1 is installed from Debian 11 Security Repository (required for MongoDB)

## License

**This Repository:**
- Dockerfiles, scripts, and configuration files: [MIT License](LICENSE)

**UniFi Network Application:**
- Proprietary software by Ubiquiti Inc.
- Subject to [Ubiquiti End User License Agreement](https://www.ui.com/legal/terms-of-service)
- Must be downloaded from the [official website](https://www.ui.com/download/unifi)

## Disclaimer

This project is not affiliated with or endorsed by Ubiquiti Inc.  
UniFi Network Application is a trademark of Ubiquiti Inc.

