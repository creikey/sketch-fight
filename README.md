# sketch-fight
A multiplayer fighting game where the pieces are drawn.

## building
The script `build.py` uses the following environment variables

`EDITOR_SETTINGS_PATH` - path to the editor settings, caches them so not lost on cli export
`ZIP_CMD` - path to zip command
`RM_CMD` - path to remove command
`PWD_CMD` - path to pwd command
`GODOT_HEADLESS_CMD` - path to godot headless binary command
`BUTLER_CMD` - path to butler command, for exporting to itch

## build script conventions

 - lower case version of all caps constant is real updated value from environment
 - export options in godot must be `windows`, `mac`, and `linux`, as in the script file
 - check_for functions error if it can't find it, ensure ensures that it exists
