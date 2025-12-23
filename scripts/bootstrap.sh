#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/mrodriguezdev/dotfiles.git"

WORKDIR="$(mktemp -d)"
SRC_DIR="$WORKDIR/dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "==> Instalando dependencias..."
sudo pacman -Sy --needed --noconfirm \
  git zsh curl rsync ttf-hack-nerd

backup () {
  local path="$1"
  if [[ -e "$path" && ! -L "$path" ]]; then
    local ts
    ts="$(date +%Y%m%d_%H%M%S)"
    echo "==> Backup: $path -> ${path}.bak.${ts}"
    mv "$path" "${path}.bak.${ts}"
  fi
}

echo "==> Backupeando configs previas..."
backup "$HOME/.zshrc"
backup "$HOME/.p10k.zsh"
backup "$HOME/.zsh"
backup "$HOME/.oh-my-zsh"

echo "==> Instalando Oh My Zsh ..."
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "==> Clonando dotfiles..."
git clone "$REPO_URL" "$SRC_DIR"

if [[ ! -d "$SRC_DIR/home" ]]; then
  echo "ERROR: No existe la carpeta 'home/' dentro del repo."
  echo "Crea dotfiles/home/ y mete ahí .zshrc, .zsh/, .p10k.zsh, etc."
  exit 1
fi

echo "==> Copiando configs a \$HOME..."
rsync -avh "$SRC_DIR/home/" "$HOME/"

echo "==> Instalando tema y plugins de Oh My Zsh..."

# Powerlevel10k
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Plugins
declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [zsh-completions]="https://github.com/zsh-users/zsh-completions"
)

for name in "${!plugins[@]}"; do
  if [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]]; then
    git clone --depth=1 "${plugins[$name]}" \
      "$ZSH_CUSTOM/plugins/$name"
  fi
done

echo "==> Configurando zsh como shell por defecto..."
if [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)" || true
fi

echo "==> Limpieza..."
rm -rf "$WORKDIR"

echo "==> Listo. Abre una nueva terminal o cierra sesión."
echo "==> Tip: en tu terminal selecciona la fuente: 'Hack Nerd Font Mono'."
