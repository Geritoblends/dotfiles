toggle_pad() {
    if lsmod | grep -q '^bcm5974'; then
        sudo modprobe -r bcm5974
        echo "Trackpad disabled"
    else
        sudo modprobe bcm5974
        echo "Trackpad enabled"
    fi
}

reload_wifi() {
    sudo rmmod wl;
    sudo modprobe wl;
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
  file=$(fd --hidden --exclude .git --type f | fzf) && nvim "$file"
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
  find ~/.tmp -type f | fzf --preview 'cat {}' | xargs -r nvim
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
    find "$bin_dir" -type f | fzf --preview 'cat {}' | xargs -r nvim

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

setup_ec2() {
    if [ -z "$1" ]; then
        echo "Usage: setup_ec2 <ec2-ip-or-dns> [user]"
        return 1
    fi

    local TARGET="$1"
    local USER="${2:-admin}"

    echo "Syncing configs to $USER@$TARGET ..."

    # Ensure dirs exist remotely
    ssh "$USER@$TARGET" "mkdir -p ~/.config ~/.bashrc.d ~/cloud"

    # Copy dotfiles + cloud scripts
    scp -r ~/.bashrc.d            "$USER@$TARGET:~/"
    scp -r ~/.config/nvim         "$USER@$TARGET:~/.config/"
    scp       ~/cloud/setup.sh    "$USER@$TARGET:~/cloud/"
    scp       ~/cloud/prompt.sh   "$USER@$TARGET:~/cloud/"

    echo "Replacing remote prompt.sh…"

    # Overwrite remote ~/.bashrc.d/prompt.sh with your ~/cloud/prompt.sh
    ssh "$USER@$TARGET" "cp ~/cloud/prompt.sh ~/.bashrc.d/prompt.sh"

    echo "Executing setup.sh on remote..."
    ssh "$USER@$TARGET" "bash ~/cloud/setup.sh"

    echo "Done."
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
        nix run home-manager/master -- switch --flake .#$USER
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
    find "$scripts_dir" -type f | fzf --preview 'cat {}' | xargs -r nvim

}
