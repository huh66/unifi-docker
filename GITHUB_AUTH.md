# GitHub Authentifizierung - Lösung

GitHub unterstützt seit 2021 keine Passwort-Authentifizierung mehr. Sie haben zwei Optionen:

## Option 1: Personal Access Token (PAT) - Einfachste Lösung

### Schritt 1: Token erstellen

1. Gehen Sie zu: https://github.com/settings/tokens
2. Klicken Sie auf **"Generate new token"** → **"Generate new token (classic)"**
3. Geben Sie einen Namen ein: z.B. `unifi-docker-push`
4. Wählen Sie die Ablaufzeit (z.B. "No expiration" oder 90 Tage)
5. **WICHTIG**: Aktivieren Sie den Scope **`repo`** (ganz oben)
6. Scrollen Sie nach unten und klicken Sie auf **"Generate token"**
7. **KOPIEREN SIE DEN TOKEN SOFORT** - er wird nur einmal angezeigt!

### Schritt 2: Remote-URL setzen

```bash
cd /home/huh/unifi-docker

# Ersetzen Sie USERNAME und REPO-NAME mit Ihren Werten
git remote set-url origin https://USERNAME:TOKEN@github.com/USERNAME/REPO-NAME.git
```

**Beispiel:**
```bash
git remote set-url origin https://hans:ghp_xxxxxxxxxxxx@github.com/hans/unifi-docker.git
```

### Schritt 3: Pushen

```bash
git push -u origin main
```

**Hinweis**: Der Token ist jetzt in der URL gespeichert. Für mehr Sicherheit können Sie stattdessen einen Credential Helper verwenden (siehe unten).

---

## Option 2: SSH verwenden (Sicherer, empfohlen)

### Schritt 1: SSH-Schlüssel erstellen

```bash
# SSH-Schlüssel generieren (falls noch nicht vorhanden)
ssh-keygen -t ed25519 -C "ihre-email@example.com"

# Öffentlichen Schlüssel anzeigen
cat ~/.ssh/id_ed25519.pub
```

### Schritt 2: SSH-Schlüssel zu GitHub hinzufügen

1. Kopieren Sie den gesamten Inhalt von `~/.ssh/id_ed25519.pub`
2. Gehen Sie zu: https://github.com/settings/keys
3. Klicken Sie auf **"New SSH key"**
4. Titel: z.B. "Mein Computer"
5. Fügen Sie den Schlüssel ein und speichern Sie

### Schritt 3: Remote auf SSH umstellen

```bash
cd /home/huh/unifi-docker

# Ersetzen Sie USERNAME und REPO-NAME
git remote set-url origin git@github.com:USERNAME/REPO-NAME.git
```

### Schritt 4: Pushen

```bash
git push -u origin main
```

---

## Option 3: Git Credential Helper (Sicherste Methode für HTTPS)

Wenn Sie HTTPS mit Token verwenden möchten, aber den Token nicht in der URL speichern wollen:

### Schritt 1: Token erstellen (wie in Option 1)

### Schritt 2: Credential Helper konfigurieren

```bash
# Credential Helper aktivieren
git config --global credential.helper store

# Oder für nur dieses Repository:
cd /home/huh/unifi-docker
git config credential.helper store
```

### Schritt 3: Remote-URL setzen (ohne Token)

```bash
git remote set-url origin https://github.com/USERNAME/REPO-NAME.git
```

### Schritt 4: Pushen (Token wird beim ersten Mal abgefragt)

```bash
git push -u origin main
```

Bei der Abfrage:
- **Username**: Ihr GitHub-Benutzername
- **Password**: Ihr Personal Access Token (nicht Ihr GitHub-Passwort!)

Der Token wird dann gespeichert und muss nicht mehr eingegeben werden.

---

## Aktuelle Remote-URL prüfen

```bash
cd /home/huh/unifi-docker
git remote -v
```

## Remote-URL ändern

```bash
# HTTPS mit Token in URL (einfach, aber weniger sicher)
git remote set-url origin https://USERNAME:TOKEN@github.com/USERNAME/REPO-NAME.git

# HTTPS ohne Token (Token wird abgefragt)
git remote set-url origin https://github.com/USERNAME/REPO-NAME.git

# SSH (empfohlen)
git remote set-url origin git@github.com:USERNAME/REPO-NAME.git
```

---

## Empfehlung

**Für Einmalige Nutzung**: Option 1 (Token in URL)  
**Für regelmäßige Nutzung**: Option 2 (SSH) oder Option 3 (Credential Helper)

