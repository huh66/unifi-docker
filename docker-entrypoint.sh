#!/bin/bash
set -e

# UniFi Datenverzeichnis erstellen und Berechtigungen setzen
mkdir -p /usr/lib/unifi/data
chown -R unifi:unifi /usr/lib/unifi/data

# WICHTIG: Port 8080 für Device Adoption konfigurieren
# Falls system.properties existiert, Port auf 8080 setzen
if [ -f /usr/lib/unifi/data/system.properties ]; then
    # Entferne alte Port-Konfiguration (8081)
    sed -i '/^unifi\.http\.port=/d' /usr/lib/unifi/data/system.properties
    # Füge Port 8080 hinzu
    echo "unifi.http.port=8080" >> /usr/lib/unifi/data/system.properties
    chown unifi:unifi /usr/lib/unifi/data/system.properties
fi

# UniFi starten (startet automatisch seine eigene MongoDB-Instanz)
echo "Starte UniFi Network Application..."
/etc/init.d/unifi start

# Warte kurz, bis UniFi gestartet ist
sleep 10

# Im Vordergrund laufen lassen und Logs anzeigen
echo "UniFi läuft. Logs werden angezeigt..."
tail -f /usr/lib/unifi/logs/server.log

