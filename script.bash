#!/usr/bin/env bash

shopt -s nullglob

SOUND_DIR="$HOME/.local/share/sounds"
if ! [ -d "$SOUND_DIR" ]; then
  echo "Sound directory not found: $SOUND_DIR"
  return 1
fi

# Evaluate glob prior to hook for efficiency
sound_files=("$SOUND_DIR"/*.ogg)

if [ "${#sound_files[@]}" -lt 1 ]; then
  echo "No sound files matched glob: $SOUND_DIR/*.ogg"
  return 1
fi

sound() {
  status=$?

  if [ "$status" -eq 0 ] || [ "$status" -eq 130 ]; then
    return 0
  fi

  sound_file=${sound_files[ $RANDOM % ${#sound_files[@]} ]}

  echo "$status: $sound_file"

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

