#!/usr/bin/env python3

import sys
import os
import shutil
import zipfile
import subprocess
import tempfile
import atexit


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


godot_bin_path = sys.argv[1]
platform_name = sys.argv[2]
source_directory = sys.argv[3]
output_directory = sys.argv[4]
print(f"output directory: {output_directory}")
game_name = sys.argv[5]
editor_settings_path = os.path.expanduser(sys.argv[6])
gdnative_library_path = sys.argv[7]

def ensure_directory(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

if not os.path.exists(editor_settings_path):
    os.mknod(editor_settings_path)

# copy build outputs
native_output_path = (platform_name, os.path.join(source_directory, "build"))
windows_output_path = ("windows", os.path.join(source_directory, "build-windows"))
mac_output_path = ("mac", os.path.join(source_directory, "build-mac"))
linux_output_path = ("linux", os.path.join(source_directory, "build-linux"))
for p in [native_output_path, windows_output_path, mac_output_path, linux_output_path]:
    print("checking path " + p[1])
    if os.path.exists(p[1]):
        output_folder = os.path.join(source_directory, "src", "bin", p[0])
        ensure_directory(output_folder)
        shutil.copy2(gdnative_library_path, output_folder)

editor_settings_cache_directory = tempfile.TemporaryDirectory()
editor_settings_cache_path = os.path.join(
    editor_settings_cache_directory.name, "editor-settings-cache.tres"
)
shutil.copy2(editor_settings_path, editor_settings_cache_path)


def cleanup_editor_settings():
    shutil.copy2(editor_settings_cache_path, editor_settings_path)
    editor_settings_cache_directory.cleanup()


atexit.register(cleanup_editor_settings)

exporting_process = subprocess.Popen(
    [
        godot_bin_path,
        "--export",
        platform_name,
        "--path",
        os.path.join(source_directory, "src"),
        os.path.join(output_directory, game_name),
    ]
)
exporting_process.wait()
if exporting_process.returncode != 0:
    raise Exception("Failed to export godot game")