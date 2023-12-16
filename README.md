# POWHEG-BOX analysis of gg→hh cross-sections

## Instructions

1. Create a working directory. Within this working directory, download the POWHEG-BOX-V2 and ggHH packages. To do so, run the following:
  ```
  export WORKDIR=/home/zachgillis/PWHG-7 # change to your working directory

  mkdir $WORKDIR
  cd $WORKDIR
  svn checkout --username anonymous --password anonymous svn://powhegbox.mib.infn.it/trunk/POWHEG-BOX-V2
  cd POWHEG-BOX-V2
  mkdir ggHH
  git clone -b v1.0.0 git@github.com:philippwindischhofer/POWHEG_ggHH_cH4.git ./ggHH
  ```
  > To use your own working directory, change the ``WORKDIR`` variable above. Also, change the working directory within the ``run.sh``, ``job.sub``, and ``clean.py`` files. 

2. Clone this repository into your working directory. Run the following:

```
cd $WORKDIR
git clone https://github.com/zachgillis/ggHH-kappa3-kappa4.git
```

2. Modify ``config.yaml`` file within the ``ggHH-kappa3-kappa4`` repository to set preferences for the sweep. 

3. Run ``./sweep2d.py``.

4. When it has finished running in Condor, run ``./extract_data.py <directory_name>``, where ``<directory_name>`` is the name specified in the ``config.yaml`` file. This will create a ``results.csv`` file within the run directory. 

Note: The version 3 branch is for the new ggHH implementation used for the results in https://arxiv.org/pdf/1903.08137. 
