# POWHEG-BOX analysis of gg→hh cross-sections

## For different values of kappa3 

If you'd like to automatically define the kappa3 instances (automatically including 1 and excluding 0), run ``./job_submit.sh <start_value> <end_value> <number_of_points>``. If you'd like to name the sweep directory, run ``./job_submit.sh <start_value> <end_value> <number_of_points> <sweep_directory_name>``. 

If you'd like to define the kappa3 instances to be run, list the values on their own lines in an ``instances.txt`` file. Then, run ``./job_submit.sh``

Before running, modify the ``run.sh`` file to specify whether to use the ``run_template`` directory (for LO calculations) or ``run_template_nlo`` directory (for NLO calculations)

Once the jobs have finished running, run ``./extract_data.py``. This will create a ``results.csv`` file within the most recently modified directory. To extract the data from another directory, run ``./extract_data.py <directory_name>``. 

Use ``generate_plots.ipynb`` to generate the plots and fit the results to quadratic polynomials (LATEX must be installed, specify file paths of ``results.csv`` files to include)

Graphs are included in the directory. 
