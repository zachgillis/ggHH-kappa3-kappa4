# POWHEG-BOX analysis of gg→hh cross-sections

## Instructions for sweeping values of kappa3 

Before running, modify the ``run.sh`` file to specify whether to use the ``run_template`` directory (for LO calculations) or ``run_template_nlo`` directory (for NLO calculations). Then, run ``./job_submit.sh <start_value> <end_value> <number_of_points>` <sweep_directory_name>``. (If you'd like to define the kappa3 instances to be run, list the values on their own lines in an ``instances.txt`` file. Then, run ``./job_submit.sh``.)

Once the jobs have finished running, run ``./extract_data.py``. This will create a ``results.csv`` file within the most recently modified directory. To extract the data from another directory, run ``./extract_data.py <directory_name>``. 

Use ``generate_plots.ipynb`` to generate the plots and fit the results to quadratic polynomials (LATEX must be installed, specify file paths of ``results.csv`` files to include)

Graphs and sweep directories are included in the repository (``powheg.input`` files can be found in the individual child run directories). 
