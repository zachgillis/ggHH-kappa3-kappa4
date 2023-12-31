#!/usr/bin/bash

export WORKDIR=/home/zachgillis/PWHG-7

cd ~

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh

current_directory=$4

cd $WORKDIR/POWHEG-BOX-V2/ggHH

setupATLAS
lsetup "views LCG_98python3 x86_64-centos7-gcc8-opt"
make -j5
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

energy=$3

cd ../..
cd ggHH-kappa3-kappa4
cp config.yaml "${current_directory}/config_yaml.txt"
cd ..
cd POWHEG-BOX-V2/ggHH

cp -r "testrun" "${current_directory}_kappa3 = ${kappa3}, kappa4 = ${kappa4}"
cd "${current_directory}_kappa3 = ${kappa3}, kappa4 = ${kappa4}"

sed -i "s/7000d0/${energy}d0/g" powheg.input-save

sed -i "s/ch4       1.0/ch4       ${kappa4}/" powheg.input-save
sed -i "s/chhh      1.0/chhh      ${kappa3}/" powheg.input-save

./run.sh $5

mkdir "$WORKDIR/ggHH-kappa3-kappa4/${current_directory}/kappa3 = ${kappa3}, kappa4 = ${kappa4}"

find . -maxdepth 1 -type f -name "run-2*.log" -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2- | xargs -I {} cp {} "$WORKDIR/ggHH-kappa3-kappa4/${current_directory}/kappa3 = ${kappa3}, kappa4 = ${kappa4}"

cd ..
ln -s "$PWD/${current_directory}_kappa3 = ${kappa3}, kappa4 = ${kappa4}" "$WORKDIR/ggHH-kappa3-kappa4/${current_directory}/kappa3 = ${kappa3}, kappa4 = ${kappa4}"
