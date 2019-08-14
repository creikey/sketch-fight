#!/usr/bin/env python3

import zipfile
import subprocess
import os
import sys


def to_mac_folder(name: str):
    return name.replace("-", " ").title() + ".app"


platform = sys.argv[1]
godot_output_path = sys.argv[2]
itch_organization = sys.argv[3]
game_name = sys.argv[4]
butler_cmd_path = sys.argv[5]

godot_output_folder = os.path.dirname(godot_output_path)

push_folder = godot_output_folder

if platform == "mac":
    with zipfile.ZipFile(godot_output_path, "r") as zip_ref:
        zip_ref.extractall(godot_output_folder)
    push_folder = os.path.join(godot_output_folder, to_mac_folder(game_name))

pushing_process = subprocess.Popen(
    [
        butler_cmd_path,
        "push",
        push_folder,
        f"{itch_organization}/{game_name}:{platform}",
    ]
)
print([
        butler_cmd_path,
        "push",
        push_folder,
        f"{itch_organization}/{game_name}:{platform}",
    ])
pushing_process.wait()
if pushing_process.returncode != 0:
    raise Exception("Failed to push with butler to itch")


