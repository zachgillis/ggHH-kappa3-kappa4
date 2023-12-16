#!/usr/bin/env python3

import os

WORKDIR = '/home/zachgillis/PWHG-7'

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
directory_path = os.path.join(WORKDIR, 'ggHH-kappa3-kappa4')

remove_files_with_extension(directory_path, '.out')
remove_files_with_extension(directory_path, '.err')
