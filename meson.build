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
godot_cpp_short_lib_name = 'libgodot-cpp.' + godot_cpp_platform + '.debug.64'
godot_cpp_lib_name = godot_cpp_short_lib_name + '.a'
godot_cpp_output_path = join_paths(join_paths(godot_cpp_path, 'bin'), godot_cpp_lib_name)
godot_cpp_include_directories = include_directories([join_paths('godot-cpp', 'include'), join_paths('godot-cpp', join_paths('include', 'core')), join_paths('godot-cpp', join_paths('include', 'gen'))])

# can be uncommented until issue fixed
# compile_bindings = custom_target('make-bindings',
#     input : [join_paths(godot_cpp_path, 'SConstruct')],
#     output : [godot_cpp_lib_name],
#     command : [make_bindings_script, godot_cpp_path, godot_cpp_platform, scons_bin.path(), godot_cpp_output_path, get_option('cpu-threads'), godot_cpp_lib_name],
# )
message(join_paths(godot_cpp_path, 'bin'))
# custom target link whole broken until https://github.com/mesonbuild/meson/issues/5797 fixed, this is a workaround
compile_bindings_library = meson.get_compiler('cpp').find_library(godot_cpp_short_lib_name, dirs : join_paths(godot_cpp_path, 'bin'), 
    static : true)

# game source files
godot_srcs = files()
subdir('blend2d-bindings') # blend2d gdnative library
subdir('src') # godot project source