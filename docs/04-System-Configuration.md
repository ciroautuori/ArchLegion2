# 4. System Configuration

After installing the base packages, you need to configure the system. This involves generating the fstab file, chrooting into your new installation, setting system-specific configurations, and installing a bootloader.

---

## 4.1 Generate fstab

The `fstab` file defines how disk partitions are mounted. Generate it automatically from your current mounts:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

After running this command, it's a good idea to verify the contents of the new `/mnt/etc/fstab` file to ensure all your partitions are listed correctly.

---

## 4.2 Chroot into the New System

Now, change root into your new system to perform configurations as if you were booted into it directly.

```bash
arch-chroot /mnt
```

Your shell prompt will change, indicating you are now inside the new installation.

---

## 4.3 Core System Setup

### Step 1: Set Timezone and Clock

Set your timezone (replace `Europe/Rome` with your own):

```bash
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
```

### Step 2: Configure Locale

This sets the language, numbering, and date formats for your system.

1.  Edit `/etc/locale.gen` and uncomment your desired locale (e.g., `en_US.UTF-8 UTF-8`).
    ```bash
    nano /etc/locale.gen
    ```
2.  Generate the locales:
    ```bash
    locale-gen
    ```
3.  Create the `locale.conf` file:
    ```bash
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    ```

### Step 3: Set Hostname

This is the name of your computer on the network.

```bash
echo "archlegion" > /etc/hostname
```

### Step 4: Set Root Password

Set a strong password for the root user:

```bash
passwd
```

---

## 4.4 Install and Configure the Bootloader (GRUB)

To boot your new system and be able to choose between Arch and Windows, you need to install and configure the GRUB bootloader.

### Step 1: Install GRUB and Other Essentials

Install GRUB, `efibootmgr` (for UEFI systems), `os-prober` (to detect Windows), and `networkmanager` (for internet access after reboot).

```bash
pacman -S grub efibootmgr os-prober networkmanager
```

### Step 2: Enable `os-prober`

For GRUB to detect your Windows installation, you must enable `os-prober`.

```bash
nano /etc/default/grub
```

Uncomment the following line:
`GRUB_DISABLE_OS_PROBER=false`

Save and exit the file.

### Step 3: Install GRUB to the EFI Partition

Run the following command to install GRUB:

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

### Step 4: Generate the GRUB Configuration File

Finally, generate the `grub.cfg` file. `os-prober` will run automatically and add an entry for Windows.

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

You should see output indicating that it found both a Linux image and the Windows Boot Manager.

---

## 4.5 Final Steps

### Step 1: Enable NetworkManager

Enable the NetworkManager service to start on boot so you have internet access automatically.

```bash
systemctl enable NetworkManager
```

### Step 2: Exit and Reboot

The base installation and configuration are complete. Exit the chroot environment and reboot your computer.

```bash
exit
umount -R /mnt
reboot
```

Remove the installation USB, and you should be greeted by the GRUB menu with options for both Arch Linux and Windows.
