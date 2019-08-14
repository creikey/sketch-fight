library_sources = files('gdexample.cpp','gdexample.h','gdlibrary.cpp','meson.build')

blend2d_bindings_library = shared_library('blend2dbindings',
library_sources,
include_directories : godot_cpp_include_directories,
link_whole : compile_bindings_library)