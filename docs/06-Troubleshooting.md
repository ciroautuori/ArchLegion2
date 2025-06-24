# 6. Troubleshooting & FAQ

This section provides solutions to common problems you might encounter with Arch Linux on the Lenovo Legion Y520.

---

## Common Issues

### 1. NVIDIA Driver Not Loading After Reboot

*   **Symptom**: The `nvidia-smi` command fails, and the system is using the integrated Intel graphics, resulting in poor performance.
*   **Cause**: This is almost always due to a mismatch between the running kernel and the kernel headers used to build the NVIDIA driver module (`nvidia-dkms`).
*   **Solution**: Follow the steps outlined in **[Section 5.1: NVIDIA Hybrid Graphics: The Complete Fix](./05-Post-Installation.md#51-nvidia-hybrid-graphics-the-complete-fix)**. This involves ensuring the correct `linux-headers` are installed, rebuilding the DKMS module, and updating GRUB.

### 2. System Feels Sluggish or Slow

*   **Symptom**: The desktop environment and applications are not as responsive as they should be, even under light load.
*   **Cause**: The CPU's scaling governor is likely set to `powersave`.
*   **Solution**: Follow the guide in **[Section 5.2: CPU Performance Tuning](./05-Post-Installation.md#52-cpu-performance-tuning)** to install `cpupower` and set the governor to `performance`.

### 3. `waydroid-net.service` Fails to Start

*   **Symptom**: The command `systemctl --failed` shows that the `waydroid-net.service` has failed.
*   **Cause**: This typically indicates a broken or incomplete installation of Waydroid, where a required script is missing.
*   **Solution**: If you are not actively using Waydroid, the safest option is to disable the service to prevent errors during boot.
    ```bash
    sudo systemctl disable waydroid-net.service
    ```
    If you need Waydroid, you should try reinstalling it completely.

### 4. No Wi-Fi After Installation

*   **Symptom**: The `NetworkManager` service is running, but no Wi-Fi networks are visible.
*   **Cause**: You may have forgotten to install the necessary wireless firmware or a Wi-Fi management tool during the base installation.
*   **Solution**: 
    1.  Connect to the internet via a wired Ethernet connection or USB tethering.
    2.  Install the `iwd` package, which provides wireless support.
        ```bash
        sudo pacman -S iwd
        ```
    3.  Enable the `iwd` service:
        ```bash
        sudo systemctl enable --now iwd.service
        ```
    4.  Restart NetworkManager:
        ```bash
        sudo systemctl restart NetworkManager
        ```

---

## General Troubleshooting Tips

When you encounter an issue, the system logs are your best friend. Use `journalctl` to diagnose problems.

*   **View all logs since boot**:
    ```bash
    journalctl -b
    ```
*   **Follow logs in real-time**:
    ```bash
    journalctl -f
    ```
*   **Check logs for a specific service**:
    ```bash
    journalctl -u <service-name>
    ```
    For example: `journalctl -u NetworkManager.service`
