# Portainer Docker Socket Zugriffsproblem - Lösung

## Problem
Portainer kann nach der Installation des UniFi Docker-Containers nicht mehr auf `/var/run/docker.sock` zugreifen.

## Lösung

Portainer muss mit der richtigen Gruppe (docker) gestartet werden, um auf den Docker Socket zugreifen zu können.

### Option 1: Portainer mit docker-Gruppe neu starten

```bash
# Portainer stoppen
sudo docker stop portainer
sudo docker rm portainer

# Portainer mit docker-Gruppe neu starten
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  --group-add $(getent group docker | cut -d: -f3) \
  portainer/portainer-ce:latest
```

### Option 2: Docker Compose (empfohlen)

Erstellen Sie eine `docker-compose.yml` für Portainer:

```yaml
version: '3.8'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    group_add:
      - "$(getent group docker | cut -d: -f3)"
    ports:
      - "9000:9000"
      - "9443:9443"
```

Dann starten:
```bash
docker compose up -d
```

### Option 3: Socket-Berechtigungen prüfen

Falls das Problem weiterhin besteht, prüfen Sie die Socket-Berechtigungen:

```bash
# Socket-Berechtigungen prüfen
ls -la /var/run/docker.sock

# Sollte zeigen: srw-rw---- 1 root docker

# Falls nicht, Berechtigungen korrigieren:
sudo chmod 666 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock
```

### Option 4: Portainer mit privilegiertem Modus (nicht empfohlen, aber funktioniert)

```bash
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

## Verifikation

Nach dem Neustart:
1. Öffnen Sie Portainer im Browser
2. Prüfen Sie, ob alle Container angezeigt werden
3. Prüfen Sie die Logs: `sudo docker logs portainer`

## Ursache

Das Problem tritt auf, weil:
- Portainer als normaler Benutzer läuft (nicht root)
- Der Docker Socket gehört zur `docker`-Gruppe
- Portainer muss Mitglied der `docker`-Gruppe sein, um auf den Socket zuzugreifen
- Dies wird durch `--group-add` oder `group_add` in der Konfiguration erreicht


