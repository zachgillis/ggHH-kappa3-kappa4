#!/usr/bin/bash

export WORKDIR=/home/zachgillis/test110424_06

export ALRB_CONT_RUNPAYLOAD="cd ..; cd ..; cd $WORKDIR/ggHH-kappa3-kappa4; source script.sh"
export ALRB_CONT_PRESETUP="export WORKDIR=${WORKDIR}; export k3=${k3}; export k4=${k4}; export energy=${energy}; export current_directory=${current_directory}; export run_arg=${run_arg}"
export ALRB_CONT_CMDOPTS=" --pwd=$WORKDIR/POWHEG-BOX-V2/ggHH -B $WORKDIR:$WORKDIR"
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source "${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh"

export k3=$1
export k4=$2
export energy=$3
export current_directory=$4
export run_arg=$5

cd $WORKDIR/POWHEG-BOX-V2/ggHH
setupATLAS -c centos7
exit $?
