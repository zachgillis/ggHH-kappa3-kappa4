# POWHEG-BOX analysis of gg→hh cross-sections

## Instructions

1. Create a working directory.

2. Clone this repository into your working directory (i.e., run the following).

```
cd $WORKDIR
git clone https://github.com/zachgillis/ggHH-kappa3-kappa4.git
```
> To use your own working directory, change the ``WORKDIR`` variable above. Also, change the working directory within the ``job.sub`` (executable line), and ``clean.py`` files.
2. Modify ``config.yaml`` file within the ``ggHH-kappa3-kappa4`` repository to set preferences for the sweep. 

3. Run ``./sweep2d.py``.

4. When it has finished running in Condor, move run output directories ``<directory_name>_kappa3_*.*_kappa4_*.*`` into the empty run directory ``<directory_name>`` and run ``./extract_data.py <directory_name>``, where ``<directory_name>`` is the name specified in the ``config.yaml`` file. This will create a ``results.csv`` file within the run directory. 
