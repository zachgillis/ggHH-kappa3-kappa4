# POWHEG-BOX analysis of gg→hh cross-sections

## Instructions

Modify ``config.yaml`` file to set preferences for the sweep. 

Then, run ``./sweep2d.py``.

When it has finished running in Condor, run ``./extract_data.py``. This will create a ``results.csv`` file within the run directory. 

(Note: To define your own values of kappa3 and kappa4 to be run, set ``auto_generate_sweep`` to be false. Create a file ``instances.txt``, and with each run on its own line, enter the values of kappa3 and kappa4 separated by a space.)
