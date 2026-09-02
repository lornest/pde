#!/usr/bin/env bash
#
# Bootstrap this Neovim config on a fresh Debian/Ubuntu machine.
#
# Installs Neovim, the tree-sitter CLI, Node.js and the handful of system
# packages this config depends on, then syncs plugins and language servers.
#
# Safe to re-run: every step is skipped if it is already satisfied.
#
#   ./scripts/setup.sh              # everything
#   ./scripts/setup.sh --help       # options
#
set -euo pipefail

# --- pinned versions (override via env) --------------------------------------
NVIM_VERSION="${NVIM_VERSION:-v0.12.5}"
TREE_SITTER_VERSION="${TREE_SITTER_VERSION:-v0.27.0}"
NODE_VERSION="${NODE_VERSION:-lts}"   # "lts" resolves the current LTS
OPT_DIR="${OPT_DIR:-/opt}"
BIN_DIR="${BIN_DIR:-/usr/local/bin}"

# --- flags -------------------------------------------------------------------
SKIP_APT=0
SKIP_NODE=0
SKIP_LAZYGIT=0
SKIP_BOOTSTRAP=0
DRY_RUN=0

usage() {
  sed -n '2,12p' "$0" | sed 's/^#\s\?//'
  cat <<'EOF'

Options:
  --skip-apt         Don't install system packages with apt
  --skip-node        Don't install Node.js (skips most LSP servers)
  --skip-lazygit     Don't install lazygit
  --skip-bootstrap   Don't sync plugins / language servers at the end
  --dry-run          Print what would happen, change nothing
  -h, --help         Show this help

Environment overrides:
  NVIM_VERSION (default v0.12.5)   TREE_SITTER_VERSION (default v0.27.0)
  NODE_VERSION (default lts)       OPT_DIR / BIN_DIR
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --skip-apt)       SKIP_APT=1 ;;
    --skip-node)      SKIP_NODE=1 ;;
    --skip-lazygit)   SKIP_LAZYGIT=1 ;;
    --skip-bootstrap) SKIP_BOOTSTRAP=1 ;;
    --dry-run)        DRY_RUN=1 ;;
    -h|--help)        usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

# --- output helpers ----------------------------------------------------------
if [ -t 1 ]; then
  C_B=$'\033[1m'; C_G=$'\033[32m'; C_Y=$'\033[33m'; C_R=$'\033[31m'; C_0=$'\033[0m'
else
  C_B=''; C_G=''; C_Y=''; C_R=''; C_0=''
fi
step() { printf '\n%s==>%s %s%s%s\n' "$C_G" "$C_0" "$C_B" "$*" "$C_0"; }
info() { printf '    %s\n' "$*"; }
skip() { printf '    %sskip%s %s\n' "$C_Y" "$C_0" "$*"; }
warn() { printf '%swarn:%s %s\n' "$C_Y" "$C_0" "$*" >&2; }
die()  { printf '%serror:%s %s\n' "$C_R" "$C_0" "$*" >&2; exit 1; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then printf '    %s[dry-run]%s %s\n' "$C_Y" "$C_0" "$*"; return 0; fi
  "$@"
}

have() { command -v "$1" >/dev/null 2>&1; }

# --- privilege ---------------------------------------------------------------
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  have sudo || die "not root and sudo is not installed"
  SUDO="sudo"
fi
as_root() {
  if [ "$DRY_RUN" -eq 1 ]; then printf '    %s[dry-run]%s %s %s\n' "$C_Y" "$C_0" "$SUDO" "$*"; return 0; fi
  ${SUDO:+$SUDO} "$@"
}

# --- platform ----------------------------------------------------------------
[ "$(uname -s)" = "Linux" ] || die "this script targets Linux; on macOS use Homebrew"
have apt-get || die "no apt-get found; this script targets Debian/Ubuntu"

case "$(uname -m)" in
  x86_64|amd64)  NVIM_ARCH=x86_64; TS_ARCH=x64;   NODE_ARCH=x64;   LG_ARCH=x86_64 ;;
  aarch64|arm64) NVIM_ARCH=arm64;  TS_ARCH=arm64; NODE_ARCH=arm64; LG_ARCH=arm64 ;;
  *) die "unsupported architecture: $(uname -m)" ;;
esac

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

printf '%sNeovim config bootstrap%s\n' "$C_B" "$C_0"
info "arch:   $(uname -m) -> nvim:$NVIM_ARCH ts:$TS_ARCH node:$NODE_ARCH"
info "config: $REPO_ROOT"
[ "$DRY_RUN" -eq 1 ] && warn "dry-run: nothing will be changed"

# --- 1. system packages ------------------------------------------------------
# build-essential : compiles treesitter parsers, telescope-fzf-native, LuaSnip's jsregexp
# libsqlite3-dev  : sqlite.lua, used by telescope-smart-history
# ripgrep         : required by telescope live_grep
# fd-find         : used by snacks picker/explorer
# xz-utils        : extracts the Node.js tarball
# bear/cmake/gdb  : C development (compile_commands.json, builds, debugging)
APT_PACKAGES=(
  build-essential ca-certificates cmake curl git tar unzip xz-utils
  ripgrep fd-find libsqlite3-dev bear gdb
)

step "System packages"
if [ "$SKIP_APT" -eq 1 ]; then
  skip "--skip-apt"
else
  missing=()
  for p in "${APT_PACKAGES[@]}"; do
    dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
  done
  if [ ${#missing[@]} -eq 0 ]; then
    skip "all ${#APT_PACKAGES[@]} packages already installed"
  else
    info "installing: ${missing[*]}"
    as_root apt-get update -qq
    # `sudo` drops DEBIAN_FRONTEND from the environment, so set it via `env`
    # on the far side rather than as a prefix on this side.
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${missing[@]}"
  fi
  # Debian/Ubuntu ship fd as `fdfind`; add an `fd` alias if nothing owns it.
  if have fdfind && ! have fd; then
    info "symlinking fdfind -> $BIN_DIR/fd"
    as_root ln -sf "$(command -v fdfind)" "$BIN_DIR/fd"
  fi
fi

# --- 2. neovim ---------------------------------------------------------------
step "Neovim $NVIM_VERSION"
current_nvim=""
have nvim && current_nvim="v$(nvim --version | awk 'NR==1' | sed 's/^NVIM v//')"
if [ "$current_nvim" = "$NVIM_VERSION" ]; then
  skip "already $NVIM_VERSION"
else
  [ -n "$current_nvim" ] && info "found $current_nvim, replacing with $NVIM_VERSION"
  tarball="nvim-linux-${NVIM_ARCH}.tar.gz"
  url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${tarball}"
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  info "downloading $url"
  run curl -fsSL --retry 3 -o "$tmp/$tarball" "$url" || die "download failed: $url"
  run tar -xzf "$tmp/$tarball" -C "$tmp"
  as_root rm -rf "$OPT_DIR/nvim-linux-${NVIM_ARCH}"
  as_root mv "$tmp/nvim-linux-${NVIM_ARCH}" "$OPT_DIR/"
  as_root ln -sf "$OPT_DIR/nvim-linux-${NVIM_ARCH}/bin/nvim" "$BIN_DIR/nvim"
  info "installed to $OPT_DIR/nvim-linux-${NVIM_ARCH}, linked at $BIN_DIR/nvim"
fi

# --- 3. tree-sitter CLI ------------------------------------------------------
# Required by nvim-treesitter's `main` branch to build parsers.
# Must NOT be the npm build.
step "tree-sitter CLI $TREE_SITTER_VERSION"
want_ts="${TREE_SITTER_VERSION#v}"
if have tree-sitter && [ "$(tree-sitter --version 2>/dev/null | awk '{print $2}')" = "$want_ts" ]; then
  skip "already $TREE_SITTER_VERSION"
else
  url="https://github.com/tree-sitter/tree-sitter/releases/download/${TREE_SITTER_VERSION}/tree-sitter-linux-${TS_ARCH}.gz"
  tmp="$(mktemp -d)"
  info "downloading $url"
  run curl -fsSL --retry 3 -o "$tmp/ts.gz" "$url" || die "download failed: $url"
  run gunzip -f "$tmp/ts.gz"
  run chmod +x "$tmp/ts"
  as_root mv "$tmp/ts" "$BIN_DIR/tree-sitter"
  rm -rf "$tmp"
  info "installed $BIN_DIR/tree-sitter"
fi

# --- 4. node.js --------------------------------------------------------------
# Most configured LSP servers are npm packages: ts_ls, jsonls, yamlls, bashls,
# svelte, tailwindcss, intelephense, pyright.
step "Node.js"
if [ "$SKIP_NODE" -eq 1 ]; then
  skip "--skip-node (ts_ls, jsonls, yamlls, bashls, svelte, tailwindcss, intelephense, pyright will not install)"
elif have node && have npm; then
  skip "already present ($(node --version))"
else
  if [ "$NODE_VERSION" = "lts" ]; then
    info "resolving current Node LTS"
    index="$(curl -fsSL --retry 3 https://nodejs.org/dist/index.json)" || die "could not reach nodejs.org"
    if have python3; then
      resolved="$(printf '%s' "$index" | python3 -c \
        'import json,sys; print(next(r["version"] for r in json.load(sys.stdin) if r.get("lts")))')"
    else
      # No python3: entries are newest-first, so the first one tagged as an LTS
      # wins. One awk pass, which consumes all input -- see the note on `head`
      # and SIGPIPE below.
      resolved="$(printf '%s' "$index" | tr '}' '\n' | awk '
        !found && /"lts":"/ {
          if (match($0, /"version":"v[0-9.]+"/)) {
            v = substr($0, RSTART, RLENGTH); gsub(/"version":"|"/, "", v)
            print v; found = 1
          }
        }')"
    fi
    [ -n "$resolved" ] || die "could not resolve Node LTS; set NODE_VERSION=vX.Y.Z"
    NODE_VERSION="$resolved"
  fi
  info "installing Node $NODE_VERSION"
  tarball="node-${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"
  url="https://nodejs.org/dist/${NODE_VERSION}/${tarball}"
  tmp="$(mktemp -d)"
  run curl -fsSL --retry 3 -o "$tmp/$tarball" "$url" || die "download failed: $url"
  run tar -xJf "$tmp/$tarball" -C "$tmp"
  as_root rm -rf "$OPT_DIR/node"
  as_root mv "$tmp/node-${NODE_VERSION}-linux-${NODE_ARCH}" "$OPT_DIR/node"
  as_root ln -sf "$OPT_DIR/node/bin/node" "$BIN_DIR/node"
  as_root ln -sf "$OPT_DIR/node/bin/npm"  "$BIN_DIR/npm"
  as_root ln -sf "$OPT_DIR/node/bin/npx"  "$BIN_DIR/npx"
  rm -rf "$tmp"
  info "installed to $OPT_DIR/node"
fi

# --- 5. lazygit --------------------------------------------------------------
# Bound to <leader>gg and friends via snacks.nvim.
step "lazygit"
if [ "$SKIP_LAZYGIT" -eq 1 ]; then
  skip "--skip-lazygit"
elif have lazygit; then
  skip "already present ($(lazygit --version 2>/dev/null | awk 'NR==1' | cut -c1-40))"
else
  info "resolving latest release"
  lg_tag="$(curl -fsSL --retry 3 https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | awk 'match($0, /"tag_name": *"[^"]*"/) && !f { v = substr($0, RSTART, RLENGTH); sub(/.*: *"/, "", v); sub(/"$/, "", v); print v; f = 1 }')" || true
  if [ -z "$lg_tag" ]; then
    warn "could not resolve lazygit release; skipping (install manually if you want <leader>gg)"
  else
    lg_ver="${lg_tag#v}"
    url="https://github.com/jesseduffield/lazygit/releases/download/${lg_tag}/lazygit_${lg_ver}_linux_${LG_ARCH}.tar.gz"
    tmp="$(mktemp -d)"
    info "downloading lazygit $lg_tag"
    if run curl -fsSL --retry 3 -o "$tmp/lg.tar.gz" "$url"; then
      run tar -xzf "$tmp/lg.tar.gz" -C "$tmp" lazygit
      as_root install -m 755 "$tmp/lazygit" "$BIN_DIR/lazygit"
      info "installed $BIN_DIR/lazygit"
    else
      warn "lazygit download failed; skipping"
    fi
    rm -rf "$tmp"
  fi
fi

# --- 6. link the config ------------------------------------------------------
step "Neovim config"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [ "$(readlink -f "$NVIM_CONFIG" 2>/dev/null || true)" = "$(readlink -f "$REPO_ROOT")" ]; then
  skip "$NVIM_CONFIG already points at this repo"
elif [ -e "$NVIM_CONFIG" ]; then
  warn "$NVIM_CONFIG already exists and is not this repo -- leaving it alone"
  info "to use this config: mv $NVIM_CONFIG $NVIM_CONFIG.bak && ln -s $REPO_ROOT $NVIM_CONFIG"
else
  run mkdir -p "$(dirname "$NVIM_CONFIG")"
  run ln -s "$REPO_ROOT" "$NVIM_CONFIG"
  info "linked $NVIM_CONFIG -> $REPO_ROOT"
fi

# --- 7. plugins, parsers, language servers -----------------------------------
step "Plugins, parsers and language servers"
if [ "$SKIP_BOOTSTRAP" -eq 1 ]; then
  skip "--skip-bootstrap"
elif [ "$DRY_RUN" -eq 1 ]; then
  skip "dry-run"
else
  info "syncing plugins (this clones ~50 repos, give it a minute)"
  nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5 || warn "Lazy sync reported problems"

  info "installing parsers and language servers (up to 10 minutes)"
  nvim --headless -c 'lua
    local ts = require("nvim-treesitter")
    local mason_done, last, stable = false, -1, 0
    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsUpdateCompleted",
      callback = function() mason_done = true end,
    })
    local start = vim.uv.now()
    local timer = vim.uv.new_timer()
    timer:start(3000, 3000, vim.schedule_wrap(function()
      local n = #ts.get_installed()
      if n == last then stable = stable + 1 else stable, last = 0, n end
      local elapsed = (vim.uv.now() - start) / 1000
      -- done when parsers stopped arriving and mason has reported in
      if (stable >= 4 and mason_done) or elapsed > 600 then
        timer:stop()
        print(("parsers installed: %d  mason completed: %s"):format(n, tostring(mason_done)))
        vim.cmd("qa!")
      end
    end))' 2>&1 | tail -5 || warn "bootstrap reported problems"
fi

# --- done --------------------------------------------------------------------
step "Done"
if [ "$DRY_RUN" -eq 0 ]; then
  have nvim        && info "nvim         $(nvim --version | awk 'NR==1')"
  have tree-sitter && info "tree-sitter  $(tree-sitter --version)"
  have node        && info "node         $(node --version)"
  have rg          && info "ripgrep      $(rg --version | awk 'NR==1')"
  have lazygit     && info "lazygit      $(lazygit --version 2>/dev/null | awk 'NR==1' | cut -c1-40)"
fi

cat <<EOF

Next steps:
  nvim +checkhealth          verify everything resolved
  nvim +Mason                inspect language server installs

Notes:
  * Clipboard works over SSH via OSC 52 with no extra packages, provided your
    terminal supports it. Do not install xclip/xsel on a headless box -- Neovim
    only uses them when \$DISPLAY is set.
  * Icons need a Nerd Font installed on the machine you SSH *from*, not here.
  * Go, Python and Rust toolchains were not installed. Add them if you want
    gopls/delve/templ (Go), black/autoflake (Python) or sleek (Rust).
EOF
