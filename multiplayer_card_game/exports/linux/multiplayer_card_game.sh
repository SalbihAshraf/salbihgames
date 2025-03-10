#!/bin/sh
echo -ne '\033c\033]0;multiplayer_card_game\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/multiplayer_card_game.x86_64" "$@"
