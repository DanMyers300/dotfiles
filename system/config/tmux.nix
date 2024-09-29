{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
	# Set prefix to ctrl+space
	unbind-key C-b
	set-option -g prefix C-Space
	bind-key C-Space send-prefix

	# Remap window split
	bind | split-window -h
	bind - split-window -v
	unbind '"'
	unbind %

	# Bash fix
	set-option -g default-command $SHELL

	# Mouse
	set -g mouse on

	# Alt - arrow pane switching
	bind -n M-h select-pane -L
	bind -n M-l select-pane -R
	bind -n M-k select-pane -U
	bind -n M-j select-pane -D

	# Colors
	set -g default-terminal "screen-256color"
	set -g status-bg black
	set -g status-fg white
	set -g pane-border-style fg=magenta
	set -g pane-active-border-style "bg=default fg=magenta"

	# Reload tmux config with prefix + r
	bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"
    '';
  };
}
