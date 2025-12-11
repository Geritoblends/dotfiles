toggle_pad() {
    if lsmod | grep -q '^bcm5974'; then
        sudo modprobe -r bcm5974
        echo "Trackpad disabled"
    else
        sudo modprobe bcm5974
        echo "Trackpad enabled"
    fi
}

mkcd() {
    mkdir $1 && cd $1 
}

trimwav() {
    if [ $# -lt 3 ]; then
        echo "Usage: trimwav <input.wav> <start_seconds> <duration_seconds> [output.wav]"
        return 1
    fi

    local infile="$1"
    local start="$2"
    local dur="$3"
    local outfile="${4:-trimmed_${infile}}"

    sox "$infile" "$outfile" trim "$start" "$dur"
    echo "Created: $outfile"
}

trim_mp4() {
    if [ $# -lt 3 ]; then
        echo "Usage: trim_mp4 <input.mp4> <start_seconds> <duration_seconds> [output.mp4]"
        return 1
    fi

    local infile="$1"
    local start="$2"
    local dur="$3"
    local outfile="${4:-trimmed_${infile}}"

    # Nota: -ss va después de -i para que ffmpeg reescriba timestamps correctamente
    ffmpeg -i "$infile" -ss "$start" -t "$dur" -c copy -avoid_negative_ts make_zero "$outfile"

    echo "Created: $outfile"
}

cdf() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf) && cd "$dir"
}

rmf() {
  local file
  file=$(find . -maxdepth 1 -type f 2>/dev/null | fzf) && rm -i "$file"
}

rmfm() {
  local file
  file=$(find . -maxdepth 1 -type f 2>/dev/null | fzf -m) && rm -i "$file"
}

nvimf() {
  local file
  file=$(fd --hidden --exclude .git --type f | fzf) && command nvim --listen /tmp/nvim.$$.0 "$file"
}

nvimrg() {
    nvim $(rg -l "$1")
}

zip_current() {
    # Get the name of the current folder
    local folder_name
    folder_name=$(basename "$PWD")

    # Set the output zip path
    local output="../${folder_name}.zip"

    # Zip the current folder into the output path
    zip -r "$output" .

    echo "Zipped '$folder_name' to '$output'"
}

cutfile() { mv "$1" ~/.clipboard/; }
pastefile() { mv ~/.clipboard/"$1" .; }

cloud() {
    # Save current title
    local old_title=$(printf "\033]0;$(hostnamectl hostname)\007")

    # Set title to "cloud"
    echo -ne "\033]0;cloud\007"

    # SSH into your cloud machine
    ssh gero@minecrafsito.hopto.org -p 22

    # Restore original title
    echo -ne "$old_title"
}

localcloud() {
    # Save current title
    local old_title=$(printf "\033]0;$(hostnamectl hostname)\007")

    # Set title to "cloud"
    echo -ne "\033]0;cloud\007"

    # SSH into your cloud machine
    ssh gero@192.168.1.67 -p 22

    # Restore original title
    echo -ne "$old_title"
}

nvimfm() {
    nvim $(fd --hidden --exclude .git --type f | fzf -m)
}

tmp() {
  mkdir -p ~/.tmp

  # Verifica si se proporcionó un nombre de archivo
  if [ -z "$1" ]; then
    echo "Uso: tmp <nombre_archivo>"
    return 1
  fi

  local file_path=~/.tmp/$1

  echo "Abriendo: ${file_path}"
  
  # Abre el archivo con nvim
  nvim "$file_path"
}

tmpf() {
  mkdir -p ~/.tmp
  local file
  file=$(find ~/.tmp -type f | fzf --preview 'cat {}')
  
  if [ -n "$file" ]; then
      nvim "$file"
  fi
}

DOTS="$HOME/nix-dots"

lbin() {
    local bin_dir="$DOTS/bin"

    mkdir -p "$bin_dir"

    if [ -z "$1" ]; then
        echo "Usage: lbin <script_name>"
        return 1
    fi

    local file_path="$bin_dir/$1"

    if [ ! -f "$file_path" ]; then
        echo "✨ Creating new script: ${file_path}"
        echo '' >> "$file_path"
        chmod +x "$file_path"
    else
        echo "📂 Opening script: ${file_path}"
    fi

    nvim "$file_path"
}

lbinf() {
    local bin_dir="$DOTS/bin"
    mkdir -p "$bin_dir"
    
    # 1. Capture selection to variable
    local file
    file=$(find "$bin_dir" -type f | fzf --preview 'cat {}')
    
    # 2. Run nvim from the shell (triggers your alias)
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}

mvd() {
    local src="$HOME/Downloads"
    
    local selected=$(ls -A "$src" | fzf -m --header "Select files to move from Downloads" --preview "ls -lh $src/{}")

    if [ -z "$selected" ]; then
        return 0
    fi

    local SAVEIFS=$IFS
    IFS=$'\n'
    for file in $selected; do
        mv -v -i "$src/$file" .
    done

    IFS=$SAVEIFS
}

mvt() {
    local src="$HOME/.tmp"
    
    local selected=$(ls -A "$src" | fzf -m --header "Select files to move from Downloads" --preview "ls -lh $src/{}")

    if [ -z "$selected" ]; then
        return 0
    fi

    local SAVEIFS=$IFS
    IFS=$'\n'
    for file in $selected; do
        mv -v -i "$src/$file" .
    done

    IFS=$SAVEIFS
}

ec2() {
    if [ -z "$1" ]; then
        echo "Usage: ec2 <ec2-ip-or-dns> [user]"
        return 1
    fi

    local TARGET="$1"
    local USER="${2:-admin}"

    ssh -i ~/keys/nginx.pem "$USER@$TARGET"
}

ta() {
    tmux attach -t "$(tmux ls | fzf | cut -d: -f1)"
}

setup_ec2_nix() {
    if [ -z "$1" ]; then
        echo "Usage: setup_ec2_nix <ec2-ip-or-dns> [user]"
        return 1
    fi

    local TARGET="$1"
    local USER="${2:-admin}"
    local REPO_URL="https://github.com/Geritoblends/nix-dots.git"

    echo "🚀 Bootstrapping Nix on $USER@$TARGET..."

    # 1. Install Nix (Determinate Systems installer is fast and reliable)
    # 2. Install Home Manager
    # 3. Clone your repo
    # 4. Apply config
    ssh -t "$USER@$TARGET" "
        # Install Nix if not present
        if ! command -v nix &> /dev/null; then
            curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --no-confirm
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi

        # Install Home Manager
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        
        # Clone Repo (if not exists) or Pull
        if [ ! -d ~/nix-dots ]; then
            git clone $REPO_URL ~/nix-dots
        else
            cd ~/nix-dots && git pull
        fi

        # Apply Configuration
        # We use --impure if you use absolute paths, but usually standard run is:
        cd ~/nix-dots
        nix run home-manager/master -- switch --flake .#remote
    "
}

lscript() {
    local scripts_dir="$DOTS/scripts"

    mkdir -p "$scripts_dir"

    if [ -z "$1" ]; then
        echo "Usage: lscript <script_name>"
        return 1
    fi

    local file_path="$scripts_dir/$1"

    if [ ! -f "$file_path" ]; then
        echo "✨ Creating new script: ${file_path}"
        echo '' >> "$file_path"
        chmod +x "$file_path"
    else
        echo "📂 Opening script: ${file_path}"
    fi

    nvim "$file_path"
}

lscriptf() {
    local scripts_dir="$DOTS/scripts"
    mkdir -p "$scripts_dir"
    
    # 1. Capture selection to variable
    local file
    file=$(find "$scripts_dir" -type f | fzf --preview 'cat {}')
    
    # 2. Run nvim from the shell (triggers your alias)
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}

setup_local_nix() {
    echo "🚀 Activating local Home Manager configuration..."
    
    # 1. Ensure we are in the correct directory
    if [ ! -d ~/nix-dots ]; then
        echo "Error: ~/nix-dots directory not found."
        return 1
    fi
    cd ~/nix-dots
    
    # 2. Pull latest changes
    echo "Pulling latest changes..."
    git pull
    
    # 3. Apply Local Configuration (The Switch)
    echo "Running Home Manager switch..."
    nix run home-manager/master -- switch --flake .#local

    # 4. Post-Install Bridge Fixes (Crucial for updates!)
    if command -v pywalfox &> /dev/null; then
        echo "🦊 Re-establishing Pywalfox Native Messenger bridge..."
        pywalfox install
    else
        echo "Pywalfox executable not found. Skip bridge setup."
    fi
    
    echo "✅ Local setup complete."
}

lcd() {
    local layouts_dir="$HOME/nix-dots/layouts"

    # Check if the layouts directory exists
    if [ ! -d "$layouts_dir" ]; then
        echo "Error: Directory $layouts_dir not found."
        return 1
    fi

    # Find directories -> piping to fzf -> capturing selection
    local target
    target=$(find "$layouts_dir" -mindepth 1 -maxdepth 1 -type d | \
             fzf --height=20% --layout=reverse --border --prompt="Go to Layout > ")

    # If a directory was selected, cd into it
    if [ -n "$target" ]; then
        cd "$target" || return 1
    fi
}

iphone-copy() {
    echo "__TERMIUS_COPY_BEGIN__"
    cat "$@" 2>/dev/null || echo "$@"
    echo "__TERMIUS_COPY_END__"
}

max-fans() {
  echo 1 | sudo tee /sys/devices/platform/applesmc.768/fan1_manual
  echo 6500 | sudo tee /sys/devices/platform/applesmc.768/fan1_output
}

normal-fans() {
  echo 0 | sudo tee /sys/devices/platform/applesmc.768/fan1_manual
}


disable-turbo() {
  sudo systemctl stop auto-cpufreq
  echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
}


enable-turbo() {
  echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
  sudo systemctl start auto-cpufreq
}
