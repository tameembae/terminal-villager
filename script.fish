#!/usr/bin/env fish
function play_error_sound --on-event fish_prompt
    # Fish uses $status for the exit code, instead of $?
    # Also ignore exit code 130, which is for Ctrl+C
    if test $status -ne 0 -a $status -ne 130
        set sound_dir "$HOME/.local/share/sounds"

        # Check if the directory exists and has files
        if test -d "$sound_dir"
            set sound_files "$sound_dir"/*.ogg

            # Only proceed if there are sound files
            if test (count $sound_files) -gt 0
                set sound_file (random choice $sound_files)

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
        end
    end
end
