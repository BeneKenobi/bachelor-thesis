#!/bin/bash
#
# Script for analyzing DNA samples (analyze from megSAP on singularity container), Winfried Hofmann, Department of Human Genetics, 7/2019
#
PWD=$(which pwd)
MKDIR=$(which mkdir)
DATE=$(date "+%Y-%m-%d_%s")
#
# working directory within the container
WDIR=$($PWD)
WDIR_SINGULARITY=$(echo "$WDIR" | sed  's!/mnt/hgenet!!g')
WDIR_SLURM=/mnt/hgenet/NGS_Daten_nfs/slurm
#
cd $WDIR
SAMPLEDIRARRAY=$(ls | grep Sample_)
NTASKS=$(echo ${#SAMPLEDIRARRAY[@]})
#
# subdirectory with the current date is created when not existent
if [ ! -d "$WDIR_SLURM/$DATE" ]; then
    $MKDIR "$WDIR_SLURM/$DATE";
fi
#
# for each sample, a bash file is created
for SAMPLEDIR in ${SAMPLEDIRARRAY[*]};do
SAMPLEID=$(echo "$SAMPLEDIR" | sed -e  's/.*Sample_//g')
echo "$SAMPLEID"
echo "#!/bin/bash
#SBATCH -J $SAMPLEID
#SBATCH -p lowprio
#SBATCH --exclude=hpc-rc12,hpc-rc13,hpc-bc15-[01,03,06,14]
#SBATCH --no-kill
#SBATCH --cpus-per-task=12
#SBATCH --mem=50G
#SBATCH --time=2-00:00:00
#SBATCH --chdir=$WDIR_SLURM/$DATE
#SBATCH --error=$WDIR_SLURM/$DATE/$SAMPLEID.error.log
#SBATCH --output=$WDIR_SLURM/$DATE/$SAMPLEID.log
#SBATCH --exclude=hpc[05,06],hpc-rc[12,13]
singularity exec -B /mnt/hgenet/NGS_Daten_nfs/singularity_etc/resolv.conf:/etc/resolv.conf,/mnt/hgenet/NGS_Daten_nfs/singularity_etc/hosts:/etc/hosts,/mnt/hgenet/NGS_tmp:/tmp,/mnt/hgenet/NGS_Daten_nfs:/NGS_Daten_nfs,/mnt/hgenet/NGS_Daten4:/NGS_Daten4,/mnt/hgenet/NGS_Daten_Test:/NGS_Daten_Test /mnt/hgenet/NGS_Daten_Test/User/hofmannw/singularity/test/megSAP-2022_08-64.sif php /megSAP/src/Pipelines/analyze.php -folder $WDIR_SINGULARITY/$SAMPLEDIR -name $SAMPLEID -use_dragen -no_abra -system /NGS_Daten_Test/Manifest/NGSD/IDTPanelV2_GRCh38.tsv -threads 12" > "$WDIR_SLURM/$DATE/$SAMPLEID.sh"
sbatch "$WDIR_SLURM/$DATE/$SAMPLEID.sh"
done
