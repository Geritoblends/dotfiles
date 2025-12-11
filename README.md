# Geritoblends' nix dotfiles

#### Installation

```bash
# Make sure there's no ~/.bashrc.d
mv ~/.bashrc.d ~/.bashrc.d.bak

# Install Nix if not present
if ! command -v nix &> /dev/null; then
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Install Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix run home-manager/master -- switch --flake .#local
```

#### Brief explanation

This repo revolves around the split between `colorschemes` and `layouts`. The main script that lets you choose between the available layouts and colorschemes is `bin/theme` (being `bin/theme-select` a fuzzel wrapper)

To define a new colorscheme, you simply add a new .json file in `config/wal/colorschemes`, for example:

```json
// config/wal/colorschemes/gruvbox.json
{
  "special": {
    "background": "#1e1c1b",
    "foreground": "#ebdbb2",
    "cursor": "#ebdbb2"
  },
  "colors": {
    "color0": "#1e1c1b",
    "color1": "#cc241d",
    "color2": "#98971a",
    "color3": "#d79921",
    "color4": "#458588",
    "color5": "#b16286",
    "color6": "#689d6a",
    "color7": "#a89984",
    "color8": "#928374",
    "color9": "#fb4934",
    "color10": "#b8bb26",
    "color11": "#fabd2f",
    "color12": "#83a598",
    "color13": "#d3869b",
    "color14": "#8ec07c",
    "color15": "#ebdbb2"
  }
}
```

To create a new layout, you need to create a new folder at `layouts/`. The structure is as follows:

```bash
my-layout-name/
├── dunstrc
├── foot.ini
├── fuzzel.ini
├── hypr-layout.conf
└── waybar
    ├── config.jsonc
    └── style.css

```

Note: the files must only contain the shape of the layout, never the colors. For reference, check any of the currently available layouts.

