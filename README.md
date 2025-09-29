# Terminal Villager

Play a Minecraft villager sound every time you make a typo.

This currently only supports the `fish` and `bash` shell. 
Contributions for other shells are welcome.

## Installation
To use the install script:

```bash
git clone https://github.com/ProfessionalGriefer/terminal-villager
cd terminal-villager
./install.sh
```

## Removing terminal-villager
- Remove the sound files:
```sh
rm -rf ~/.local/share/sounds/Villager_*.ogg
```

- Open `~/.config/fish/config.fish` or `~/.bashrc` and remove the `play_error_sound` function

## Sound files
Sound files are downloaded from the [Minecraft Wiki](https://minecraft.wiki/w/Category:Villager_sounds).
