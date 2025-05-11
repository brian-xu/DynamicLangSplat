#!/bin/bash
#SBATCH --job-name=dynamic_end_to_end
#SBATCH --output=compile/gaufre.out
#SBATCH --error=compile/gaufre.err
#SBATCH --time=02:00:00               # Adjust as needed
#SBATCH --partition=gpu               # Or the appropriate GPU partition
#SBATCH --gres=gpu:1                  # Request 1 GPU
#SBATCH --mem=24G                     # Adjust memory as needed
#SBATCH --cpus-per-task=4            # Adjust CPU cores as needed


# Load modules
module load cuda/12.1.
module load cudnn/8.7.0.84-11.8-lg2dpd5
module load miniconda3/23.11.0s
source /oscar/runtime/software/external/miniconda3/23.11.0/etc/profile.d/conda.sh

# Activate environment
export DATASET=data/bell_novel_view
export OUTPUT=output/bell_novel_view

conda activate lsplat

echo "Extracting features"
python extract_features.py -s $DATASET -r 2

echo "Training autoencoder"
cd autoencoder
python train.py --dataset_path ../$DATASET -r 2
python test.py --dataset_path ../$DATASET -r 2

echo "Running DINO PCA"
cd ..
python dino_pca.py -s $DATASET -r 2

echo "Running Gaufre"
bash scripts/trainval_real.sh $DATASET $OUTPUT



# notes
# need to put instruction to install this

# pip install open_clip_torch
# pip install einops



