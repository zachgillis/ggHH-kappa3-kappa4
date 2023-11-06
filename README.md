# POWHEG-BOX analysis of gg→hh cross-sections

## Instructions

Clone this directory into a directory that contains ``POWHEG-BOX-V2``. I called my parent directory ``PWHG-5``.

Modify ``config.yaml`` file to set preferences for the sweep. 

Then, run ``./sweep2d.py``.

When it has finished running in Condor, run ``./extract_data.py``. This will create a ``results.csv`` file within the run directory. 
