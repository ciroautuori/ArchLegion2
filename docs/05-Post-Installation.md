# 5. Post-Installation & Optimization

This section details the crucial post-installation steps to unlock the full potential of your Lenovo Legion Y520 on Arch Linux. We will address the most common and critical performance bottlenecks: the NVIDIA hybrid graphics and CPU power management.

---

## 5.1 NVIDIA Hybrid Graphics: The Complete Fix

The Lenovo Legion Y520 features NVIDIA Optimus technology, which requires a specific setup to work correctly. A common issue is the NVIDIA driver failing to load due to kernel mismatches. Here is the definitive solution.

### Step 1: Install NVIDIA Driver and Kernel Headers

First, ensure you have the proprietary NVIDIA driver and the headers for your current kernel installed. The `nvidia-dkms` package is recommended as it will automatically rebuild the kernel module when the kernel is updated.

```bash
sudo pacman -S nvidia-dkms linux-headers
```

**Note:** If you are using a different kernel (e.g., `linux-lts`), install the corresponding headers (`linux-lts-headers`).

### Step 2: Verify DKMS Status

After installation, DKMS should automatically build the NVIDIA module for your kernel. You can verify this by checking the DKMS status. It should show the `nvidia` module as installed for your kernel version.

```bash
dkms status
```

### Step 3: Update GRUB

If you've had to install new kernel headers, it's possible your system isn't booting the latest kernel version by default. Regenerate the GRUB configuration to ensure it detects the new kernel.

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Step 4: Reboot and Verify

A reboot is required to load the new kernel and the NVIDIA driver. After rebooting, you can verify that the NVIDIA driver is loaded correctly by running:

```bash
nvidia-smi
```

If this command returns a table with your GPU details, the driver is working correctly. You can also use `optimus-manager` to handle switching between the integrated and dedicated GPUs.

---

## 5.2 CPU Performance Tuning

By default, the Linux kernel may use a `powersave` governor for your CPU, which severely limits its performance to save energy. To get the maximum performance from your Intel i7-7700HQ, you should set the governor to `performance`.

### Step 1: Install `cpupower`

The `cpupower` utility is the standard tool for managing CPU frequency scaling. It is part of the `linux-tools` package.

```bash
sudo pacman -S cpupower
```

### Step 2: Configure the `performance` Governor

Create or edit the `cpupower` configuration file to set the default governor.

```bash
sudo nano /etc/default/cpupower
```

Add or uncomment the following line:

```sh
governor='performance'
```

### Step 3: Enable the `cpupower` Service

Enable and start the `cpupower` service to apply your configuration on boot.

```bash
sudo systemctl enable --now cpupower.service
```

### Step 4: Verify the Changes

You can immediately check if the governor has been changed by running:

```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

This command should output `performance` for every CPU core.
