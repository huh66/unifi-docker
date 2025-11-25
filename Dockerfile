FROM debian:12-slim

# Metadaten
LABEL maintainer="UniFi Network Application"
LABEL description="UniFi Network Application 9.5.21 mit allen Abhängigkeiten"

# Umgebungsvariablen
ENV DEBIAN_FRONTEND=noninteractive
ENV UNIFI_VERSION=9.5.21-31260-1

# Arbeitsverzeichnis
WORKDIR /tmp

# Repository für libssl1.1 hinzufügen (benötigt für MongoDB)
RUN echo "deb http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list.d/bullseye-security.list

# MongoDB Repository hinzufügen
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" > /etc/apt/sources.list.d/mongodb-org-7.0.list

# Alle Abhängigkeiten installieren
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Basis-Abhängigkeiten
    binutils \
    coreutils \
    adduser \
    libcap2 \
    logrotate \
    debconf \
    # Java Runtime
    openjdk-17-jre-headless \
    ca-certificates-java \
    java-common \
    # MongoDB Abhängigkeit
    libssl1.1 \
    # MongoDB
    mongodb-org-server \
    # Weitere Tools
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# UniFi Network Application installieren
# Hinweis: Das .deb File muss beim Build als Build-Argument oder per COPY bereitgestellt werden
# Beispiel: docker build --build-arg UNIFI_DEB=unifi_sysvinit_all.deb -t unifi:9.5.21 .
ARG UNIFI_DEB
COPY ${UNIFI_DEB} /tmp/unifi.deb
RUN dpkg -i /tmp/unifi.deb || true && \
    apt-get install -f -y && \
    rm -f /tmp/unifi.deb

# UniFi Datenverzeichnis erstellen
RUN mkdir -p /usr/lib/unifi/data && \
    chown -R unifi:unifi /usr/lib/unifi/data

# Ports freigeben
# Standard: 8080 (HTTP), 8443 (HTTPS), 8880 (Portal HTTP), 8843 (Portal HTTPS), 27117 (MongoDB)
# Kann in system.properties angepasst werden
EXPOSE 8080 8081 8443 8880 8843 27117/udp 5656/udp 10001/udp

# Volumes für persistente Daten
VOLUME ["/usr/lib/unifi/data"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/inform || exit 1

# Startskript
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["unifi"]

