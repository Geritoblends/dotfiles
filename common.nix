{ pkgs, lib, config, ... }: 

let
  dotfilesDir = "${config.home.homeDirectory}/nix-dots";
  configDir   = "${config.home.homeDirectory}/.config";
  bashrcDir   = "${config.home.homeDirectory}/.bashrc.d";
  localBin    = "${config.home.homeDirectory}/.local/bin";
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # --- 🛠 Core Utils ---
    git curl wget unzip zip p7zip ripgrep fd fzf bat eza jq zoxide
    
    # --- 🌐 Network ---
    bind nmap netcat-openbsd httpie whois
    
    # --- 💻 Dev & Build ---
    gcc gnumake just mold git-lfs gh glab
    
    # --- 🐍 Languages ---
    nodejs_22 deno python3 rustup
    
    # --- 📊 Monitoring ---
    htop bottom ncdu
    
    # --- ⌨️ Multiplexers ---
    tmux zellij
    
    # --- 🧸 Fun ---
    fastfetch cmatrix pipes-rs
  ];

  # 3. PATH
  home.sessionPath = [ localBin ];

  # 4. THE MAGIC LINKING SCRIPT
  # This links ~/nix-dots/config/* to ~/.config/* as MUTABLE symlinks.
  # This allows your 'theme' script to modify files inside ~/.config/hypr/ etc.
  home.activation.symlinkDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # A. Link Bash Scripts
    if [ -d "${dotfilesDir}/bash" ]; then
      $DRY_RUN_CMD rm -rf "${bashrcDir}"
      $DRY_RUN_CMD ln -sfn "${dotfilesDir}/bash" "${bashrcDir}"
    fi

    # B. Link Binaries
    if [ -d "${dotfilesDir}/bin" ]; then
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.local"
      $DRY_RUN_CMD rm -rf "${localBin}"
      $DRY_RUN_CMD ln -sfn "${dotfilesDir}/bin" "${localBin}"
    fi

    # C. Link Config Folders (The Hybrid Fix)
    if [ -d "${dotfilesDir}/config" ]; then
      echo "🔗 Linking configs from ${dotfilesDir}/config..."
      
      for dir in "${dotfilesDir}/config"/*; do
        base=$(basename "$dir")
        target="${configDir}/$base"
        
        # Don't link 'wal' folder if it exists, usually we want that local only
        if [ "$base" == "wal" ]; then continue; fi

        # Backup existing directories if they are NOT symlinks
        if [ -d "$target" ] && [ ! -L "$target" ]; then
          echo "📦 Backing up existing $base to $base.bak"
          $DRY_RUN_CMD mv "$target" "$target.bak"
        fi

        # Create the link: ~/.config/name -> ~/nix-dots/config/name
        $DRY_RUN_CMD ln -sfn "$dir" "$target"
      done
    fi
  '';

  # 5. BASH INIT
  programs.bash = {
    enable = true;
    initExtra = ''
      # Source GLOBAL scripts
      if [ -d "$HOME/.bashrc.d/global" ]; then
        for f in "$HOME/.bashrc.d/global"/*.sh; do source "$f"; done
      fi
    '';
  };

  # 6. NVIM (Example of a handled config)
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
