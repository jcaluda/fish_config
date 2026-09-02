# fish_config

A small Fish shell configuration for Debian-based Linux, including Ubuntu, Kubuntu, and WSL Ubuntu, with a custom prompt and optional Tmux configuration.

## Requirements

- Debian-based Linux distribution (Ubuntu, Kubuntu, or WSL Ubuntu)
- `sudo` access, unless running the scripts as root
- A Powerline-compatible font installed in the terminal environment

## 1. Install Fish

The install script installs Fish and uses the system package repositories:

```bash
./install.sh
```

To install Fish manually:

```bash
sudo apt update
sudo apt install fish
```

For the latest Fish release on Ubuntu, Kubuntu, or WSL Ubuntu, use Fish's official PPA:

```bash
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish
```

## 2. Install Tmux (optional)

Install Tmux if you want terminal multiplexing support. The install script asks whether it should install Tmux.

```bash
sudo apt install tmux
```

## 3. Install the font

Install `fonts/DejaVu Sans Mono for Powerline.ttf` using the host environment's font installer. In WSL, install it on the Windows side.

## 4. Configure Windows Terminal

For Windows Terminal, update the Ubuntu profile with these appearance settings:

- Font face: `DejaVu Sans Mono for Powerline`
- Font size: `11`
- Color scheme: `Ottosson`
- Background color: `#002B36`

## 5. Install the Fish configuration

Copy the contents of the `fish/` folder into your Fish config directory:

```bash
cp -r fish ~/.config/fish
```

If you already have an existing Fish configuration, back it up first:

```bash
mv ~/.config/fish ~/.config/fish.backup
```

## 6. Install the tmux config (optional)

If a `tmux` configuration is present, copy it to your home directory:

```bash
cp tmux/.tmux.conf ~/
```

## 7. Restart the terminal

Open a new terminal session so the new shell and config load correctly. In WSL, restart WSL or open a new Ubuntu session.

## Notes

- `fish/config.fish` is the main Fish configuration file.
- `fish/functions/` contains prompt functions and helper scripts.
- Restart your terminal after installing the config.
