function lights
  set -l dir $HOME/.config/alacritty

  switch $argv[1]
    case on
      echo "🌕 turning lights on"
      echo 'light' > $HOME/.theme
      cp -f $dir/light.toml $dir/alacritty.toml
    case off out
      echo "🌑 turning lights off"
      echo 'dark' > $HOME/.theme
      cp -f $dir/dark.toml $dir/alacritty.toml
    case '*'
      echo "usage: lights on|off"
      return 1
  end
end
