# 2. Pre-Installation

Before you can install Arch Linux, you need to prepare your system. This section covers the essential steps for setting up a dual-boot environment with Windows, creating a bootable USB drive, and configuring your system's BIOS/UEFI.

---

## 2.1 Preparing Windows for Dual-Boot

If you plan to install Arch Linux alongside Windows, you must first prepare your Windows installation to make space for Arch.

### Step 1: Disable Fast Startup in Windows

Fast Startup is a feature in Windows that allows for quicker boot times, but it can interfere with other operating systems accessing the disk. It's crucial to disable it.

1.  Open the **Control Panel** in Windows.
2.  Go to **Power Options**.
3.  Click on **"Choose what the power buttons do"**.
4.  Click on **"Change settings that are currently unavailable"**.
5.  Uncheck the box for **"Turn on fast startup (recommended)"** and save the changes.

### Step 2: Shrink the Windows Partition

You need to create unallocated space on your drive for the Arch Linux installation. This is done from within Windows using the Disk Management tool.

1.  Right-click the Start menu and select **Disk Management**.
2.  Right-click on your main Windows partition (usually `C:`).
3.  Select **"Shrink Volume..."**.
4.  Enter the amount of space you want to free up for Arch Linux (in MB). A minimum of 50GB (51200 MB) is recommended, but more is better.
5.  Click **"Shrink"**. This will create a new "Unallocated" space on your drive.

**Important:** Do not format this new unallocated space. The Arch Linux installer will handle it.

---

## 2.2 Creating a Bootable Arch Linux USB

To install Arch Linux, you need to create a bootable USB drive from the official ISO file.

1.  **Download the ISO:** Get the latest Arch Linux ISO from the [official download page](https://archlinux.org/download/).
2.  **Use a Flashing Tool:** Use a tool like [Rufus](https://rufus.ie/) or [balenaEtcher](https://www.balena.io/etcher/) to write the ISO to your USB drive.
    *   In Rufus, select the ISO and your USB drive. Make sure to choose **"DD Image mode"** when prompted.
    *   In Etcher, simply select the ISO and the USB drive, and it will handle the rest.

---

## 2.3 BIOS/UEFI Configuration

To boot from the USB drive, you may need to change some settings in your laptop's BIOS/UEFI.

1.  **Enter BIOS/UEFI:** Restart your computer and press the appropriate key to enter the BIOS setup (usually `F2`, `F12`, or `Del` on the Lenovo Legion Y520).
2.  **Disable Secure Boot:** Find the **Secure Boot** option (usually under the "Security" or "Boot" tab) and set it to **Disabled**. Secure Boot can prevent non-Windows operating systems from booting.
3.  **Set Boot Order:** Go to the **Boot** tab and change the boot order to prioritize your USB drive.
4.  **Save and Exit:** Save your changes and exit the BIOS. Your computer should now boot from the Arch Linux USB drive.
