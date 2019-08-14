godot_srcs += files(
    'CameraFocus.gd',
    'default_env.tres',
    'doughnut.svg',
    'doughnut.svg.import',
    'editing-lines.svg',
    'editing-lines.svg.import',
    'export_presets.cfg',
    'icon.png',
    'icon.png.import',
    'LineSet.gd',
    'LineSet.tscn',
    'Main.tscn',
    'meson.build',
    'mirror-line.svg',
    'mirror-line.svg.import',
    'MousePuck.gd',
    'PossiblePoint.gd',
    'PossiblePoint.tscn',
    'project.godot',
    'SketchEditor.gd',
    'SketchEditor.tscn',
    'Sketch.gd',
    'Sketch.tscn',
)
message('@BUILD_DIR@')
package_godot = custom_target('package-godot',
    input: godot_srcs,
    output: [game_executable_name, game_executable_name + '.pck'],
    command : [package_script, godot_bin.path(), godot_platform, join_paths(meson.source_root(), meson.current_source_dir()), meson.current_build_dir(), game_executable_name, get_option('godot_settings')],
    build_by_default : true
)
if butler_bin.found()
    run_target('push',
        command : [push_script, godot_platform, join_paths(meson.current_build_dir(), game_executable_name), get_option('organization_name'), get_option('game_name'), butler_bin.path()])
endif