#!/bin/bash
# Script per l'installazione di ProtonVPN

set -e  # Esci in caso di errore

# Colori per il terminale
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Funzione per mostrare messaggi di stato
status() {
    echo -e "${GREEN}[*]${NC} $1"
}

error() {
    echo -e "${RED}[!] Errore:${NC} $1"
    exit 1
}

# Verifica se lo script è eseguito come root
if [ "$(id -u)" -ne 0 ]; then
    error "Esegui questo script con sudo"
fi

# Aggiorna il sistema e installa le dipendenze
status "Aggiornamento del sistema..."
pacman -Syu --noconfirm

# Verifica se pip3 è installato
if ! command -v pip3 &> /dev/null; then
    status "Installazione di python-pip..."
    pacman -S --noconfirm python-pip
fi

# Installa pipx per gestire pacchetti Python
status "Installazione di pipx..."
pacman -S --noconfirm python-pipx

# Configura il PATH per pipx
status "Configurazione di pipx..."
sudo -u $SUDO_USER pipx ensurepath

# Installa ProtonVPN CLI con pipx
status "Installazione di ProtonVPN CLI..."
sudo -u $SUDO_USER pipx install protonvpn-cli

# Crea il file di configurazione
status "Configurazione di ProtonVPN..."
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
mkdir -p $USER_HOME/.config/protonvpn

# Configura le credenziali
cat > $USER_HOME/.config/protonvpn/config << EOL
[USER]
username = bfiltoperator@gmail.com
password = MagicoEros89@

[VPN]
protocol = udp

dns_leak_protection = True
killswitch = True
EOL

# Imposta i permessi corretti
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.config/protonvpn
chmod 600 $USER_HOME/.config/protonvpn/config

# Crea alias per comandi rapidi
echo "" >> $USER_HOME/.zshrc
echo "# Alias per ProtonVPN" >> $USER_HOME/.zshrc
echo "alias protonvpn-connect='protonvpn-cli connect -f'" >> $USER_HOME/.zshrc
echo "alias protonvpn-status='protonvpn-cli status'" >> $USER_HOME/.zshrc
echo "alias protonvpn-disconnect='protonvpn-cli disconnect'" >> $USER_HOME/.zshrc

status "Installazione completata!"
echo "Per usare ProtonVPN:"
echo "1. Connettiti: protonvpn-connect"
echo "2. Verifica: protonvpn-status"
echo "3. Disconnetti: protonvpn-disconnect"

exit 0
