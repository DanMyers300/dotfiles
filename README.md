# Nixos Configuration

## Flake.nix

This contains the main functionality of the nixos configuration.
My primary computer is nixstation but I have a machine agnostic function to setup my flakes.
The machine specific items are in /machines.

## Home manager

Home manager to handle my .config and other user specific items.

## /pkgs

My primary package managing dir

## .config

Some may ask why I have a .config file in my nixos configuration.
They may say "that's a nixos anti-pattern."
To them I say: "I don't care."
