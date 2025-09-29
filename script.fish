#!/usr/bin/env fish

set SOUND_DIR "$HOME/.local/share/sounds"

# Check if the directory exists and has files
if not test -d "$SOUND_DIR"
    echo "Sound directory not found: $SOUND_DIR"
    return 1
end

set sound_files "$SOUND_DIR"/*.ogg
set death_files "$SOUND_DIR"/*death*.ogg
set hurt_files "$SOUND_DIR"/*hurt*.ogg
set confused_files "$SOUND_DIR"/*trade*.ogg

# Only proceed if there are sound files
if test (count $sound_files) -lt 1
    echo "No sound files matched glob: $SOUND_DIR/*.ogg"
    return 1
end

function play_error_sound --on-event fish_prompt
    # Fish uses $status for the exit code, instead of $?
    # Also ignore exit code 130, which is for Ctrl+C
    set STATUS $status
    if test $STATUS = 0 || test $STATUS = 130
        return 0
    end

    if test $STATUS = 1 && test (count $hurt_files) -gt 0
        # Hurt sound for exit code 1
        set sound_file (random choice $hurt_files)
    else if test $STATUS = 127 && test (count $confused_files) -gt 0
        # Confused sound for command not found
        set sound_file (random choice $confused_files)
    else if test $STATUS = 137 && test (count $death_files) -gt 0
        # Death sound for SIGKILL
        set sound_file (random choice $death_files)
    else
        # Otherwise random sound
        set sound_file (random choice $sound_files)
    end

    # Check for a sound player and use the first one found
    # Add >/dev/null 2>&1 to silence output from the background process
    if command -v afplay >/dev/null # For macOS
        afplay "$sound_file" >/dev/null 2>&1 &
    else if command -v paplay >/dev/null
        paplay "$sound_file" >/dev/null 2>&1 &
    else if command -v aplay >/dev/null
        aplay -q "$sound_file" >/dev/null 2>&1 &
    end
end
