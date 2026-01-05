# 🐧 Linux Helpers

**Linux Helpers** is a collection of interactive, distro-agnostic Bash scripts designed to streamline daily command-line workflows. 

These tools utilize `fzf` to provide user-friendly Terminal User Interfaces (TUI) for complex tools like `ffmpeg` and `yt-dlp`.

## 🚀 Quick Start

You can install tools individually or use the included manager.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/foxdevtime/linux-helpers.git
   cd linux-helpers
   ```

2. **Run the Installer:**
   The `install.sh` script scans the `tools/` directory and lets you choose what to install to `/usr/local/bin`.
   ```bash
   ./install.sh
   ```

## 🛠️ Available Tools

| Tool | Description | Documentation |
|------|-------------|---------------|
| **[ezmedia](tools/ezmedia)** | Interactive wrapper for **FFmpeg**. Convert video, extract audio, and create GIFs using a simple menu. | [Read Docs](tools/ezmedia/README.md) |
| **[yt-fetch](tools/yt-fetch)** | Smart downloader for **YouTube** (via `yt-dlp`). Allows quality selection and metadata preview. | [Read Docs](tools/yt-fetch/README.md) |

## 📦 Requirements

Most scripts in this collection rely on the following standard tools:
*   `bash` (4.0+)
*   `fzf` (Required for menus)
*   **Tool specific:**
    *   `ezmedia` needs `ffmpeg`
    *   `yt-fetch` needs `yt-dlp` and `ffmpeg`

## 🤝 Contributing

Feel free to submit Pull Requests to add new helpers!
1. Create a new folder in `tools/`.
2. Add your script and a dedicated `README.md`.
3. The `install.sh` will automatically detect your new tool.

## 📄 License

Distributed under the MIT License.
