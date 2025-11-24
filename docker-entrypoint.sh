#!/bin/bash
set -e

# UniFi Datenverzeichnis erstellen und Berechtigungen setzen
mkdir -p /usr/lib/unifi/data
chown -R unifi:unifi /usr/lib/unifi/data

# UniFi starten (startet automatisch seine eigene MongoDB-Instanz)
echo "Starte UniFi Network Application..."
/etc/init.d/unifi start

# Warte kurz, bis UniFi gestartet ist
sleep 10

# Im Vordergrund laufen lassen und Logs anzeigen
echo "UniFi läuft. Logs werden angezeigt..."
tail -f /usr/lib/unifi/logs/server.log

