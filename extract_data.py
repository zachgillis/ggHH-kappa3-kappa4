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
        csv_writer.writerow(['Kappa3', 'Kappa4', 'Cross Section', 'Uncertainty'])

        for dir_name in os.listdir(base_directory):
            dir_path = os.path.join(base_directory, dir_name)

            if os.path.isdir(dir_path):
                numbers = re.findall(r'-?\d+\.\d+', dir_name)
                number_array = [float(num) for num in numbers]

                kappa3 = number_array[0]
                kappa4 = number_array[1]

                log_path = dir_path + '/out.log'
                grep_command = 'grep "total .* cross" ' + f'\'{log_path}\''

                #print(log_path)
                #print(f'GREP: {grep_command}')

                try:
                    output_bytes = subprocess.check_output(grep_command, shell=True)
                    output = output_bytes.decode('utf-8')

                    #print(f'OUTPUT: {output}')

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

                csv_writer.writerow([kappa3, kappa4, cross_section, uncertainty])

if __name__ == "__main__":
    main()
