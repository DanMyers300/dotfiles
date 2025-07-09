# NixOS Configuration Flake

## Overview
This flake provides a modular NixOS configuration with machine-agnostic core settings and machine-specific overrides. It integrates Home Manager for user-specific configurations and includes custom packages/modules.

---

## Directory Structure
```
.
├── flake.nix            # Main flake configuration
├── machines/            # Machine-specific configurations (nixstation, nixtop)
├── home-manager/        # Home Manager configurations
│   └── config/          # Configuration files
├── pkgs/                # Custom packages and overlays
```

---

## Key Features
### 1. Modular Configuration
- **Machine Agnostic Core**: Shared settings in `flake.nix`
- **Machine-Specific Overrides**: Located in `./machines/$MACHINE.nix`
- **Home Manager Integration**: User configurations managed via `home-manager` module

### 2. Package Management
- Uses both stable (`nixpkgs`) and unstable (`nixpkgs-unstable`) channels
- Includes custom packages:
  - `zen-browser`: Custom browser configuration
  - `stylix`: Theme manager integration
  - `rain-mixer`: Custom audio player

---

## Configuration Flow
1. **Base System**: Built from shared modules in `flake.nix`
2. **Machine-Specific**: Overridden in `./machines/$MACHINE.nix`
3. **User Settings**: Applied via Home Manager modules
4. **Custom Packages**: Available through `./pkgs/` directory

---

## Home Manager Integration
Home Manager is tightly integrated into the NixOS configuration using:
```nix
home-manager = {
  useGlobalPkgs = true;
  useUserPackages = true;
  users.dan = import ./home-manager/home.nix;
};
```

---

## Usage
### Deploy Configuration
```bash
# Deploy to specific machine
nixos-rebuild switch --flake .#<machine-name>
```

---

### Adding New Machine
1. Add machine name to `machines` list in `flake.nix`
2. Create corresponding config file in `./machines/$NEW_MACHINE.nix`

### Adding Custom Packages
Place new packages in `./pkgs/packages.nix` or their own file in `./pkgs`.

---

## Inputs Explanation
| Input              | Purpose                                  |
|--------------------|------------------------------------------|
| `nixpkgs`          | Stable NixOS packages (24.11 channel)    |
| `nixpkgs-unstable` | For testing bleeding-edge packages       |
| `home-manager`     | User configuration management            |
| `stylix`           | Theme management integration             |
| `zen-browser`      | Custom browser configuration flake       |
---

## Why This Structure?
- **Separation of Concerns**:  
  - Core system in `flake.nix`  
  - Machine-specific in `/machines`  
  - User settings in `home-manager/`  

- **Unified Management**:  
  Single source of truth for both system and user configurations

- **Flexibility**:  
  Easy addition of new machines/packages while maintaining separation of concerns

---

### Zen Browser

Using my zen browser flake:
```nix
  zen = [ inputs.zen-browser.packages."${system}".default ];
```

