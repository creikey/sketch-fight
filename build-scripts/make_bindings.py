#!/usr/bin/env python3

import sys
import subprocess
import os
import shutil

godot_cpp_path = sys.argv[1]
platform_name = sys.argv[2]
scons_path = sys.argv[3]
output_library_path = sys.argv[4]
cpu_threads = sys.argv[5]
output_library_name = sys.argv[6]


if not os.path.exists(output_library_path):
    compile_process = subprocess.Popen(
        [
            scons_path,
            "platform=" + platform_name,
            "generate_bindings=yes",
            "-j" + cpu_threads,
        ],
        cwd=godot_cpp_path
    )
    compile_process.wait()
    if compile_process.returncode != 0:
        raise Exception("Failed to compile godot C++ bindings")

shutil.copy2(output_library_path, output_library_name)