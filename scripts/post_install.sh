#!/bin/bash

# ArchLegion2 Post-Installation & Optimization Script
# This script automates the configuration and optimization steps
# detailed in the ArchLegion2 guide.

# --- Ensure the script is run as root ---
echo "Checking for root privileges..."
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please use sudo." 
   exit 1
fi
echo "Root privileges confirmed."

# --- Configure CPU for Performance ---
echo "\nConfiguring CPU for maximum performance..."
if grep -q "^governor=" /etc/default/cpupower; then
    sed -i "s/^governor=.*/governor='performance'/" /etc/default/cpupower
else
    echo "governor='performance'" >> /etc/default/cpupower
fi
systemctl enable --now cpupower.service
echo "cpupower service configured and enabled."

# --- Configure GRUB for Dual-Boot ---
echo "\nConfiguring GRUB to detect other operating systems..."
if grep -q "^#GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
    sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
fi
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB configured for dual-boot."

# --- Desktop Environment Selection ---
echo "\n--- Desktop Environment Selection ---"
PS3='Please choose your desired desktop environment: '
options=("XFCE4 (Recommended)" "Sway (Wayland)" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "XFCE4 (Recommended)")
            echo "Installing XFCE4..."
            ../configs/xfce4/install.sh
            break
            ;;
        "Sway (Wayland)")
            echo "Installing Sway..."
            ../configs/sway/install.sh
            break
            ;;
        "Quit")
            break
            ;;
        *)
           echo "Invalid option $REPLY"
           ;;
    esac
done

# --- Final System Checks & Cleanup ---
echo "\nPerforming final system checks..."
if systemctl list-unit-files | grep -q 'waydroid-net.service'; then
    systemctl disable waydroid-net.service
    echo "Disabled problematic waydroid-net.service."
fi
systemctl enable NetworkManager.service
echo "NetworkManager.service is enabled."


echo "\n----------------------------------------------------"
echo "Post-installation script completed successfully!"
echo "It is recommended to reboot your system now."
echo "----------------------------------------------------"

exit 0
