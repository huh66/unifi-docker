# Checkliste für GitHub-Veröffentlichung

## ✅ Vor der Veröffentlichung prüfen:

- [x] `.gitignore` erstellt - schließt `.deb` Dateien aus
- [x] `LICENSE` Datei hinzugefügt - MIT License für eigene Skripte
- [x] `README.md` aktualisiert - mit Lizenzhinweisen und Download-Anweisungen
- [ ] **WICHTIG**: `.deb` Datei ist NICHT im Repository (wird durch `.gitignore` ausgeschlossen)
- [ ] Repository-Name wählen (z.B. `unifi-docker` oder `unifi-network-docker`)
- [ ] Optional: GitHub Repository erstellen und initialisieren

## 📋 Befehle für GitHub-Veröffentlichung:

```bash
cd /home/huh/unifi-docker

# Git Repository initialisieren (falls noch nicht geschehen)
git init

# Alle Dateien hinzufügen (.deb wird durch .gitignore automatisch ausgeschlossen)
git add .

# Erste Commit
git commit -m "Initial commit: UniFi Network Application Docker setup"

# GitHub Repository erstellen (auf github.com) und dann:
git remote add origin https://github.com/IHR-USERNAME/IHR-REPO-NAME.git
git branch -M main
git push -u origin main
```

## ⚠️ Wichtige Hinweise:

1. **NIEMALS** das `.deb` File committen oder pushen
2. Prüfen Sie vor dem Push: `git status` - sollte KEINE `.deb` Dateien zeigen
3. Falls `.deb` Dateien angezeigt werden: `git rm --cached *.deb`
4. Die `.gitignore` Datei sollte bereits `.deb` Dateien ausschließen

## 📝 Empfohlene Repository-Beschreibung:

```
Docker setup for Ubiquiti UniFi Network Application 9.5.21 on Debian 12

⚠️ The UniFi .deb package is NOT included - download from https://www.ui.com/download/unifi
```

## 🔗 Nützliche Links:

- [Ubiquiti UniFi Download](https://www.ui.com/download/unifi)
- [Ubiquiti Terms of Service](https://www.ui.com/legal/terms-of-service)
- [MIT License](https://opensource.org/licenses/MIT)

