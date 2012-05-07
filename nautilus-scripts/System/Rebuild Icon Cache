#!/bin/sh
find /usr/share/icons -mindepth 1 -maxdepth 1 -type d | while read -r THEME; do
  if [ -f "$THEME/index.theme" ]; then
    gtk-update-icon-cache -f -q "$THEME"
  fi
done
