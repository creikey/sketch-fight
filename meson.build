project('sketch-fight', 'cpp')

# resolve godot platform export variable
godot_platform = host_machine.system()


godot_bin = find_program(get_option('godot_name'), native : true) # for exporting
butler_bin = find_program(get_option('butler_name'), native : true, required : false)
scons_bin = find_program(get_option('scons_name'), native : true)
package_script = find_program('build-scripts/package.py')
push_script = find_program('build-scripts/push.py')
make_bindings_script = find_program('build-scripts/make_bindings.py')
game_executable_name = godot_platform + '-' + get_option('game_name')

if godot_platform == 'windows'
    game_executable_name += '.exe'
endif


godot_cpp_platform = godot_platform
if godot_cpp_platform == 'mac'
    godot_cpp_platform = 'osx'
endif

libgodot_cpp_proj = subproject('godot-cpp')
libgodot_cpp = libgodot_cpp_proj.get_variable('lib')
libgodot_cpp_inc = libgodot_cpp_proj.get_variable('inc')
libgodot_cpp_dep = libgodot_cpp_proj.get_variable('lib_dep')


# game source files
godot_srcs = files()
subdir('blend2d-bindings') # blend2d gdnative library
subdir('src') # godot project source

package_godot = custom_target('package-godot',
    input: godot_srcs,
    output: [game_executable_name, game_executable_name + '.pck'],
    command : [package_script, godot_bin.path(), godot_platform, join_paths(meson.source_root(), meson.current_source_dir()), meson.current_build_dir(), game_executable_name, get_option('godot_settings')],
    depends : [blend2d_bindings_library],
    build_by_default : true
)
if butler_bin.found()
    run_target('push',
        command : [push_script, godot_platform, join_paths(meson.current_build_dir(), game_executable_name), get_option('organization_name'), get_option('game_name'), butler_bin.path()])
endif