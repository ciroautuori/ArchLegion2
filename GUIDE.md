# Guida all'Installazione di ArchLegion2

## 🚀 Introduzione
Questa guida ti accompagnerà passo dopo passo nell'installazione di Arch Linux con il set di ottimizzazioni e configurazioni di ArchLegion2. Il processo è stato progettato per essere modulare e flessibile.

## 📋 Prerequisiti
- Una chiavetta USB da almeno 4GB
- Connessione a Internet stabile
- Backup di tutti i dati importanti
- Almeno 50GB di spazio su disco

## 🔧 Preparazione del Supporto di Installazione

### 1. Scaricare l'immagine ISO di Arch Linux
```bash
wget https://archlinux.org/iso/latest/archlinux-YYYY.MM.DD-x86_64.iso
```

### 2. Creare la chiavetta USB avviabile
**Su Linux:**
```bash
sudo dd bs=4M if=archlinux-YYYY.MM.DD-x86_64.iso of=/dev/sdX status=progress oflag=sync
```

**Su Windows:**
Usare Rufus o balenaEtcher per creare la chiavetta avviabile.

## 🖥️ Installazione di Base

### 1. Avvio dal supporto USB
- Riavvia il computer
- Entra nel menu di avvio (solitamente F12, F2 o Canc)
- Seleziona la chiavetta USB

### 2. Configurazione della tastiera
```bash
loadkeys it
```

### 3. Connessione a Internet
**Wi-Fi:**
```bash
iwctl
station wlan0 connect "nome-rete"
```

**Cavo Ethernet:**
Dovrebbe connettersi automaticamente.

### 4. Partizionamento del disco
```bash
cfdisk /dev/nvme0n1  # o /dev/sda per dischi SATA
```

**Struttura consigliata:**
- `/dev/nvme0n1p1` - EFI (500MB, tipo EFI System)
- `/dev/nvme0n1p2` - Swap (dimensione RAM)
- `/dev/nvme0n1p3` - Root (il resto dello spazio)

### 5. Formattazione e montaggio
```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot/EFI
mount /dev/nvme0n1p1 /mnt/boot/EFI
swapon /dev/nvme0n1p2
```

### 6. Installazione del sistema base
```bash
pacstrap /mnt base base-devel linux linux-firmware vim nano
```

### 7. Generazione dell'fstab
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

### 8. Chroot nel nuovo sistema
```bash
arch-chroot /mnt
```

## 🛠️ Configurazione del Sistema

### 1. Impostazione del fuso orario
```bash
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
```

### 2. Localizzazione
```bash
sed -i 's/#it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=it_IT.UTF-8" > /etc/locale.conf
export LANG=it_IT.UTF-8
```

### 3. Tastiera italiana
```bash
echo "KEYMAP=it" > /etc/vconsole.conf
```

### 4. Nome host
```bash
echo "archlegion" > /etc/hostname
```

### 5. Configurazione di rete
```bash
pacman -S networkmanager
systemctl enable NetworkManager
```

### 6. Impostazione della password di root
```bash
passwd
```

### 7. Creazione utente
```bash
useradd -m -G wheel -s /bin/zsh ciroautuori
passwd ciroautuori
```

### 8. Configurazione dei permessi sudo
```bash
EDITOR=nano visudo
```
Scommentare la riga:
```
%wheel ALL=(ALL) ALL
```

### 9. Installazione del bootloader
```bash
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## 🖥️ Configurazione Avanzata con ArchLegion2

### 1. Uscire dal chroot e riavviare
```bash
exit
umount -R /mnt
reboot
```

### 2. Accedere con il nuovo utente
```
Login: ciroautuori
Password: [tua password]
```

### 3. Clonare il repository ArchLegion2
```bash
git clone https://github.com/ciroautuori/ArchLegion2.git
cd ArchLegion2/scripts
```

### 4. Eseguire gli script in ordine
```bash
# 1. Configurazione di base
sudo bash bootstrap.sh

# 2. Configurazione grafica
sudo bash graphical_setup.sh

# 3. Installazione applicazioni
bash apps_install.sh

# 4. Ottimizzazioni finali
sudo bash optimizations.sh
```

## 🎉 Installazione Completata
Riavvia il sistema per applicare tutte le modifiche.

## 🔧 Risoluzione dei Problemi

### Problemi con NVIDIA
Se hai problemi con la scheda video NVIDIA:
1. Verifica che i driver siano installati correttamente
2. Controlla i log di Optimus Manager
3. Riavvia il servizio di display

### Problemi di rete
```bash
sudo systemctl restart NetworkManager
```

### Gestione Segreti e Credenziali

#### GNOME Keyring
Lo script configura automaticamente il keyring di sistema per gestire in sicurezza:
- Password delle connessioni di rete e VPN
- Chiavi SSH
- Credenziali delle applicazioni

Il keyring si sbloccherà automaticamente all'accesso con la tua password utente.

#### Configurazione VPN
Sono stati installati i seguenti pacchetti VPN:
- `networkmanager-openvpn`: Supporto OpenVPN per NetworkManager
- `openvpn`: Client VPN
- `network-manager-applet`: Interfaccia grafica per gestire le connessioni

**Per configurare una VPN:**

### Configurazione Automatica (durante l'installazione)
Lo script `apps_install.sh` installerà automaticamente tutto il necessario.

### Configurazione con Script Dedicato

Abbiamo creato uno script dedicato per la configurazione di ProtonVPN Free. Ecco come usarlo:

1. Rendi eseguibile lo script:
   ```bash
   chmod +x ~/ArchLegion2/scripts/vpn_setup.sh
   ```

2. Esegui lo script con i permessi di amministratore:
   ```bash
   sudo ~/ArchLegion2/scripts/vpn_setup.sh
   ```

3. Segui le istruzioni a schermo per completare la configurazione

4. Dopo l'installazione, modifica il file di configurazione per inserire le tue credenziali:
   ```bash
   nano ~/.config/protonvpn-cli/protonvpn_cli.cfg
   ```

### Comandi Utili

Dopo la configurazione, puoi usare questi comandi rapidi:

```bash
# Connettiti a un server gratuito
protonvpn-connect

# Verifica lo stato della connessione
protonvpn-status

# Disconnettiti
protonvpn-disconnect
```

### Configurazione Manuale (solo se necessario)

Se preferisci configurare manualmente:

1. Installa i pacchetti richiesti:
   ```bash
   sudo pacman -S --noconfirm networkmanager-openvpn openvpn network-manager-applet
   ```

2. Riavvia NetworkManager:
   ```bash
   sudo systemctl restart NetworkManager
   ```

3. Configura manualmente la connessione VPN attraverso l'interfaccia grafica di NetworkManager

### Verifica dell'installazione
Per verificare che i pacchetti siano installati correttamente:
```bash
pacman -Qs openvpn networkmanager-openvpn network-manager-applet
```

### Problemi con AUR
Lo script `apps_install.sh` installerà automaticamente yay se non è già presente. Se incontri problemi:
1. Verifica la connessione a Internet
2. Assicurati di avere i pacchetti di base per la compilazione installati:
   ```bash
   sudo pacman -S --needed base-devel git
   ```
3. Se il problema persiste, puoi installare yay manualmente:
   ```bash
   git clone https://aur.archlinux.org/yay.git
   cd yay
   makepkg -si
   ```

## 📞 Supporto
Per problemi o domande, apri una issue su GitHub o contattami su Telegram: @tuo_username
