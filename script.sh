export k3=$1
export k4=$2
export energy=$3
export current_directory=$4
export run_arg=$5

cd POWHEG-BOX-V2/ggHH

lsetup "views LCG_98python3 x86_64-centos7-gcc8-opt"
make -j5
export LHAPDF_DATA_PATH=/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current:`lhapdf-config --datadir`

cp -r "testrun" "${current_directory}_kappa3_${k3}_kappa4_${k4}"
cd "${current_directory}_kappa3_${k3}_kappa4_${k4}"

sed -i "s/7000d0/${energy}d0/g" powheg.input-save

sed -i "s/ch4       1.0/ch4       ${k4}/" powheg.input-save
sed -i "s/chhh      1.0/chhh      ${k3}/" powheg.input-save

./run.sh ${run_arg}
