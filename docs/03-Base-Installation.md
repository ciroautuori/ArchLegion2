# 3. Base Installation

This section covers the core installation process for Arch Linux. We will partition the disk, format the new partitions, and install the base system.

---

## 3.1 Booting and Initial Setup

After configuring your BIOS/UEFI, your computer will boot into the Arch Linux live environment. You will be greeted with a command-line interface.

### Step 1: Set Keyboard Layout

The default keyboard layout is US. To change it, use the `loadkeys` command. For example, for an Italian layout:

```bash
loadkeys it
```

### Step 2: Verify Boot Mode

Ensure you have booted in UEFI mode by checking for the existence of the `efivars` directory:

```bash
ls /sys/firmware/efi/efivars
```

If the directory exists, you are in UEFI mode. If not, you may need to re-check your BIOS settings.

### Step 3: Connect to the Internet

An internet connection is required to download packages. 

*   **For Ethernet:** The connection should work automatically. 
*   **For Wi-Fi:** Use the `iwctl` utility to connect to a wireless network.

Verify your connection with `ping`:

```bash
ping -c 3 archlinux.org
```

### Step 4: Update the System Clock

Ensure the system clock is accurate:

```bash
timedatectl set-ntp true
```

---

## 3.2 Disk Partitioning

This is the most critical step. We will use `cfdisk` to partition the unallocated space we created earlier. The target disk will likely be `/dev/nvme0n1` if you are using an NVMe SSD.

```bash
cfdisk /dev/nvme0n1
```

Inside `cfdisk`, you will see your existing Windows partitions and the unallocated space. We will create the following partitions in that free space.

**Recommended Dual-Boot Partition Scheme:**

1.  **Root (`/`)**: 
    *   **Size**: At least 50GB. This is where the core OS will reside.
    *   **Type**: `Linux filesystem`

2.  **Home (`/home`)**: 
    *   **Size**: The majority of the remaining space. This is for your personal files.
    *   **Type**: `Linux filesystem`

3.  **Swap**:
    *   **Size**: A sensible amount, typically equal to your RAM (e.g., 8GB or 16GB).
    *   **Type**: `Linux swap`

**Note:** You do **NOT** need to create a new EFI partition. We will use the existing one created by Windows.

After creating the partitions, select **Write**, confirm, and then **Quit**.

---

## 3.3 Formatting and Mounting Partitions

Next, we need to format our new partitions and mount them correctly.

### Step 1: Format the Partitions

Assuming your new partitions are `/dev/nvme0n1pX`, `/dev/nvme0n1pY`, and `/dev/nvme0n1pZ`:

```bash
# Format the Root partition (e.g., nvme0n1p5)
mkfs.ext4 /dev/nvme0n1p5

# Format the Home partition (e.g., nvme0n1p6)
mkfs.ext4 /dev/nvme0n1p6

# Initialize the Swap partition (e.g., nvme0n1p7)
mkswap /dev/nvme0n1p7
```

### Step 2: Mount the Partitions

Mount the filesystems to the `/mnt` directory.

```bash
# Mount the Root partition
mount /dev/nvme0n1p5 /mnt

# Create and mount the Home directory
mkdir /mnt/home
mount /dev/nvme0n1p6 /mnt/home

# Mount the existing Windows EFI partition
# First, find it with `lsblk`. It's usually the first partition.
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi  # Replace nvme0n1p1 with your EFI partition

# Activate Swap
swapon /dev/nvme0n1p7
```

---

## 3.4 Installing the Base System

With the partitions mounted, we can now install the Arch Linux base system, the kernel, and essential firmware.

```bash
pacstrap /mnt base linux linux-firmware
```

This command will download and install all the necessary packages. This may take some time depending on your internet connection.
