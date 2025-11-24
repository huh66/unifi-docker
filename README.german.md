# UniFi Network Application Docker Image

Dieses Docker-Image enthält die UniFi Network Application 9.5.21 mit allen erforderlichen Abhängigkeiten.

## ⚠️ Wichtiger Hinweis

**Die UniFi Network Application Software ist proprietäre Software von Ubiquiti Inc.**  
Das `.deb` Paket ist **NICHT** in diesem Repository enthalten und darf nicht weitergegeben werden.

Sie müssen das UniFi Network Application Paket von der offiziellen Ubiquiti-Website herunterladen:
- **Offizielle Download-Seite**: https://www.ui.com/download/unifi
- Wählen Sie "UniFi Network Application" → "Debian/Ubuntu Linux" → Version 9.5.21

## Voraussetzungen

- Docker und Docker Compose installiert
- Das UniFi .deb Paket (`unifi_sysvinit_all.deb`) muss von Ubiquiti heruntergeladen und im gleichen Verzeichnis wie das Dockerfile platziert werden

## Installation

1. Laden Sie das UniFi .deb Paket von der [offiziellen Ubiquiti-Website](https://www.ui.com/download/unifi) herunter
   - Wählen Sie: UniFi Network Application → Debian/Ubuntu Linux → Version 9.5.21
   - Dateiname: `unifi_sysvinit_all.deb`

2. Platzieren Sie das heruntergeladene `.deb` Paket in diesem Verzeichnis:
   ```bash
   cp ~/Downloads/unifi_sysvinit_all.deb .
   ```

2. Erstellen Sie das Docker-Image:
   ```bash
   docker-compose build
   ```

   Oder manuell:
   ```bash
   docker build --build-arg UNIFI_DEB=unifi_sysvinit_all.deb -t unifi:9.5.21 .
   ```

3. Starten Sie den Container:
   ```bash
   docker-compose up -d
   ```

## Zugriff

- Web-Interface (HTTP): http://localhost:8081
- Web-Interface (HTTPS): https://localhost:8443
- Portal HTTP: http://localhost:8880
- Portal HTTPS: https://localhost:8843

## Datenpersistenz

Alle UniFi-Daten werden im Docker-Volume `unifi-data` gespeichert und bleiben auch nach dem Neustart des Containers erhalten.

## Ports

Die folgenden Ports werden verwendet:
- **8081**: HTTP (angepasst von Standard 8080 wegen möglicher Konflikte)
- **8443**: HTTPS
- **8880**: Portal HTTP
- **8843**: Portal HTTPS
- **27117/udp**: MongoDB
- **5656/udp**: STUN
- **10001/udp**: Discovery

## Wartung

### Logs anzeigen:
```bash
docker-compose logs -f unifi
```

### Container stoppen:
```bash
docker-compose down
```

### Container neu starten:
```bash
docker-compose restart
```

### Daten-Backup:
```bash
docker run --rm -v unifi-data:/data -v $(pwd):/backup debian:12-slim tar czf /backup/unifi-backup-$(date +%Y%m%d).tar.gz /data
```

## Hinweise

- Das Image basiert auf Debian 12 (bookworm)
- MongoDB 7.0 wird verwendet (kompatibel mit UniFi 9.5.21)
- OpenJDK 17 wird als Java Runtime verwendet
- libssl1.1 wird aus dem Debian 11 Security Repository installiert (benötigt für MongoDB)

## Lizenz

**Dieses Repository:**
- Dockerfiles, Skripte und Konfigurationsdateien: [MIT License](LICENSE)

**UniFi Network Application:**
- Proprietäre Software von Ubiquiti Inc.
- Unterliegt der [Ubiquiti End User License Agreement](https://www.ui.com/legal/terms-of-service)
- Muss von der [offiziellen Website](https://www.ui.com/download/unifi) heruntergeladen werden

## Disclaimer

Dieses Projekt ist nicht mit Ubiquiti Inc. verbunden oder von Ubiquiti Inc. genehmigt.  
Die UniFi Network Application ist eine Marke von Ubiquiti Inc.

