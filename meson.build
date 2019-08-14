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
godot_cpp_path = join_paths(meson.source_root(), 'godot-cpp')
godot_cpp_lib_name = 'libgodot-cpp.' + godot_cpp_platform + '.debug.64.a'
godot_cpp_output_path = join_paths(join_paths(godot_cpp_path, 'bin'), godot_cpp_lib_name)

compile_bindings = custom_target('make-bindings',
    input : [join_paths(godot_cpp_path, 'SConstruct')],
    output : [godot_cpp_lib_name],
    command : [make_bindings_script, godot_cpp_path, godot_cpp_platform, scons_bin.path(), godot_cpp_output_path, get_option('cpu-threads'), godot_cpp_lib_name],
)

# game source files
godot_srcs = files()
subdir('src') # godot project source