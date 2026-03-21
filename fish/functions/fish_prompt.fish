function fish_prompt
  echo

  set_color blue
  echo -n (prompt_pwd -d 0)

  if git branch --show-current 2>/dev/null | read branch
    set_color yellow
    echo -n " $branch"

    if test -n "$(git status --short 2>/dev/null)"
      set_color red
      echo -n " ✗"
    end
  end

  echo
  set_color 808080
  echo -n '% '
  set_color normal
end
