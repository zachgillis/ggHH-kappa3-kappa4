#!/usr/bin/env python3

import subprocess
import yaml
import os
import sys

with open('config.yaml', 'r') as yaml_file:
    attributes = yaml.safe_load(yaml_file)

directory_name = attributes['directory_name']
auto_generate_sweep = attributes['auto_generate_sweep']
kappa3_start = attributes['kappa3_start']
kappa3_end = attributes['kappa3_end']
kappa3_points = attributes['kappa3_points']
kappa4_start = attributes['kappa4_start']
kappa4_end = attributes['kappa4_end']
kappa4_points = attributes['kappa4_points']
energy = attributes['energy']
nlo = attributes['nlo']
fixedscale = attributes['fixedscale']

kappa3_start = float(kappa3_start)
kappa3_end = float(kappa3_end)
kappa3_points = int(kappa3_points)
kappa4_start = float(kappa4_start)
kappa4_end = float(kappa4_end)
kappa4_points = int(kappa4_points)
energy = int(energy)

subprocess.run(['./clean.py'], shell=True)

if bool(nlo):
    nlo_num = 3
else:
    nlo_num = 1

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

    kappa3_step = (kappa3_end - kappa3_start) / max((kappa3_points - 1), 1)
    kappa4_step = (kappa4_end - kappa4_start) / max((kappa4_points - 1), 1)

    kappa3_list = []
    kappa4_list = []

    for i in range(kappa3_points):
        kappa3_value = kappa3_start + i * kappa3_step
        kappa3_value = convert_zero(kappa3_value)
        kappa3_list.append(kappa3_value)
    
    for j in range(kappa4_points):
        kappa4_value = kappa4_start + j * kappa4_step
        kappa4_list.append(kappa4_value)

    kappa4_list.append(0.0)
    kappa4_list.append(1.0)
    kappa3_list.append(1.0)

    kappa3_list = list(set(kappa3_list))
    kappa4_list = list(set(kappa4_list))


    for kappa3 in kappa3_list:
        for kappa4 in kappa4_list:
            instances.append(f'{round(kappa3,3)} {round((kappa4),3)} {energy}')

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
            file.write(f'{convert_to_m_format(instance)} {dir_name} {nlo_num}\n')

def write_to_file(filename, instances):
    with open(filename, 'w') as file:
        for instance in instances:
            file.write(f'{instance}\n')

if bool(auto_generate_sweep):
    dir_name = create_unique_directory(directory_name)
    print(dir_name)

    instances = generate_instances(kappa3_start, kappa3_end, kappa3_points, kappa4_start, kappa4_end, kappa4_points)

    write_to_file_alt('alt_instances.txt', instances)
    write_to_file('instances.txt', instances)

else:
    file_path = 'instances.txt'

    dir_name = create_unique_directory(directory_name)
    print(dir_name)

    with open('instances.txt', 'r') as initial_file, open('alt_instances.txt', 'w') as altered_file:
        for line in initial_file:
            stripped_line = line.strip() 
            altered_line = f"{stripped_line} {dir_name} {nlo_num}\n"
            altered_file.write(altered_line)

subprocess.run('condor_submit job.sub', shell=True)

subprocess.run('watch condor_q', shell=True)
