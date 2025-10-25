#!/bin/bash

# CUDA Image Processing - Run Script (Self-Contained Version)
# This script builds and runs the CUDA image processing project without external dependencies

set -e  # Exit on any error

echo "=== CUDA Image Processing Project ==="
echo "Self-contained GPU-accelerated image processing with synthetic data"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check CUDA installation
echo "[INFO] Checking CUDA installation..."
if command_exists nvcc; then
    echo "[OK] CUDA compiler found:"
    nvcc --version | grep "release"
else
    echo "[ERROR] CUDA compiler (nvcc) not found in PATH"
    echo "Please install CUDA toolkit from: https://developer.nvidia.com/cuda-downloads"
    exit 1
fi

if command_exists nvidia-smi; then
    echo "[OK] NVIDIA driver found:"
    nvidia-smi --query-gpu=name,compute_cap,memory.total --format=csv,noheader,nounits | head -1
else
    echo "[ERROR] NVIDIA driver not found"
    echo "Please install NVIDIA drivers"
    exit 1
fi

# Build the project
echo ""
echo "[INFO] Building CUDA image processing project..."
make clean
make all

if [ ! -f "build/cuda_grayscale" ]; then
    echo "[ERROR] Build failed - executable not created"
    exit 1
fi

echo "[OK] Build completed successfully!"

# Prepare data directory
echo ""
echo "[INFO] Preparing data directory..."
mkdir -p data

# Parse command line arguments for image size
WIDTH=512
HEIGHT=512

if [ $# -ge 1 ]; then
    WIDTH="$1"
fi
if [ $# -ge 2 ]; then
    HEIGHT="$2"
fi

# Validate dimensions
if ! [[ "$WIDTH" =~ ^[0-9]+$ ]] || ! [[ "$HEIGHT" =~ ^[0-9]+$ ]] || [ "$WIDTH" -lt 64 ] || [ "$HEIGHT" -lt 64 ] || [ "$WIDTH" -gt 4096 ] || [ "$HEIGHT" -gt 4096 ]; then
    echo "[WARNING] Invalid image dimensions. Using default 512x512."
    WIDTH=512
    HEIGHT=512
fi

# Run the program
echo ""
echo "[INFO] Running CUDA image processing..."
echo "[INFO] Image size: ${WIDTH}x${HEIGHT}"
echo "[INFO] Processing pipeline: Synthetic Image → Grayscale → Gaussian Blur → Sharpening"
echo ""

# Execute and capture output
./build/cuda_grayscale "$WIDTH" "$HEIGHT" 2>&1 | tee execution_log.txt

# Verify output files
echo ""
echo "[INFO] Verifying output files..."
EXPECTED_FILES=("data/input.pgm" "data/stage1_grayscale.pgm" "data/stage2_blurred.pgm" "data/output_final.pgm" "data/cpu_baseline.pgm")

all_files_exist=true
for file in "${EXPECTED_FILES[@]}"; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || echo "unknown")
        echo "[OK] $file ($size bytes)"
    else
        echo "[ERROR] Missing: $file"
        all_files_exist=false
    fi
done

if [ "$all_files_exist" = true ]; then
    echo ""
    echo "[SUCCESS] All processing stages completed successfully!"
    echo "[INFO] Execution log saved to: execution_log.txt"
    echo ""
    echo "Output files generated:"
    echo "  - data/input.pgm: Original synthetic test image"
    echo "  - data/stage1_grayscale.pgm: After grayscale conversion"
    echo "  - data/stage2_blurred.pgm: After Gaussian blur"
    echo "  - data/output_final.pgm: Final sharpened result"
    echo "  - data/cpu_baseline.pgm: CPU processing comparison"
    echo ""
    echo "View PGM files with: GIMP, ImageJ, or online PGM viewers"
    echo "Convert to PNG: mogrify -format png data/*.pgm (requires ImageMagick)"
else
    echo "[ERROR] Some output files were not created"
    exit 1
fi

echo ""
echo "=== Execution Complete ==="
echo "✓ GPU acceleration demonstrated"
echo "✓ Multi-stage CUDA pipeline successful"
echo "✓ Performance metrics logged"
echo ""
echo "Next steps:"
echo "  - Review execution_log.txt for performance analysis"
echo "  - View output images to see processing effects"
echo "  - Try different image sizes: ./run.sh 1024 1024" 