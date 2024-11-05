#!/usr/bin/bash

export WORKDIR=/home/zachgillis/test110524

export k3=$2
export k4=$3
export energy=$4
export current_directory=$5
export run_arg=$6

export ALRB_CONT_RUNPAYLOAD="cd ..; cd ..; cd $WORKDIR/ggHH-kappa3-kappa4; source script.sh ${k3} ${k4} ${energy} ${current_directory} ${run_arg} ${WORKDIR}"
# export ALRB_CONT_POSTSETUP="export WORKDIR=${WORKDIR}; export k3=${k3}; export k4=${k4}; export energy=${energy}; export current_directory=${current_directory}; export run_arg=${run_arg}"
export ALRB_CONT_CMDOPTS=" --pwd=$WORKDIR/POWHEG-BOX-V2/ggHH -B $WORKDIR:$WORKDIR"
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source "${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh"

cd $WORKDIR/POWHEG-BOX-V2/ggHH
setupATLAS -c centos7
exit $?
