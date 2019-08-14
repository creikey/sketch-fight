project('sketch-fight', 'cpp')

# resolve godot platform export variable
godot_platform = host_machine.system()


godot_bin = find_program(get_option('godot_name'), native : true) # for exporting
butler_bin = find_program(get_option('butler_name'), native : true, required : false)
package_script = find_program('build-scripts/package.py')
push_script = find_program('build-scripts/push.py')
game_executable_name = godot_platform + '-' + get_option('game_name')

if godot_platform == 'windows'
    game_executable_name += '.exe'
endif

# game source files
godot_srcs = files()
subdir('src') # godot project source