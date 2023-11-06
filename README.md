# POWHEG-BOX analysis of gg→hh cross-sections

## Instructions

Clone this directory into a directory that contains ``POWHEG-BOX-V2``. I called my parent directory ``PWHG-5``.

Modify ``config.yaml`` file to set preferences for the sweep. 

Then, run ``./sweep2d.py``.

When it has finished running in Condor, run ``./extract_data.py``. This will create a ``results.csv`` file within the run directory. 

Note: The version 3 branch is for the new ggHH implementation used for the results in https://arxiv.org/pdf/1903.08137.pdf. Initialize using the following commands: 

``svn checkout --username anonymous --password anonymous svn://powhegbox.mib.infn.it/trunk/POWHEG-BOX-V2``

``cd POWHEG-BOX-V2``

``svn checkout --username anonymous --password anonymous svn://powhegbox.mib.infn.it/trunk/User-Processes-V2/ggHH``
