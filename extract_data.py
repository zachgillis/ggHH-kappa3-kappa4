#!/usr/bin/env python3

import os
import subprocess
import csv
import re
import sys

def get_most_recent_directory():
    directories = [d for d in os.listdir() if os.path.isdir(d)]

    sorted_directories = sorted(directories, key=lambda d: os.path.getctime(d), reverse=True)

    if sorted_directories:
        return sorted_directories[0]
    else:
        return None

if len(sys.argv) == 2:
    base_directory = sys.argv[1]
else:
    base_directory = get_most_recent_directory()

def main():
    print(base_directory)

    csv_file_path = os.path.join(base_directory, 'results.csv')
    with open(csv_file_path, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['Kappa3', 'Cross Section', 'Uncertainty'])

        for dir_name in os.listdir(base_directory):
            dir_path = os.path.join(base_directory, dir_name)

            if os.path.isdir(dir_path):
                run_number = float(dir_name[3:])

                log_path = dir_path + '/out.log'
                grep_command = 'grep "total .* cross" ' + log_path

                try:
                    output_bytes = subprocess.check_output(grep_command, shell=True)
                    output = output_bytes.decode('utf-8').strip()

                    match = re.search(r'cross section in pb\s+([\d.E-]+)\s+\+-\s+([\d.E-]+)', output)
                    if match:
                        cross_section = match.group(1)
                        uncertainty = match.group(2)
                    else:
                        cross_section = 'N/A'
                        uncertainty = 'N/A'
                except subprocess.CalledProcessError:
                    cross_section = 'Command execution failed'
                    uncertainty = ''

                csv_writer.writerow([run_number, cross_section, uncertainty])

if __name__ == "__main__":
    main()
