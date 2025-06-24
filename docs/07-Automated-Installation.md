# 7. Automated Installation

For a faster and more streamlined setup, this guide provides automation scripts to handle the bulk of the installation and configuration process. This section details how to use them.

**Disclaimer:** While these scripts automate the process, it is still highly recommended to read through the manual installation sections to understand what they are doing.

---

## 1. Automated Base Installation with `archinstall`

The `archinstall` script is an official guided installer for Arch Linux. We provide a custom configuration file that pre-fills most of the options for a typical ArchLegion2 setup.

### Step 1: Download the Scripts

From the Arch Linux live environment, download the ArchLegion2 repository:

```bash
git clone https://github.com/your-username/ArchLegion2.git
```

### Step 2: Review and Edit the Configuration

Navigate to the `scripts` directory and review the `user_configuration.json` file. You **must** change the default password.

```bash
nano ArchLegion2/scripts/user_configuration.json
```

### Step 3: Run `archinstall`

Run the `archinstall` script, passing our custom configuration file as an argument:

```bash
archinstall --config ArchLegion2/scripts/user_configuration.json
```

The installer will proceed automatically. Note that the default disk configuration will wipe the entire disk. For dual-booting, it is still recommended to follow the manual partitioning guide first, then adapt the `archinstall` configuration accordingly.

---

## 2. Post-Installation & Optimization Script

After `archinstall` completes and you have rebooted into your new system, the final step is to run our post-installation script. This will apply the specific hardware optimizations for the Lenovo Legion Y520.

### Step 1: Navigate to the Script

Open a terminal and navigate to where you have the `ArchLegion2` repository cloned.

```bash
cd ArchLegion2/scripts
```

### Step 2: Run the Script

Execute the `post_install.sh` script with `sudo` privileges:

```bash
sudo ./post_install.sh
```

The script will automatically:
*   Set the CPU governor to `performance`.
*   Enable `os-prober` for dual-boot detection.
*   Update the GRUB configuration.
*   Disable any problematic services.

After the script finishes, it is recommended to reboot one last time to ensure all changes are applied.
