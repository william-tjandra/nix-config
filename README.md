# Portable Nix Configuration

This repository houses my portable, reproducible dotfiles, and CLI toolkit. It uses **Nix Flakes** to provide a mostly consistent environment across different Linux distributions and macOS.

## Repository Anatomy

- `flake.nix`: Orchestrates the inputs and defines the machine-specific targets.
- `flake.lock`: Pins the exact versions of all packages.
- `pkgs/default.nix`: The universal list of CLI tools installed on *every* machine (Git, Neovim, Tmux, etc.).
- `modules/common.nix`: Shared custom bash scripts (like `sys-update`) and logic.
- `modules/opensuse.nix`: Distro-specific tweaks and tools (e.g., Wayland clipboard utilities).
- `dotfiles/`: Native configuration files (e.g., `.bashrc`, `.gitconfig`) to be symlinked.

---

## Bootstrapping a Fresh OS

Follow these steps to replicate this environment on a brand new machine.

### 1. Install Nix
We use the [Determinate Systems](https://github.com/DeterminateSystems/nix-installer) installer. It is faster than the official installer and enables Nix Flakes by default.

Open your terminal and run:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L [https://install.determinate.systems/nix](https://install.determinate.systems/nix) | sh -s -- install
```
*(Note: Close and reopen your terminal after this completes, or open a new tab, so the `nix` command is available in your PATH).*

### 2. Clone this Repository
If Git is not installed, you can use Nix to temporarily load it and clone the repository directly into your `.config` folder:
```bash
# Temporarily drop into a shell with Git
nix shell nixpkgs#git

# Clone the repo
git clone git@github.com:william-tjandra/nix-config.git ~/.config/nix-config

# Enter the directory
cd ~/.config/nix-config
```

### 3. Apply the Configuration
Apply the Nix profile that matches your current operating system. This will download your tools, compile your custom scripts, and link them to your environment.

**For a generic Linux machine:**
```bash
nix profile add .#default
```

**For openSUSE Leap:**
```bash
nix profile add .#opensuse
```

---

## Custom Commands

This flake compiles custom shell scripts and adds them to your PATH automatically.

- `sys-update`: Pulls the latest commits from this repository, updates the `flake.lock` file, and upgrades all installed Nix packages to their latest versions.

---

## Updating the Configuration

1. Edit the relevant file (e.g., add a package to `pkgs/default.nix`).
2. Stage the file in Git: `git add .` *(Nix cannot see untracked files).*
3. Apply the changes: `nix profile upgrade '.*'` (or just run `sys-update`).
4. Commit and push your changes.
