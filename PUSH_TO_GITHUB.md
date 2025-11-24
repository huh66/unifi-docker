# Anleitung: Repository auf GitHub pushen

Das Git-Repository wurde erfolgreich initialisiert und der erste Commit wurde erstellt.

## ✅ Bereits erledigt:
- ✅ Git Repository initialisiert
- ✅ Alle Dateien hinzugefügt (`.deb` wird durch `.gitignore` ausgeschlossen)
- ✅ Erster Commit erstellt
- ✅ Branch auf `main` umbenannt

## 📋 Nächste Schritte:

### 1. GitHub Repository erstellen

1. Gehen Sie zu https://github.com
2. Klicken Sie auf "New repository" (oder "+" → "New repository")
3. Repository-Name wählen (z.B. `unifi-docker` oder `unifi-network-docker`)
4. **WICHTIG**: Repository als **Public** oder **Private** erstellen (Ihre Wahl)
5. **NICHT** "Initialize with README" auswählen (wir haben bereits eines)
6. Klicken Sie auf "Create repository"

### 2. Repository mit GitHub verbinden

Nach dem Erstellen zeigt GitHub Ihnen die Befehle an. Verwenden Sie diese:

```bash
cd /home/huh/unifi-docker

# GitHub Remote hinzufügen (ersetzen Sie USERNAME und REPO-NAME)
git remote add origin https://github.com/IHR-USERNAME/IHR-REPO-NAME.git

# Branch auf GitHub pushen
git push -u origin main
```

**Beispiel:**
```bash
git remote add origin https://github.com/hans/unifi-docker.git
git push -u origin main
```

### 3. Authentifizierung

Beim ersten Push werden Sie nach Ihrem GitHub-Benutzernamen und Token gefragt:
- **Username**: Ihr GitHub-Benutzername
- **Password**: Ihr GitHub Personal Access Token (nicht Ihr Passwort!)

**Personal Access Token erstellen:**
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token (classic)"
3. Name: z.B. "unifi-docker-push"
4. Scopes: `repo` aktivieren
5. Token kopieren und beim Push verwenden

### 4. Alternative: SSH verwenden

Falls Sie SSH-Schlüssel bei GitHub hinterlegt haben:

```bash
git remote set-url origin git@github.com:IHR-USERNAME/IHR-REPO-NAME.git
git push -u origin main
```

## ✅ Verifikation

Nach dem Push:
- Gehen Sie zu Ihrem GitHub Repository
- Prüfen Sie, dass alle Dateien vorhanden sind
- **WICHTIG**: Prüfen Sie, dass KEINE `.deb` Datei im Repository ist!

## 📝 Repository-Beschreibung (empfohlen)

```
Docker setup for Ubiquiti UniFi Network Application 9.5.21 on Debian 12

⚠️ The UniFi .deb package is NOT included - download from https://www.ui.com/download/unifi
```

## 🔗 Nützliche Links

- [Ubiquiti UniFi Download](https://www.ui.com/download/unifi)
- [GitHub Personal Access Tokens](https://github.com/settings/tokens)

