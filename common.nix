{ pkgs, lib, config, ... }: 

let
  dotfilesDir = "${config.home.homeDirectory}/nix-dots";
  configDir   = "${config.home.homeDirectory}/.config";
  bashrcDir   = "${config.home.homeDirectory}/.bashrc.d";
  localBin    = "${config.home.homeDirectory}/.local/bin";
in
{
  home.packages = with pkgs; [
    # --- 🛠 Core Utils ---
    git
    curl
    wget
    unzip
    zip
    p7zip      # 7zip
    ripgrep    # grep replacement
    fd         # find replacement
    fzf        # fuzzy finder
    bat        # cat replacement
    eza        # ls replacement (modern)
    jq         # json processor
    yazi       # file manager (you had this)
    zoxide     # cd replacement

    # --- 🌐 Network ---
    bind       # for 'dig'
    nmap
    netcat-openbsd
    httpie     # better curl
    whois
    
    # --- 💻 Dev & Build ---
    gcc
    gnumake
    just       # command runner
    mold       # fast linker
    git-lfs
    gh         # github cli
    glab       # gitlab cli
    
    # --- 🐍 Languages & Runtimes ---
    nodejs_22  # Latest stable node
    deno
    python3
    rustup
    
    # --- 📊 Monitoring ---
    htop
    bottom     # btm
    ncdu       # disk usage
    
    # --- ⌨️ Multiplexers ---
    tmux
    zellij
    
    # --- 🧸 Fun ---
    fastfetch
    cmatrix
    pipes-rs   # Rust version of pipes.sh
  ];

  home.sessionPath = [ localBin ];

  home.activation.symlinkDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # 1. Link Bash & Bin (Previous step)
    if [ -d "${dotfilesDir}/bash" ]; then
      $DRY_RUN_CMD rm -rf "${bashrcDir}"
      $DRY_RUN_CMD ln -sfn "${dotfilesDir}/bash" "${bashrcDir}"
    fi

    if [ -d "${dotfilesDir}/bin" ]; then
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.local"
      $DRY_RUN_CMD rm -rf "${localBin}"
      $DRY_RUN_CMD ln -sfn "${dotfilesDir}/bin" "${localBin}"
    fi

    # 2. Link ALL Config folders (The New Magic)
    # Loops through ~/nix-dots/config/* and links them to ~/.config/*
    if [ -d "${dotfilesDir}/config" ]; then
      echo "🔗 Linking configs from ${dotfilesDir}/config..."
      
      for dir in "${dotfilesDir}/config"/*; do
        # Get the folder name (e.g., "nvim", "hypr")
        base=$(basename "$dir")
        target="${configDir}/$base"
        
        # If target exists and is a directory (but not a symlink), back it up
        if [ -d "$target" ] && [ ! -L "$target" ]; then
          echo "📦 Backing up existing $base to $base.bak"
          $DRY_RUN_CMD mv "$target" "$target.bak"
        fi

        # Create the symlink (force overwrite if it's already a link)
        $DRY_RUN_CMD ln -sfn "$dir" "$target"
      done
    fi
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      # Source GLOBAL scripts from the symlink
      if [ -d "$HOME/.bashrc.d/global" ]; then
        for f in "$HOME/.bashrc.d/global"/*.sh; do source "$f"; done
      fi
    '';
  };

  xdg.configFile."nvim".source = ./config/nvim;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
