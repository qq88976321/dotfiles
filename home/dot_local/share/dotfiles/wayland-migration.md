# Wayland migration checklist

This repo keeps the existing X11 i3, polybar, picom, rofi, and dunst setup as
the rollback path while adding a parallel Sway desktop profile for machines
where `is_desktop_env` is true.

## Ubuntu 24.04 packages

Install the Wayland stack with the distribution package manager. Package names
may differ on non-Ubuntu systems.

```sh
sudo apt install \
  sway waybar fuzzel mako-notifier grim slurp wl-clipboard \
  xdg-desktop-portal xdg-desktop-portal-wlr pipewire wireplumber \
  swayidle swaylock kanshi wlr-randr pavucontrol brightnessctl \
  network-manager-gnome gnome-keyring playerctl
```

Optional tools:

```sh
sudo apt install swappy
```

`swappy` is not required by these configs. Screenshot bindings save a file and
copy it to the clipboard using `grim`, `slurp`, and `wl-copy`.

## Login and rollback

Use the display manager session picker to choose either `Sway` or the existing
`i3` session.

Rollback is intentionally simple:

1. Log out of Sway.
2. Select the existing i3 session.
3. Keep using the X11 configs under `.config/i3`, `.config/polybar`,
   `.config/picom`, `.config/rofi`, and `.config/dunst`.

The Wayland configs do not remove or rewrite the X11 fallback.

## App launch defaults

Prefer native Wayland where the application supports it:

```sh
google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --password-store=gnome
code --enable-features=UseOzonePlatform --ozone-platform=wayland
MOZ_ENABLE_WAYLAND=1 thunderbird
kitty
```

Fallback commands when a native Wayland path misbehaves:

```sh
google-chrome-stable --ozone-platform=x11 --password-store=gnome
code --ozone-platform=x11
thunderbird
~/.joplin/Joplin.AppImage
```

For Joplin AppImage builds, Electron and AppImage versions vary. Start with the
normal command and fall back to XWayland if native Wayland rendering or input is
unreliable.

## Runtime substitutions

The Sway path uses Wayland-native tools:

- `waybar` replaces polybar.
- `fuzzel` replaces `rofi -show drun`.
- `mako` replaces dunst.
- `swayidle` and `swaylock` replace `xss-lock` and `i3lock-fancy`.
- `grim`, `slurp`, and `wl-copy` replace `flameshot gui`.
- `swaymsg -t get_tree` replaces `xprop` for window matching.
- `swaymsg exit` replaces `i3-msg exit`.
- `wpctl` (from wireplumber) replaces `pactl` for volume and mute key bindings,
  and waybar uses its native `wireplumber` module for the sink plus a
  `custom/mic` module driven by `wpctl` for the source. `pavucontrol` still
  works against the `pipewire-pulse` shim if needed.

Caps Lock remapping is intentionally not ported to Wayland in this migration.
No `setxkbmap`, `xcape`, `keyd`, or replacement daemon is added for Sway.

## Clipboard validation

Run these checks after applying the dotfiles:

```sh
printf wayland-test | clipboard-copy
```

Paste into Chrome, kitty, or another local Wayland application.

For the X11 fallback session:

```sh
DISPLAY=:0 printf x11-test | clipboard-copy
```

Paste into an X11 application while running i3.

For remote SSH with tmux, verify OSC52 through the local terminal:

```sh
printf remote-test | tmux load-buffer -w -
```

Nested local tmux is not optimized in this version. The selected policy is tmux
OSC52 with `set-clipboard external`.

## Desktop validation

After logging into Sway, verify:

1. `Mod4+Return` opens kitty.
2. `Mod4+d` opens fuzzel.
3. Workspaces 1 through 10 switch and move containers as expected.
4. `Print` captures a selected region to a file and the clipboard.
   `Shift+Print` captures the full output.
5. `Scroll_Lock` locks with swaylock.
6. Idle lock and suspend behavior works through swayidle.
7. Waybar shows workspaces, mode, date, CPU, memory, network, audio input,
   audio output, backlight, tray, and power controls.
8. Audio keys, mic mute, brightness keys, and network tray controls work.
9. Chrome, VS Code, Thunderbird, Joplin, and kitty start and accept text input.
10. Chrome and VS Code screen sharing work through xdg-desktop-portal-wlr.
11. The existing i3 session still starts unchanged.
