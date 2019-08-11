#!/usr/bin/env python3

import os
import sys
import shutil
import tempfile
import subprocess
import zipfile
from pathlib import Path

EXE_NAME = "sketch-fight"
ITCH_ORGANIZATION = "creikey"
BUILD_DIR = "build"
SRC_DIR = "src"
EDITOR_SETTINGS_PATH = "~/.config/godot/editor_settings-3.tres"
PLATFORMS = ["windows", "mac", "linux"]  # must corrispond to platform export in godot
ZIP_CMD = "zip"
UNZIP_CMD = "unzip"
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
    check_for_file_or_directory(SRC_DIR)  # needs to be at root
    if len(sys.argv) <= 2 or not sys.argv[1] in PLATFORMS:
        eprint("Expected first argument to be one of ", end="")
        for p in PLATFORMS[:-1]:
            eprint(f"`{p}`, ", end="")
        eprint(f"or `{PLATFORMS[len(PLATFORMS) - 1]}`.")
        eprint(
            "Expected second argument to be either `true` or `false` to specify butler pushing"
        )
        exit(1)
    platform = sys.argv[1]
    butler_push = sys.argv[2]
    if butler_push == "true":
        butler_push = True
    elif butler_push == "false":
        butler_push = False
    else:
        eprint(f"Unrecognized butler push option `{butler_push}`")
        exit(1)

    editor_settings_path = os.path.expanduser(
        os.getenv("EDITOR_SETTINGS_PATH", EDITOR_SETTINGS_PATH)
    )  # checks user env for path
    zip_cmd = os.getenv("ZIP_CMD", ZIP_CMD)
    unzip_cmd = os.getenv("UNZIP_CMD", UNZIP_CMD)
    rm_cmd = os.getenv("RM_CMD", RM_CMD)
    pwd_cmd = os.getenv("PWD_CMD", PWD_CMD)
    godot_headless_cmd = os.getenv("GODOT_HEADLESS_CMD", GODOT_HEADLESS_CMD)
    butler_cmd = os.getenv("BUTLER_CMD", BUTLER_CMD)

    check_for_command(zip_cmd)
    check_for_command(unzip_cmd)
    check_for_command(rm_cmd)
    check_for_command(pwd_cmd)
    check_for_command(godot_headless_cmd)
    check_for_command(butler_cmd)
    check_for_file_or_directory(editor_settings_path)
    ensure_directory(BUILD_DIR)
    for p in PLATFORMS:
        ensure_directory(BUILD_DIR + "/" + p)

    input("Please quit all instances of godot ...")

    # cache editor settings
    editor_settings_cache_directory = tempfile.TemporaryDirectory()
    editor_settings_cache_path = os.path.join(
        editor_settings_cache_directory.name, "editor-settings-cache.tres"
    )
    shutil.copy2(editor_settings_path, editor_settings_cache_path)

    # correct exe name on windows export
    exe_name = EXE_NAME
    if platform == "windows":
        exe_name += ".exe"
    build_dir = os.path.abspath(BUILD_DIR)
    src_dir = os.path.abspath(SRC_DIR)

    print(f"Exporting game for {platform}...")
    exporting_process = subprocess.Popen(
        [
            godot_headless_cmd,
            "--export",
            platform,
            f"{build_dir}/{platform}/{exe_name}",
        ],
        cwd=src_dir,
    )
    exporting_process.wait()

    print(f"Making easily accessable zip for {platform}...")
    if platform == "windows":
        exe_name = os.path.splitext(exe_name)[0]
    shutil.make_archive(
        f"{build_dir}/{exe_name}-{platform}", "zip", f"{build_dir}/{platform}"
    )
    if platform == "windows":
        exe_name += ".exe"

    if butler_push:
        if platform == "mac":
            print("Unzipping mac build for itch ...")
            with zipfile.ZipFile(f"{build_dir}/{platform}/{exe_name}", "r") as zip_ref:
                zip_ref.extractall(f"{build_dir}/{platform}")
            pushing_process = subprocess.Popen(
                [
                    butler_cmd,
                    "push",
                    f"{build_dir}/{platform}/{to_mac_folder(exe_name)}",
                    f"{ITCH_ORGANIZATION}/{exe_name}:{platform}",
                ]
            )
        else:
            pushing_process = subprocess.Popen(
                [
                    butler_cmd,
                    "push",
                    f"{build_dir}/{platform}",
                    f"{ITCH_ORGANIZATION}/{exe_name}:{platform}",
                ]
            )
        pushing_process.wait()

    shutil.copy2(editor_settings_cache_path, editor_settings_path)
    editor_settings_cache_directory.cleanup()
    print("Done.")


if __name__ == "__main__":
    main()

