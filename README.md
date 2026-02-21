# NixOS Dotfiles

A modular NixOS configuration managed as a Nix Flake, covering multiple machines with shared
settings and per-machine overrides. User-level configuration is handled entirely via Home Manager.

---

## Directory Structure

```
.
├── flake.nix                   # Flake entrypoint — inputs, outputs, machine list
├── flake.lock                  # Pinned dependency versions
├── background.jpeg             # Wallpaper (used by Stylix + Hyprlock)
├── machines/
│   ├── common.nix              # Shared baseline applied to every machine
│   ├── nixstation.nix          # Desktop workstation (primary machine)
│   ├── nixtop.nix              # Laptop
│   ├── nixbook.nix             # MacBook (Broadcom wifi + Apple keyboard)
│   ├── nixserver.nix           # Home server
│   ├── nixvm.nix               # Minimal QEMU/KVM virtual machine
│   ├── nixmac.nix              # Mac Mini (Intel iGPU)
│   └── hardware/               # nixos-generate-config hardware scan per machine
├── home-manager/
│   ├── home.nix                # Home Manager entrypoint — imports all configs
│   └── configs/
│       ├── nvim.nix            # Neovim (LSP, Treesitter, completion)
│       ├── bash.nix            # Bash shell, prompt, aliases, SSH helpers
│       ├── tmux.nix            # Tmux
│       ├── ghostty.nix         # Ghostty terminal
│       ├── alacritty.nix       # Alacritty terminal
│       ├── hypr.nix            # Hyprland WM
│       ├── waybar.nix          # Waybar status bar
│       ├── hyprlock.nix        # Lock screen
│       └── redshift.nix        # Gammastep (blue light filter)
├── pkgs/
│   ├── packages.nix            # Per-host package lists
│   ├── stylix.nix              # Stylix theming engine
│   ├── steam.nix               # Steam + remote play
│   └── ollama.nix              # Ollama LLM server (AMD ROCm)
└── utils/
    └── gpu-usage-waybar        # Compiled binary: AMD GPU usage widget for Waybar
```

---

## Machines

| Machine | Description | Notable |
|---|---|---|
| **nixstation** | AMD desktop workstation | ROCm/Ollama, Steam, Sunshine streaming, animated matrix wallpaper, Minegrub bootloader |
| **nixtop** | Laptop | Sleep/hibernate disabled, brightness control |
| **nixbook** | MacBook | Broadcom `wl` driver, Apple keyboard (`fnmode=2`), Moonlight client |
| **nixserver** | Home server | Headless-capable, libvirtd + Docker + Podman, GNOME available |
| **nixvm** | QEMU/KVM VM | Minimal — just neovim + wget |
| **nixmac** | Mac Mini (Intel) | iGPU crash workarounds, `/mnt/storage` ext4 mount |

---

## Configuration Flow

```
flake.nix
  └─ machines/common.nix          # Kernel, networking, PipeWire, locale, user
       └─ machines/<machine>.nix  # Hardware, extra services, machine packages
            └─ pkgs/packages.nix  # Package lists (per-host)
            └─ home-manager/home.nix
                 └─ configs/*.nix # Shell, editor, WM, terminal, theming
```

1. **Common baseline** (`machines/common.nix`) — latest kernel, NetworkManager, Bluetooth,
   PipeWire, Nix flakes, `allowUnfree`, auto-upgrades, timezone (America/Chicago), user `dan`.
2. **Machine config** (`machines/<name>.nix`) — hardware-specific settings, bootloader, extra
   services (Tailscale, Mullvad, libvirtd, Docker, etc.).
3. **Packages** (`pkgs/packages.nix`) — curated per-host package lists split across CLI tools,
   GUI apps, games, and development tooling.
4. **Home Manager** (`home-manager/`) — user-space: shell, editor, WM, terminals, theming.

---

## Home Manager Configs

### Shell — `configs/bash.nix`
- Git-aware two-color prompt: `user@host:dir (branch*)`
- Auto-loads SSH keys on shell start
- Bluetooth helpers: `airpods()`, `proController()`
- Tailscale exit-node aliases: `enon` / `enonlan` / `enoff`
- `ai` → `opencode`

### Editor — `configs/nvim.nix`
- LSP via `nvim-lspconfig`: TypeScript (`ts_ls`), Rust (`rust_analyzer` + clippy on save)
- `mason.nvim` for LSP installer management
- `nvim-cmp` completion (LSP + LuaSnip + buffer)
- Treesitter: Java, Vim, TypeScript, TSX, Lua, Nix
- `which-key`, `vim-sleuth`, relative line numbers, persistent undo
- Space as `<leader>`; keymaps for file explorer, buffer nav, LSP (`gd`, `K`, `<leader>rn`)

### Terminal — `configs/ghostty.nix` / `configs/alacritty.nix`
- **Ghostty**: Alt+h/j/k/l vim-style pane navigation
- **Alacritty**: 80% opacity, static title

### Multiplexer — `configs/tmux.nix`
- Prefix: `Ctrl+Space`
- `|` / `-` for splits, Alt+hjkl for pane navigation
- Mouse enabled, magenta borders, 256-color, `prefix+r` to reload

### Window Manager — `configs/hypr.nix`
- **Hyprland** Wayland WM, dwindle layout, dual-monitor (DP-2 + HDMI-A-1)
- 10px rounded corners, blur, shadows, custom bezier animations
- `$terminal=ghostty`, `$browser=zen`, `$fileManager=nautilus`, `$menu=wofi`
- On **nixstation**: `mpvpaper` plays `matrix.mp4` as animated wallpaper
- On other machines: `hyprpaper` static wallpaper
- Autostart: `blueman-applet`, `sunshine`, SSH key add
- Lid-close → `hyprlock`; `Ctrl+Alt+Del` → `hyprlock`

### Status Bar — `configs/waybar.nix`
- Workspaces / clock / tray + audio + network + CPU + RAM + GPU + temp + battery
- Custom `gpu-usage-waybar` binary for AMD GPU usage
- Click CPU/RAM → `btop`; click GPU → `nvtop`

### Lock Screen — `configs/hyprlock.nix`
- Blurred `background.jpeg` (3-pass, size 8), centered password field
- Catppuccin Macchiato-style colors, no loading bar

---

## Theming

[Stylix](https://github.com/danth/stylix) applies a Base16 color scheme system-wide — terminal,
Neovim, Waybar, Hyprlock, GTK, fonts — from a single source.

- **Active scheme**: `home-manager/themes/default-dark.yaml` (dark greyscale)
- **Available schemes**: `ocean`, `atlas`, `black-metal`, `dark-vibrant`, `darkviolet`,
  `hardcore`, `outrun-dark`, `twilight`, and more in `home-manager/themes/`
- Cursor: Bibata-Modern-Classic, size 8
- Font size: 10pt everywhere

To switch themes, update the path in `pkgs/stylix.nix` and rebuild.

---

## Services

| Service | Config | Details |
|---|---|---|
| **Ollama** | `pkgs/ollama.nix` | LLM inference server (unstable), AMD ROCm GPU accel (RDNA3 / GFX 11.0.1), listens on `0.0.0.0` |
| **Steam** | `pkgs/steam.nix` | Remote play, dedicated server, local network transfer firewall rules |
| **Tailscale** | per-machine | nixstation, nixtop, nixbook, nixmac |
| **Mullvad VPN** | per-machine | nixstation, nixtop, nixbook |
| **libvirtd** | nixstation, nixserver | + virt-manager |
| **Docker / Podman** | all machines | Podman on nixstation + nixserver; Docker everywhere |
| **Sunshine** | nixstation | Game streaming server |

---

## Flake Inputs

| Input | Channel | Purpose |
|---|---|---|
| `nixpkgs` | `nixos-25.11` | Stable NixOS packages |
| `nixpkgs-unstable` | `nixos-unstable` | Bleeding-edge packages (Ollama, Neovim plugins, emulators, claude-code) |
| `home-manager` | `release-25.11` | User configuration management |
| `stylix` | `release-25.11` | System-wide theming |
| `zen-browser` | personal fork | Zen browser |
| `minegrub-theme` | — | Minecraft-style GRUB theme ("100% Flakes!") |

---

## Usage

```bash
# Rebuild and switch the current machine
nixos-rebuild switch --flake .#nixstation

# Or for another host
nixos-rebuild switch --flake .#nixtop
nixos-rebuild switch --flake .#nixbook
nixos-rebuild switch --flake .#nixserver
```

### Adding a new machine
1. Add the hostname to the `machines` list in `flake.nix`
2. Create `machines/<hostname>.nix` with system config
3. Add hardware config to `machines/hardware/<hostname>-hardware.nix`
4. Add any host-specific packages to `pkgs/packages.nix`

### Switching themes
Edit `pkgs/stylix.nix` to point at a different YAML file in `home-manager/themes/`, then rebuild.
