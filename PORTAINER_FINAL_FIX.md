# Portainer "local" Environment - Finale Lösung

## Problem
Portainer zeigt "local" als "Up" an, springt aber beim Klick auf "Down".

## Aktuelle Konfiguration
- Portainer läuft mit `--privileged`
- Docker Socket: `/var/run/docker.sock:/var/run/docker.sock`
- Socket-Berechtigungen: 666

## Lösungsversuche

### Versuch 1: Docker API URL Varianten

Beim Hinzufügen der "local" Umgebung in Portainer, versuchen Sie verschiedene API URLs:

1. **unix:///var/run/docker.sock** (Standard)
2. **/var/run/docker.sock** (ohne unix://)
3. **unix:///var/run/docker.sock** mit "Skip TLS verification" aktiviert

### Versuch 2: Portainer Agent verwenden

Falls direkter Socket-Zugriff nicht funktioniert:

1. In Portainer: "Add environment" → "Docker (Standalone)"
2. Wählen Sie "Use Portainer Agent"
3. Installieren Sie den Agent auf dem Host:

```bash
docker run -d \
  --name portainer-agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -p 9001:9001 \
  portainer/agent:latest
```

4. In Portainer: Agent URL: `http://localhost:9001`

### Versuch 3: Portainer Business Edition

Die Community Edition könnte ein bekanntes Problem haben. Versuchen Sie die Business Edition (kostenlos für bis zu 5 Nodes):

```bash
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  --privileged \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -v portainer_data:/data \
  -p 9000:9000 \
  -p 9443:9443 \
  portainer/portainer-ee:latest
```

### Versuch 4: Alternative: Docker Desktop oder andere Tools

Falls Portainer weiterhin Probleme macht, können Sie alternativ verwenden:
- **Docker Desktop** (falls verfügbar)
- **Lazydocker** (Terminal-basiert)
- **Dockge** (Web-basiert, ähnlich Portainer)

## Debugging

### Logs prüfen
```bash
sudo docker logs portainer -f
```
Dann in Portainer auf "local" klicken und die Fehlermeldung notieren.

### Browser-Konsole prüfen
1. Öffnen Sie Portainer im Browser
2. Drücken Sie F12 (Entwicklertools)
3. Gehen Sie zum "Console" Tab
4. Klicken Sie auf "local"
5. Schauen Sie nach Fehlermeldungen in der Konsole

### API direkt testen
```bash
# Prüfe ob Portainer die Docker API erreichen kann
curl -s http://localhost:9000/api/endpoints

# Prüfe die "local" Umgebung
curl -s http://localhost:9000/api/endpoints/1
```

## Bekannte Probleme

1. **Portainer 2.21.5 Bug**: Es gibt bekannte Probleme mit bestimmten Docker-Versionen
2. **Socket-Berechtigungen**: Auch mit 666 kann es Probleme geben
3. **Docker Version**: Docker 29.0.3 könnte inkompatibel sein

## Empfehlung

Versuchen Sie zuerst:
1. Verschiedene Docker API URL Formate
2. Portainer Agent
3. Browser-Konsole auf Fehler prüfen

Falls nichts hilft, könnte es ein Bug in Portainer 2.21.5 sein. Versuchen Sie eine ältere Version:

```bash
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  --privileged \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -v portainer_data:/data \
  -p 9000:9000 \
  -p 9443:9443 \
  portainer/portainer-ce:2.20.0
```


