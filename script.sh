cd $WORKDIR/POWHEG-BOX-V2/ggHH

lsetup "views LCG_98python3 x86_64-centos7-gcc8-opt"
make -j5
export LHAPDF_DATA_PATH=/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current:`lhapdf-config --datadir`

cd ../..
cd ggHH-kappa3-kappa4
cp config.yaml "${current_directory}/config_yaml.txt"
cd ..
cd POWHEG-BOX-V2/ggHH

cp -r "testrun" "${current_directory}_kappa3 = ${k3}, kappa4 = ${k4}"
cd "${current_directory}_kappa3 = ${k3}, kappa4 = ${k4}"

sed -i "s/7000d0/${energy}d0/g" powheg.input-save

sed -i "s/ch4       1.0/ch4       ${k4}/" powheg.input-save
sed -i "s/chhh      1.0/chhh      ${k3}/" powheg.input-save

./run.sh ${run_arg}

mkdir "$WORKDIR/ggHH-kappa3-kappa4/${current_directory}/kappa3 = ${k3}, kappa4 = ${k4}"

find . -maxdepth 1 -type f -name "run-2*.log" -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2- | xargs -I {} cp {} "$WORKDIR/ggHH-kappa3-kappa4/${current_directory}/kappa3 = ${k3}, kappa4 = ${k4}"

cd ..
ln -s "$PWD/${current_directory}_kappa3 = ${k3}, kappa4 = ${k4}" "$WORKDIR/ggHH-kappa3-kappa4/${current_directory}/kappa3 = ${k3}, kappa4 = ${k4}"
