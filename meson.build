project('sketch-fight', 'cpp')

cmake = import('cmake')

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

blend2d_cmake_options = []

if meson.is_cross_build()
  if godot_platform == 'windows'
    blend2d_cmake_options += '-DCMAKE_SYSTEM_NAME=Windows'
  elif godot_platform == 'linux'
    blend2d_cmake_options += '-DCMAKE_SYSTEM_NAME=Linux'
  elif godot_platform == 'mac'
    blend2d_cmake_options += '-DCMAKE_SYSTEM_NAME=Darwin'
  else
    warning('Could not find correct platform string for cmake cross build')
  endif
  blend2d_cmake_options += '-DCMAKE_SYSROOT=' + meson.get_cross_property('sys_root', '/')
  blend2d_cmake_options += '-DCMAKE_EXE_LINKER_FLAGS= -static'
  blend2d_cmake_options += '-DBLEND2D_DEPS= -static-libgcc -static-libstdc++'
  #blend2d_cmake_options += '-DCMAKE_C_COMPILER=' + meson.get_compiler('c')
  #blend2d_cmake_options += '-DCMAKE_CXX_COMPILER=' + meson.get_compiler('cpp')
endif

blend2d_proj = cmake.subproject('blend2d',
    cmake_options : [
    ] + blend2d_cmake_options)
blend2d_lib = blend2d_proj.dependency('blend2d')
if godot_platform == 'windows'
  blend2d_filename = 'libblend2d.dll'
else
  blend2d_filename = 'libblend2d.so'
endif
blend2d_path = join_paths(meson.build_root(), 'subprojects', 'blend2d', blend2d_filename)

libgodot_cpp_proj = subproject('godot-cpp')
libgodot_cpp = libgodot_cpp_proj.get_variable('lib')
libgodot_cpp_inc = libgodot_cpp_proj.get_variable('inc')
libgodot_cpp_dep = libgodot_cpp_proj.get_variable('lib_dep')


# game source files
godot_srcs = files()
subdir('blend2d-bindings') # blend2d gdnative library

libraries_string = ''
libraries = [blend2d_bindings_library.full_path(), blend2d_path]
foreach l : libraries
    libraries_string += l
    libraries_string += '\n'
endforeach

subdir('src') # godot project source

if butler_bin.found()
    run_target('push',
        command : [push_script, godot_platform, join_paths(meson.current_build_dir(), game_executable_name), get_option('organization_name'), get_option('game_name'), butler_bin.path()])
endif
