# Portainer Problem - Gelöste Lösung

## Problem
Portainer zeigte die "local" Umgebung als "Down" an mit der Fehlermeldung:
- `GET https://hansi:9443/api/endpoints/X/docker/v1.41/_ping 400 (Bad Request)`
- "The environment named local is unreachable"

## Ursache
**Docker API Versions-Inkompatibilität:**
- Portainer 2.21.5 (und auch 2.33.4) verwendet Docker API v1.41
- Docker 29.0.3 benötigt mindestens API v1.44
- Fehler: "client version 1.41 is too old. Minimum supported API version is 1.44"

## Lösung: Portainer Agent

Der Portainer Agent umgeht das API-Versionsproblem, indem er als Vermittler zwischen Portainer und Docker fungiert.

### Installation

```bash
# Portainer Agent installieren
sudo docker run -d \
  --name portainer-agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -p 9001:9001 \
  portainer/agent:latest
```

### Konfiguration in Portainer

1. Öffnen Sie Portainer: http://localhost:9000 oder https://localhost:9443
2. "Add environment" → "Docker (Standalone)"
3. Wählen Sie **"Use Portainer Agent"**
4. Agent URL: `http://localhost:9001` (oder `http://hansi:9001`)
5. Klicken Sie auf "Connect"

## Aktuelle Konfiguration

- **Portainer**: 2.33.4 (läuft mit `--privileged`)
- **Portainer Agent**: latest (läuft auf Port 9001)
- **Docker**: 29.0.3 (API 1.52)
- **Docker Socket**: `/var/run/docker.sock` (Berechtigungen: 666)

## Vorteile des Agents

1. ✅ Umgeht API-Versionsprobleme
2. ✅ Bessere Sicherheit (Agent läuft isoliert)
3. ✅ Unterstützt Remote-Environments
4. ✅ Funktioniert mit neuesten Docker-Versionen

## Wartung

### Agent neu starten
```bash
sudo docker restart portainer-agent
```

### Agent Logs prüfen
```bash
sudo docker logs portainer-agent
```

### Beide Container neu starten
```bash
sudo docker restart portainer portainer-agent
```

## Hinweis

Falls Sie Portainer in Zukunft aktualisieren, stellen Sie sicher, dass der Agent ebenfalls läuft, wenn Sie Docker 29.x oder neuer verwenden.

