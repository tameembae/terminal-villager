#!/usr/bin/env bash

shopt -s nullglob

SOUND_DIR="$HOME/.local/share/sounds"
if ! [ -d "$SOUND_DIR" ]; then
  echo "Sound directory not found: $SOUND_DIR"
  return 1
fi

# Evaluate glob prior to hook for efficiency
sound_files=("$SOUND_DIR"/*.ogg)
death_sounds=("$SOUND_DIR"/*death*.ogg)
hurt_sounds=("$SOUND_DIR"/*hurt*.ogg)
confused_sounds=("$SOUND_DIR"/*trade*.ogg)

if [ "${#sound_files[@]}" -lt 1 ]; then
  echo "No sound files matched glob: $SOUND_DIR/*.ogg"
  return 1
fi

sound() {
  status=$?

  # Don't play sound for success or CTRL-C
  if [ "$status" -eq 0 ] || [ "$status" -eq 130 ]; then
    return 0
  fi

  # Hurt sound for exit code 1
  if [ "$status" -eq 1 ] && [ ${#hurt_sounds[@]} -gt 0 ]; then
    sounds=("${hurt_sounds[@]}")
  # Confused sound for command not found
  elif [ "$status" -eq 127 ] && [ ${#confused_sounds[@]} -gt 0 ]; then
    sounds=("${confused_sounds[@]}")
  # Death sound for SIGKILL
  elif [ "$status" -eq 137 ] && [ ${#death_sounds[@]} -gt 0 ]; then
    sounds=("${death_sounds[@]}")
  # Otherwise random sound
  else
    sounds=("${sound_files[@]}")
  fi

  sound_file=${sounds[ $RANDOM % ${#sounds[@]} ]}

  # echo "$status: $sound_file"

  if hash afplay >/dev/null 2>&1; then
    afplay "$sound_file" >/dev/null 2>&1 &
    disown $!
  elif hash paplay >/dev/null 2>&1; then
    paplay "$sound_file" >/dev/null 2>&1 &
    disown $!
  elif hash aplay >/dev/null 2>&1; then
    aplay -q "$sound_file" >/dev/null 2>&1 &
    disown $!
  elif hash termux-media-player >/dev/null 2>&1; then
    termux-media-player play "$sound_file" >/dev/null 2>&1 &
    disown $!
  fi
}
PROMPT_COMMAND="sound"

