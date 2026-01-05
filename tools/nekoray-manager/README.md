> [!WARNING]
> **Compatibility Notice**
>
> This tool is developed and tested on **Gentoo Linux (KDE Plasma)**.
>
> Users on **Hyprland**, **Sway**, or other minimal Wayland compositors might face issues with **TUN Mode** (running GUI as root).
> *   Root GUI apps on Wayland often require specific Polkit/Environment configurations (e.g., `xhost +SI:localuser:root`).
> *   **Arch/Hyprland Users:** If `sudo nekoray` fails to open the window, it is highly recommended to install via **AUR** (`nekoray-bin`), as it handles permissions natively.

# Nekoray Manager

A helper script to install, update, and manage **Nekoray** (AppImage) on Linux systems.

## 🐱 Why use this?
*   **Automatic Installation:** Fetches the latest AppImage from GitHub.
*   **System Integration:** Adds `nekoray` to your `$PATH` and creates a Desktop shortcut for KDE/GNOME.
*   **Background Run:** The installed `nekoray` command automatically detaches from the terminal (no more need for `screen` or open windows).
*   **TUN Mode Support:** Easy root access for VPN mode.

## 🚀 Installation
Using the global installer:
1. Run `./install.sh` from the root of this repo.
2. Select `nekoray-manager`.

## 📖 Usage

### Install / Update
Run the manager and select option **1**:
```bash
nekoray-manager
```

### Run Nekoray
Once installed, you can use it from anywhere:

**Standard Mode:**
```bash
nekoray
```
*(This returns control to the terminal immediately)*

**TUN Mode (Requires Root):**
```bash
sudo nekoray
```
*Or right-click the icon in the Application Menu and select "Run in TUN Mode".*

### Uninstall
Run the manager and select option **2**. It will cleanly remove all files (`/opt/nekoray`, shortcuts, icons).
