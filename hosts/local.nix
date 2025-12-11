{ pkgs, ... }:

{
  home.username = "gero"; 
  home.homeDirectory = "/home/gero";

  home.packages = with pkgs; [
    # --- 🖼️ GUI / Wayland Core ---
    foot
    hyprlock
    hypridle
    hyprpicker
    hyprshot
    waybar
    dunst
    swww
    fuzzel
    wl-clipboard
    wlogout

    lxappearance
    nwg-look 
    
    # --- 🎨 Theming ---
    catppuccin-gtk
    rose-pine-gtk-theme
    pywalfox-native
    
    # --- 🌍 Browsers ---
    brave
    
    # --- 💻 Editor & Dev ---
    vscode
    godot_4
    typora
    neovim-remote
    
    # --- 🎵 Audio & Media ---
    pipewire wireplumber pavucontrol
    mpd ncmpcpp cava
    yt-dlp mpv imagemagick
    
    # --- 📂 Fonts ---
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    inter
  ];

  # Font config
  fonts.fontconfig.enable = true;

  # Local Bash Scripts
  programs.bash.initExtra = ''
    if [ -d "$HOME/.bashrc.d/local" ]; then
      for f in "$HOME/.bashrc.d/local"/*.sh; do source "$f"; done
    fi
  '';
  
  # NOTE: xdg.configFile is REMOVED.
  # We rely on 'home.activation.symlinkDotfiles' in common.nix to link
  # ~/nix-dots/config/* to ~/.config/*.
}
