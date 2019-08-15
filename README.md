# sketch-fight
A multiplayer fighting game where the pieces are drawn.

## building
The platforms supported and their names are
 - `windows`
 - `mac`
 - `linux`

The cross compilation files provided are for situations where the build system is an arch linux machine. For cross compiling from a different build machine type, see [https://mesonbuild.com/Cross-compilation.html]

`meson` is used to build/compile everything

Use these build directories in order for everything ( copying libraries to godot dirs ) to work properly:

`build` - native builds

`build-windows` - windows build

`build-mac` - mac build

`build-linux` - linux build
