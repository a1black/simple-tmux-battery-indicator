# Tmux battery status
Plugin enables displaying battery percentage in status line.

### Remarks
Plugin currently only implements interface for *upower* command-line tool (it's only one I need). But plugin can be easily exteneded to alternative tools.

## Installation
### Installation with [TPM](https://github.com/tmux-plugins/tpm)
1. Add plugin to `~/.tmux.conf` with `set -g @plugin 'a1black/simple-tmux-battery-indicator'`
2. Press `prefix` + <kbd>I</kbd> to fetch the plugin.
### Manual installation
1. Clone plugin: 

   $ git clone https://github/a1black/simple-tmux-battery-indicator ~/clone/path

2. Add plugin to the bottom of `~/.tmux.conf` with `run-shell ~/clone/path/simple_battery.tmux`

## Usage
Add following format strings to tmux status line:
- `#{battery_status_fg}` - will set foreground color based on battery remain energy
- `#{battery_status_bg}` - will set background color based on battery remain energy
- `#{battery_percentage}` - will show battery remain energy

### Example
Add format string to status-right:

    # ~/.tmux.conf
    set -g status-right '#{battery_percentage} #[fg=default] | #(whoami)'

If battery is not charging this results in output ({remain energy} {remain time} ...)

    25% 2:34 | a1black

If battery is charging:

    ⚡️ 60% | a1black
