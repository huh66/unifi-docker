# Device Adoption Problem - Lösung

## Problem
Device Adoption funktioniert nicht im Docker-Container, obwohl alle Ports korrekt geöffnet sind.

## Ursache
Der Docker-Container kennt nicht die IP-Adresse des Hosts. Wenn ein Gerät adoptiert werden soll, teilt der Controller dem Gerät mit, welche IP-Adresse es für die Verbindung verwenden soll. Im Docker-Container wird jedoch die interne Container-IP verwendet, nicht die Host-IP, die die Geräte im Netzwerk erreichen können.

## Lösung
Die Controller-IP-Adresse muss manuell in den UniFi-Einstellungen konfiguriert werden.

### Schritte:

1. **Öffnen Sie die UniFi-Web-Oberfläche:**
   ```
   https://hansi:8443
   ```

2. **Navigieren Sie zu den Einstellungen:**
   - Settings (Einstellungen)
   - System (System)
   - Advanced (Erweitert)

3. **Aktivieren Sie "Override Inform Host":**
   - Aktivieren Sie das Kontrollkästchen "Override Inform Host"

4. **Setzen Sie die Controller Hostname/IP:**
   - Tragen Sie die IP-Adresse des Hosts ein (nicht die Container-IP!)
   - Beispiel: `192.168.1.100` (Ihre tatsächliche Host-IP)

5. **Speichern Sie die Einstellungen**

6. **Starten Sie den Docker-Container neu:**
   ```bash
   cd /home/huh/unifi-docker
   sudo docker compose restart
   ```

### Host-IP-Adresse ermitteln:
```bash
hostname -I | awk '{print $1}'
```

### Verifikation:
Nach der Konfiguration sollten die Geräte die richtige IP-Adresse sehen:
- Status: Connected (http://192.168.1.X:8080/inform)

## Weitere Informationen
- [ServerFault Diskussion](https://serverfault.com/questions/1040002/cant-adopt-new-device-when-running-unifi-controller-in-docker-container)
- Die Lösung wurde von der jacobalberty/unifi Docker-Image Dokumentation übernommen

## Wichtig
- Verwenden Sie die **Host-IP**, nicht die Container-IP
- Die IP muss von den Geräten im Netzwerk erreichbar sein
- Nach der Änderung Container neu starten

