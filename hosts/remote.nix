{ pkgs, ... }:

{
  home.username = "admin"; # Change if your EC2 user is different (e.g. 'ubuntu')
  home.homeDirectory = "/home/admin";

  home.packages = with pkgs; [
    # The 'tty-copy' request. 
    # Usually this is a script using OSC52. We can install a tool like 'osc52' 
    # or rely on tmux's internal clipboard handling. 
    # Here is a standalone OSC52 provider:
    abduco # session management usually pairs well here
  ];
  
  # Injecting a custom tty-copy script if it's not a standard package
  home.file.".local/bin/tty-copy" = {
    executable = true;
    text = ''
      #!/bin/sh
      # Simple wrapper to copy to local clipboard from remote using OSC 52
      printf "\033]52;c;$(base64 | tr -d '\n')\a"
    '';
  };

  # Make sure .local/bin is in path
  home.sessionPath = [ "$HOME/.local/bin" ];

{ pkgs, lib, ... }:

{

  programs.bash.initExtra = ''
    if [ -d "$HOME/.bashrc.d/remote" ]; then
      for f in "$HOME/.bashrc.d/remote"/*.sh; do source "$f"; done
    fi
  '';

  # Keep your hostname activation script separate here
  home.activation.setHostname = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CURRENT_HOST=$(cat /etc/hostname || hostname)
    if [ "$CURRENT_HOST" != "aws" ]; then
      $DRY_RUN_CMD sudo hostnamectl hostname aws
    fi
  '';
}
}
