nix-env --list-generations

nix-collect-garbage  --delete-old

sudo nix-collect-garbage -d

# command to clean out boot
sudo /run/current-system/bin/switch-to-configuration boot
