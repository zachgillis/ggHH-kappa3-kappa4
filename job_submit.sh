#!/bin/bash

./clean.py
./clean1.py

start="$1"
end="$2"
points="$3"

dir_name=$(python3 - <<END

import os
import sys

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

def generate_instances(start, end, points):
    step = (end - start) / (points - 1)
    instances = [start + i * step for i in range(points)]
    return instances

def convert_to_m_format(num):
    number = float(num)
    if number < 0:
        return 'm' + str(abs(number))
    else:
        return str(number)

def write_to_file_alt(filename, instances):
    with open(filename, 'w') as file:
        for instance in instances:
            file.write(f'{convert_to_m_format(instance)} {dir_name}\n')

def write_to_file(filename, instances):
    with open(filename, 'w') as file:
        for instance in instances:
            file.write(f'{instance}\n')

args = ["$1", "$2", "$3"]

args = [arg for arg in args if arg]

num_args = len(args)

if num_args == 3:
    start = float("$start")
    end = float("$end")
    points = int("$points")

    dir_name = create_unique_directory(f'start{start}_end{end}_points{points}')
    print(dir_name)

    instances = generate_instances(start, end, points)
    instances = [round(float(instance),3) for instance in instances]
    
    one_in_list = False
    for i in range(len(instances)):
        if instances[i] == 0:
            instances[i] = 0.001
        if instances[i] == 1:
            one_in_list = True

    if not one_in_list:
        instances.append(1.0)

    write_to_file_alt('alt_instances.txt', instances)
    write_to_file('instances.txt', instances)

elif num_args == 0:
    file_path = 'instances.txt'

    with open(file_path, 'r') as file:
        start = float(file.readline().strip())

    with open(file_path, 'r') as file:
        for last_line in file:
            pass
        end = float(last_line.strip())

    with open(file_path, 'r') as file:
        points = int(sum(1 for line in file))

    dir_name = create_unique_directory(f'start{start}_end{end}_points{points}')
    print(dir_name)

    with open('instances.txt', 'r') as initial_file, open('alt_instances.txt', 'w') as altered_file:
        for line in initial_file:
            stripped_line = line.strip() 
            altered_line = f"{stripped_line} {dir_name}\n"
            altered_file.write(altered_line)



else:
    # Invalid number of arguments
    print("Error: Invalid number of arguments")
    sys.exit(1)


END
)

condor_submit job.sub

watch condor_q
