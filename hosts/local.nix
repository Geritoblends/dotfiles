{ pkgs, ... }:

{
  home.username = "gero"; # CHANGE THIS
  home.homeDirectory = "/home/gero"; # CHANGE THIS

  # Allow unfree packages (VSCode, Spotify, etc)
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # --- 🖼️ GUI / Wayland Core ---
    # Note: On non-NixOS, Hyprland is sometimes better installed via the Distro 
    # to avoid OpenGL version mismatches, but you can try the Nix package:
    
    # --- 🐚 Terminals ---
    foot
    
    # --- 🎨 Theming ---
    lxappearance
    nwg-look   # GTK3/4 settings editor for Wayland
    # (Themes usually managed via home-manager modules, but packages work too)
    catppuccin-gtk
    rose-pine-gtk-theme
    
    # --- 🌍 Browsers ---
    brave
    firefox
    
    # --- 💻 Editor & Dev ---
    vscode     # 'code'
    godot_4    # godot 4.x
    typora     # markdown
    
    # --- 🎵 Audio & Media ---
    pipewire
    wireplumber
    pavucontrol # GUI volume control
    mpd
    ncmpcpp
    cava       # Visualizer
    yt-dlp
    mpv
    imagemagick
    
    # --- 📂 Fonts ---
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    inter
  ];

  # Font config is required for Nix fonts to work on non-NixOS
  fonts.fontconfig.enable = true;

  # Your 'tmp_aliases' logic from before
programs.bash.initExtra = ''
    if [ -d "$HOME/.bashrc.d/local" ]; then
      for f in "$HOME/.bashrc.d/local"/*.sh; do source "$f"; done
    fi
  '';
  
  # Link your config folders
  xdg.configFile = {
    "hypr".source = ../config/hypr;
    "waybar".source = ../config/waybar;
    "wlogout".source = ../config/wlogout;
    "fuzzel".source = ../config/fuzzel;
    "dunst".source = ../config/dunst;
    "foot".source = ../config/foot;
    "gtk-3.0".source = ../config/gtk-3.0;
    "gtk-4.0".source = ../config/gtk-4.0;
    "mpd".source = ../config/mpd;
    "ncmpcpp".source = ../config/ncmpcpp;
  };
}
