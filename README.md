# fish_config

A small Fish shell configuration for WSL with a custom prompt and Windows Terminal settings.

## Requirements

- Windows Subsystem for Linux (WSL)
- Ubuntu profile in Windows Terminal
- `fish` shell installed in WSL
- Powerline-compatible font installed in Windows

## 1. Install Fish in WSL

Run the following commands in your WSL terminal:

```bash
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update && sudo apt upgrade
sudo apt install fish
```

## 2. Install Tmux (optional)

Install Tmux if you want terminal multiplexing support:

```bash
sudo apt install tmux
```

## 3. Install the font

Install the font from the `fonts/` folder on the Windows side. Use the Windows font installer to add it to your system.

## 4. Configure Windows Terminal

Update the Ubuntu profile in Windows Terminal with these appearance settings:

- Font face: `DejaVu Sans Mono for Powerline`
- Font size: `11`
- Color scheme: `Ottosson`
- Background color: `#002B36`

## 5. Install the Fish configuration

Copy the contents of the `fish/` folder into your WSL Fish config directory:

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

## 7. Restart WSL

Restart WSL or open a new Ubuntu terminal session so the new shell and config load correctly.

## Notes

- `fish/config.fish` is the main Fish configuration file.
- `fish/functions/` contains prompt functions and helper scripts.
- Restart Windows Terminal or open a new WSL session after installing the config.
