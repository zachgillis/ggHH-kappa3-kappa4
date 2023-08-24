#!/usr/bin/env python3

import os

def remove_files_with_extension(directory, extension):
    for filename in os.listdir(directory):
        if filename.endswith(extension):
            file_path = os.path.join(directory, filename)
            try:
                os.remove(file_path)
                print(f"Removed: {file_path}")
            except Exception as e:
                print(f"Error while removing {file_path}: {e}")

# Replace 'directory_path' with the path to your target directory
directory_path = '/home/zachgillis/POWHEG-BOX-V2/ggHH-clean-kappa3kappa4'
extension_to_remove = '.out'

remove_files_with_extension(directory_path, extension_to_remove)
