library_sources = files('gdexample.cpp','gdexample.h','gdlibrary.cpp')

blend2d_bindings_library = shared_library('blend2dbindings',
library_sources,
include_directories : libgodot_cpp_inc,
dependencies : blend2d_lib,
link_whole : libgodot_cpp)