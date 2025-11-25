# Portainer Debugging - "local" springt auf "Down"

## Problem
Nach dem Erstellen von "local" wird Docker mit "Up" angezeigt, aber beim ersten Klick springt es auf "Down".

## Aktuelle Konfiguration
Portainer läuft mit:
- `--privileged` Modus
- Docker Socket gemountet: `/var/run/docker.sock:/var/run/docker.sock`
- Socket-Berechtigungen: 666 (rw-rw-rw-)

## Debugging-Schritte

### 1. Logs in Echtzeit überwachen
```bash
sudo docker logs -f portainer
```
Dann in Portainer auf "local" klicken und die Fehlermeldung notieren.

### 2. Portainer API direkt testen
```bash
# Prüfe ob Portainer die Docker API erreichen kann
curl -s http://localhost:9000/api/endpoints | jq .

# Prüfe die "local" Umgebung
curl -s http://localhost:9000/api/endpoints/1 | jq .
```

### 3. Docker Socket direkt testen
```bash
# Prüfe ob der Socket erreichbar ist
sudo docker ps

# Prüfe Socket-Berechtigungen
ls -la /var/run/docker.sock
```

### 4. Portainer-Datenbank prüfen
Möglicherweise ist die Umgebung in der Datenbank korrupt:
```bash
# Portainer stoppen
sudo docker stop portainer

# Datenbank sichern
sudo docker run --rm -v portainer_data:/data -v $(pwd):/backup alpine tar czf /backup/portainer_backup_$(date +%Y%m%d).tar.gz /data

# Portainer starten
sudo docker start portainer
```

### 5. Alternative: Portainer Agent verwenden
Statt direktem Socket-Zugriff können Sie den Portainer Agent verwenden:
1. In Portainer: Settings → Environments
2. Add environment → Docker (Standalone)
3. Wählen Sie "Use Portainer Agent"
4. Installieren Sie den Agent auf dem Host

### 6. Portainer komplett neu installieren
Falls nichts hilft:
```bash
# Portainer stoppen und entfernen
sudo docker stop portainer
sudo docker rm portainer

# Datenbank zurücksetzen (ACHTUNG: Alle Einstellungen gehen verloren!)
sudo docker volume rm portainer_data

# Neu starten
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  --privileged \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -v portainer_data:/data \
  -p 9000:9000 \
  -p 9443:9443 \
  portainer/portainer-ce:latest
```

## Mögliche Ursachen

1. **Berechtigungsproblem**: Portainer kann den Socket sehen, aber nicht darauf zugreifen
2. **Datenbank-Problem**: Die Umgebung ist in der Datenbank als "unreachable" markiert
3. **API-Problem**: Portainer kann die Docker API nicht erreichen
4. **Netzwerk-Problem**: Portainer kann nicht mit dem Docker-Daemon kommunizieren

## Nächste Schritte

1. Logs überwachen beim Klick auf "local"
2. Fehlermeldung notieren
3. API-Endpunkte prüfen
4. Falls nötig: Portainer Agent verwenden oder neu installieren


