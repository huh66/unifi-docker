# UniFi Device Adoption - Ports Konfiguration

## Problem
Device Adoption funktioniert nicht im Docker-Container, aber funktioniert in der lokalen Installation.

## Lösung
Die Port-Konfiguration der funktionierenden lokalen Installation wurde auf Docker übertragen.

## Ports der lokalen Installation (funktioniert)

### TCP Ports:
- **8080**: Device/controller communication (Inform-Protokoll) - **ESSENTIELL für Adoption!**
- **8443**: Controller GUI/API
- **8843**: HTTPS portal redirection
- **8880**: HTTP portal redirection
- **6789**: Speed test

### UDP Ports:
- **10001**: AP discovery - **ESSENTIELL für Adoption!**
- **3478**: STUN
- **5514**: Syslog

## Docker-Konfiguration (angepasst)

### docker-compose.yml
```yaml
ports:
  # ESSENTIELL für Device Adoption:
  - "8080:8080/tcp"    # Device/controller communication (Inform-Protokoll)
  - "8443:8443/tcp"    # Controller GUI/API
  - "10001:10001/udp"  # AP discovery
  # Weitere Ports:
  - "8880:8880/tcp"    # HTTP portal redirection
  - "8843:8843/tcp"    # HTTPS portal redirection
  - "1900:1900/udp"    # SSDP (UPnP)
```

### Wichtige Änderungen

1. **Port 8080 statt 8081**: 
   - UniFi muss auf Port 8080 lauschen (nicht 8081)
   - Geräte erwarten standardmäßig Port 8080 für das Inform-Protokoll

2. **system.properties automatisch konfigurieren**:
   - `docker-entrypoint.sh` setzt automatisch `unifi.http.port=8080`
   - Dies wird bei jedem Container-Start durchgeführt

3. **Healthcheck angepasst**:
   - Prüft jetzt Port 8080 statt 8081

## Verifikation

Nach dem Start des Containers prüfen:
```bash
# Ports im Container
sudo docker exec unifi-controller netstat -tlnp | grep -E "(8080|8443)"

# Ports von außen
curl -k https://localhost:8443
curl http://localhost:8080

# Konfiguration
sudo docker exec unifi-controller cat /usr/lib/unifi/data/system.properties | grep unifi.http.port
```

## Wichtige Hinweise

1. **Port 8080 ist ESSENTIELL**: Geräte kommunizieren über Port 8080 mit dem Controller
2. **Port 10001/udp ist ESSENTIELL**: Für die Discovery von Access Points
3. **Lokale Installation stoppen**: Bevor Docker-Container startet, muss lokale Installation gestoppt sein (Port-Konflikt)

## Troubleshooting

Falls Device Adoption weiterhin nicht funktioniert:

1. Prüfen Sie, ob Port 8080 wirklich geöffnet ist:
   ```bash
   sudo docker port unifi-controller | grep 8080
   ```

2. Prüfen Sie die system.properties:
   ```bash
   sudo docker exec unifi-controller cat /usr/lib/unifi/data/system.properties | grep http.port
   ```
   Sollte zeigen: `unifi.http.port=8080`

3. Prüfen Sie die Logs:
   ```bash
   sudo docker logs unifi-controller | grep -i "port\|8080\|adopt"
   ```

4. Prüfen Sie, ob UniFi im Container auf Port 8080 lauscht:
   ```bash
   sudo docker exec unifi-controller netstat -tlnp | grep 8080
   ```

