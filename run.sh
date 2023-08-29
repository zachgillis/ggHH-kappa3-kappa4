#!/usr/bin/bash

cd ~

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
setupATLAS
lsetup "views LCG_98 x86_64-centos7-gcc8-opt"
cd POWHEG-BOX-V2/ggHH-kappa3kappa4
make pwhg_main -j5
export LHAPDF_DATA_PATH=/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current:`lhapdf-config --datadir`

k3=$1
k4=$2

kappa3=$(python - <<END
import re

def convert_m_to_negative(input_string):
    def replace_m(match):
        number = float(match.group(1))
        return str(-1 * number)
    
    pattern = r'm(\d+(\.\d+)?)'
    result = re.sub(pattern, replace_m, input_string)
    return result

print(convert_m_to_negative(str('$k3')))
END
)

kappa4=$(python - <<END
import re

def convert_m_to_negative(input_string):
    def replace_m(match):
        number = float(match.group(1))
        return str(-1 * number)
    
    pattern = r'm(\d+(\.\d+)?)'
    result = re.sub(pattern, replace_m, input_string)
    return result

print(convert_m_to_negative(str('$k4')))
END
)

current_directory=$3

cd "${current_directory}"

cp ../run.sh run_sh_log.txt
cp ../config.yaml config.yaml

cp -r "..${4}" "kappa3 = ${kappa3}, kappa4 = ${kappa4}"
cd "kappa3 = ${kappa3}, kappa4 = ${kappa4}"

sed -i "s/cH4 -100d0/cH4 ${kappa4}/" powheg.input
sed -i "s/cHHH 1d0/cHHH ${kappa3}/" powheg.input

../../pwhg_main | tee out.log

