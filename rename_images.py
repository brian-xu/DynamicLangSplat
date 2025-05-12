import os
import glob
import argparse

def rename_images(folder_path):
    # Get all PNG files in the folder
    png_files = sorted(glob.glob(os.path.join(folder_path, "*.png")))
    
    # Rename each file
    for idx, old_path in enumerate(png_files, start=1):
        # Create new filename with 6-digit number
        new_filename = f"{idx:06d}_left.png.png"
        new_path = os.path.join(folder_path, new_filename)
        
        # Rename the file
        os.rename(old_path, new_path)
        print(f"Renamed: {os.path.basename(old_path)} -> {new_filename}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Rename PNG files in a folder with sequential numbering')
    parser.add_argument('folder_path', type=str, help='Path to the folder containing PNG files')
    args = parser.parse_args()
    
    rename_images(args.folder_path) 