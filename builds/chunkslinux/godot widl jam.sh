#!/bin/sh
printf '\033c\033]0;%s\a' godot widl jam
base_path="$(dirname "$(realpath "$0")")"
"$base_path/godot widl jam.x86_64" "$@"
