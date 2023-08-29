#!/bin/bash

./clean.py



CONFIG_FILE="config.json"
directory_name=$(jq -r '.directory_name' "$CONFIG_FILE")
auto_generate_sweep=$(jq -r '.auto_generate_sweep' "$CONFIG_FILE")
kappa3_start=$(jq -r '.kappa3_start' "$CONFIG_FILE")
kappa3_end=$(jq -r '.kappa3_end' "$CONFIG_FILE")
kappa3_points=$(jq -r '.kappa3_points' "$CONFIG_FILE")
kappa4_start=$(jq -r '.kappa4_start' "$CONFIG_FILE")
kappa4_end=$(jq -r '.kappa4_end' "$CONFIG_FILE")
kappa4_points=$(jq -r '.kappa4_points' "$CONFIG_FILE")
nlo=$(jq -r '.nlo' "$CONFIG_FILE")
fixedscale=$(jq -r '.fixedscale' "$CONFIG_FILE")

echo 'test'

dir_name=$(python3 - <<END

import os
import sys

print($nlo)

if bool($nlo):
    write_dir = '/run_template_nlo'
else:
    write_dir = '/run_template'

def create_unique_directory(base_dir):
    if not os.path.exists(base_dir):
        os.makedirs(base_dir)
        return base_dir
    else:
        count = 2
        while os.path.exists(f"{base_dir}_run{count}"):
            count += 1
        os.makedirs(f"{base_dir}_run{count}")
        return f"{base_dir}_run{count}"

def generate_instances(kappa3_start, kappa3_end, kappa3_points, kappa4_start, kappa4_end, kappa4_points):
    
    def convert_zero(number):
        if number == 0:
            return 0.001
        else:
            return number
    
    instances = []

    kappa3_step = (kappa3_end - kappa3_start) / (kappa3_points - 1)
    kappa4_step = (kappa4_end - kappa4_start) / (kappa4_points - 1)

    for i in range(kappa3_points):
        kappa3_value = kappa3_start + i * kappa3_step
        for j in range(kappa4_points):
            kappa4_value = kappa4_start + j * kappa4_step
            instances.append(f'{round(convert_zero(kappa3_value),3)} {round(convert_zero(kappa4_value),3)}')
        instances.append(f'{round(convert_zero(kappa3_value),3)} {1.0}')

    for j in range(kappa4_points):
        kappa4_value = kappa4_start + j * kappa4_step
        instances.append(f'{1.0} {round(convert_zero(kappa4_value),3)}')

    instances.append(f'{1.0} {1.0}')

    return instances

def convert_to_m_format(numbers_string):
    numbers = numbers_string.split()
    converted_numbers = []

    for num in numbers:
        if num.startswith('-'):
            converted_numbers.append('m' + num[1:])
        else:
            converted_numbers.append(num)
    
    return ' '.join(converted_numbers)

def write_to_file_alt(filename, instances):
    with open(filename, 'w') as file:
        for instance in instances:
            file.write(f'{convert_to_m_format(instance)} {dir_name} {write_dir}\n')

def write_to_file(filename, instances):
    with open(filename, 'w') as file:
        for instance in instances:
            file.write(f'{instance}\n')

if bool(auto_generate_sweep):
    kappa3_start = float("$kappa3_start")
    kappa3_end = float("$kappa3_end")
    kappa3_points = int("$kappa3_points")
    kappa4_start = float("$kappa4_start")
    kappa4_end = float("$kappa4_end")
    kappa4_points = int("$kappa4_points")

    dir_name = create_unique_directory("$directory_name")
    print(dir_name)
    os.makedirs(dir_name)

    instances = generate_instances(kappa3_start, kappa3_end, kappa3_points, kappa4_start, kappa4_end, kappa4_points)

    write_to_file_alt('alt_instances.txt', instances)
    write_to_file('instances.txt', instances)

else:
    file_path = 'instances.txt'

    dir_name = create_unique_directory("$directory_name")
    print(dir_name)

    with open('instances.txt', 'r') as initial_file, open('alt_instances.txt', 'w') as altered_file:
        for line in initial_file:
            stripped_line = line.strip() 
            altered_line = f"{stripped_line} {dir_name} {write_dir}\n"
            altered_file.write(altered_line)



END
)

#condor_submit job.sub

#watch condor_q
