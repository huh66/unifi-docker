# Portainer "local" Environment Fix

## Problem
Portainer zeigt die "local" Umgebung als "Down" an mit der Meldung:
"Failed loading environment. The environment named local is unreachable"

## Ursache
Portainer hat die "local" Umgebung in seiner Datenbank als "unreachable" gespeichert, obwohl der Docker Socket korrekt gemountet ist.

## Lösung: Umgebung neu hinzufügen

### Schritt 1: Alte Umgebung entfernen
1. Öffnen Sie Portainer: http://localhost:9000 oder https://localhost:9443
2. Klicken Sie oben rechts auf Ihr Profil-Icon
3. Wählen Sie "Settings"
4. Gehen Sie zu "Environments"
5. Finden Sie die "local" Umgebung
6. Klicken Sie auf das "X" oder "Remove" Symbol, um sie zu entfernen

### Schritt 2: Neue Umgebung hinzufügen
1. Klicken Sie auf "Add environment"
2. Wählen Sie "Docker (Standalone)"
3. **Name**: `local` (oder lassen Sie den Standard)
4. **Docker API URL**: `unix:///var/run/docker.sock`
5. Klicken Sie auf "Connect"

Die Umgebung sollte jetzt als "Up" angezeigt werden.

## Alternative: Portainer-Datenbank zurücksetzen

Falls die manuelle Konfiguration nicht funktioniert, können Sie die Portainer-Datenbank zurücksetzen:

```bash
# Portainer stoppen
sudo docker stop portainer
sudo docker rm portainer

# Datenbank-Volume entfernen (ACHTUNG: Alle Einstellungen gehen verloren!)
sudo docker volume rm portainer_data

# Portainer neu starten
sudo docker run -d \
  --name portainer \
  --restart=unless-stopped \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -v portainer_data:/data \
  --group-add $(getent group docker | cut -d: -f3) \
  -p 9000:9000 \
  -p 9443:9443 \
  portainer/portainer-ce:latest
```

Nach dem Neustart müssen Sie Portainer neu einrichten (Admin-Account erstellen, etc.).

## Verifikation

Nach dem Hinzufügen der Umgebung sollten Sie:
- Die "local" Umgebung als "Up" sehen
- Alle Container sehen können (unifi-controller, zabbix-web, etc.)
- Container-Details öffnen können
- Container-Logs anzeigen können

