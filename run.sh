#!/usr/bin/bash

export SCRATCHDIR=$pwd

export k3=$2
export k4=$3
export energy=$4
export current_directory=$5
export run_arg=$6

export ALRB_CONT_RUNPAYLOAD="source script.sh ${k3} ${k4} ${energy} ${current_directory} ${run_arg}"
export ALRB_CONT_CMDOPTS=" --pwd=`pwd`"
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source "${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh"

svn checkout --username anonymous --password anonymous svn://powhegbox.mib.infn.it/trunk/POWHEG-BOX-V2
cd POWHEG-BOX-V2
mkdir ggHH
git clone -b v1.0.0 git@github.com:philippwindischhofer/POWHEG_ggHH_cH4.git ./ggHH

cd ..
setupATLAS -c centos7
exit $?
