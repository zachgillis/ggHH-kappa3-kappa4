#!/usr/bin/bash

cd ~

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
setupATLAS
lsetup "views LCG_98 x86_64-centos7-gcc8-opt"
cd POWHEG-BOX-V2/ggHH-clean-kappa3kappa4
make pwhg_main -j5
export LHAPDF_DATA_PATH=/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current:`lhapdf-config --datadir`

it=$1

iteration=$(python - <<END
import re

def convert_m_to_negative(input_string):
    def replace_m(match):
        number = float(match.group(1))
        return str(-1 * number)
    
    pattern = r'm(\d+(\.\d+)?)'
    result = re.sub(pattern, replace_m, input_string)
    return result

print(convert_m_to_negative(str('$it')))
END
)

#Choose directory to produce output files in. Make the directory before running. 
current_directory=$2

cd "${current_directory}"

cp ../run.sh run_sh_log.txt

cp -r ../run_template_nlo "run${iteration}"
cd "run${iteration}"

sed -i 's/cH4 -100d0/cH4 0d0/' powheg.input
sed -i "s/cHHH 1d0/cHHH ${iteration}/" powheg.input

../../pwhg_main | tee out.log

