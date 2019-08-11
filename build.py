#!/usr/bin/env python3

import os
import sys
import shutil
import tempfile
from pathlib import Path

EXE_NAME = "naval-battle"
BUILD_DIR = "build"
SRC_DIR = "src"
EDITOR_SETTINGS_PATH = "~/.config/godot/editor_settings-3.tres"
PLATFORMS = ["windows", "mac", "linux"]  # must corrispond to platform export in godot
ZIP_CMD = "zip"
RM_CMD = "rm"
PWD_CMD = "pwd"
GODOT_HEADLESS_CMD = "godot-headless"
BUTLER_CMD = "butler"


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def to_mac_folder(name: str):
    return name.replace("-", " ").title() + ".app"


def check_for_command(command_name: str):
    if shutil.which(command_name) == None:
        eprint(f"Command `{command_name}` not found!")
        exit(1)


def check_for_file_or_directory(directory_path: str):
    directory_path = os.path.expanduser(directory_path)
    if not os.path.exists(directory_path):
        eprint(f"Could not find file or directory `{directory_path}`!")
        exit(1)


def ensure_directory(directory_path: str):
    if not os.path.exists(directory_path):
        os.makedirs(directory_path)
    check_for_file_or_directory(directory_path)


def main():
    editor_settings_path = os.path.expanduser(
        os.getenv("EDITOR_SETTINGS_PATH", EDITOR_SETTINGS_PATH)
    )  # checks user env for path
    zip_cmd = os.getenv("ZIP_CMD", ZIP_CMD)
    rm_cmd = os.getenv("RM_CMD", RM_CMD)
    pwd_cmd = os.getenv("PWD_CMD", PWD_CMD)
    godot_headless_cmd = os.getenv("GODOT_HEADLESS_CMD", GODOT_HEADLESS_CMD)
    butler_cmd = os.getenv("BUTLER_CMD", BUTLER_CMD)

    check_for_command(zip_cmd)
    check_for_command(rm_cmd)
    check_for_command(pwd_cmd)
    check_for_command(godot_headless_cmd)
    check_for_command(butler_cmd)
    check_for_file_or_directory(SRC_DIR)
    check_for_file_or_directory(editor_settings_path)
    ensure_directory(BUILD_DIR)
    for p in PLATFORMS:
        ensure_directory(BUILD_DIR + "/" + p)

    input("Please quit all instances of godot ...")

    editor_settings_cache_directory = tempfile.TemporaryDirectory()
    editor_settings_cache_path = os.path.join(
        editor_settings_cache_directory.name, "editor-settings-cache.tres"
    )
    shutil.copy2(editor_settings_path, editor_settings_cache_path)

    print(to_mac_folder(EXE_NAME))

    shutil.copy2(editor_settings_cache_path, editor_settings_path)

    editor_settings_cache_directory.cleanup()

if __name__ == "__main__":
    main()

