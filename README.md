# CUDA Image Processing Project

A high-performance image processing application that applies grayscale conversion, Gaussian blur, and sharpening filters using CUDA GPU acceleration. This project demonstrates parallel computing techniques with custom CUDA kernels for real-time image processing using synthetic test data.

## 🎯 Project Overview

This project processes synthetic images through a sequential pipeline of image enhancement operations:
1. **Synthetic Image Generation** - Create test patterns with gradients and wave functions
2. **Grayscale Conversion** - Process single-channel data through GPU pipeline
3. **Gaussian Blur** - Apply 3x3 Gaussian smoothing filter  
4. **Sharpening Filter** - Enhance image details using convolution kernel

### Key Features
- ✅ **CUDA GPU Acceleration** - Custom CUDA kernels for parallel processing
- ✅ **Self-Contained** - No external dependencies (no OpenCV required)
- ✅ **Multi-stage Pipeline** - Sequential grayscale → blur → sharpen processing
- ✅ **Performance Comparison** - CPU vs GPU timing analysis
- ✅ **Synthetic Data Generation** - Built-in test image creation
- ✅ **Memory Management** - Proper CUDA memory allocation and cleanup

## 🚀 GPU Acceleration Details

### CUDA Implementation
The project leverages NVIDIA CUDA for massively parallel image processing:

1. **Parallel Processing Model**:
   - Each GPU thread processes one pixel independently
   - 16x16 thread blocks for optimal GPU utilization
   - Grid-stride loops handle arbitrary image sizes

2. **Memory Management**:
   - `cudaMalloc()`: Allocate GPU memory for input/intermediate/output buffers
   - `cudaMemcpy()`: Transfer data between CPU and GPU efficiently  
   - `cudaFree()`: Clean up GPU memory resources

3. **CUDA Kernels**:
   - **Grayscale Kernel**: Identity operation (input already converted by OpenCV)
   - **Gaussian Blur Kernel**: 3x3 convolution with normalized weights
   - **Sharpening Kernel**: Edge enhancement using Laplacian-like filter

### Performance Benefits
- **Massive Parallelism**: Thousands of pixels processed simultaneously
- **High Memory Bandwidth**: GPU's superior memory throughput
- **Scalability**: Performance improves with larger image sizes
- **Typical Speedup**: 10-50x faster than CPU implementation

## 🛠️ Prerequisites

### System Requirements
- **Operating System**: Linux, WSL2, or compatible UNIX environment
- **GPU**: NVIDIA GPU with CUDA support (Compute Capability 3.0+)
- **CUDA Toolkit**: Version 10.0 or later
- **Compiler**: GCC or compatible C++ compiler

### Dependencies
```bash
# Verify CUDA installation
nvcc --version
nvidia-smi

# No additional dependencies required - completely self-contained!
```

## 📦 Installation & Setup

### Quick Start
```bash
# Clone or extract the project
cd cuda-image-processing

# Build the project (no external dependencies needed!)
make all

# Run with synthetic test data
./run.sh

# Or run with custom image size
./run.sh 1024 1024
```

### Manual Build
```bash
# Create build directory
mkdir -p build

# Compile CUDA source files  
nvcc -std=c++11 -O3 -arch=sm_89 -c src/main.cu -o build/main.o
nvcc -std=c++11 -O3 -arch=sm_89 -c src/grayscale.cu -o build/grayscale.o

# Link executable
nvcc build/main.o build/grayscale.o -o build/cuda_grayscale -lcudart
```

### CUDA Architecture Notes
The Makefile uses `sm_89` for L4 GPUs. Adjust `COMPUTE_CAP` in Makefile for your GPU:
- **L4 GPUs**: `sm_89`
- **RTX 30/40 series**: `sm_86` 
- **RTX 20 series**: `sm_75`
- **GTX 10 series**: `sm_61`

## 🎮 Usage

### Command Line Interface
```bash
# Basic usage with default 512x512 image
./build/cuda_grayscale

# Custom image size
./build/cuda_grayscale 1024 1024

# Using the run script (recommended)
./run.sh [width] [height]

# Examples
./run.sh                           # Use default 512x512 synthetic image
./run.sh 1024 1024                 # Generate and process 1024x1024 image
```

### Output Formats
- **Format**: PGM (Portable GrayMap) - simple, uncompressed grayscale format
- **Viewable with**: GIMP, ImageJ, online PGM viewers
- **Convert to PNG**: `mogrify -format png data/*.pgm` (requires ImageMagick)

## 📊 Performance Analysis

### Timing Output Example
```
=== GPU Processing ===
Launching grayscale kernel with grid (32, 32) and block (16, 16)
Launching Gaussian blur kernel with grid (32, 32) and block (16, 16)  
Launching sharpen kernel with grid (32, 32) and block (16, 16)
CUDA kernel execution completed
GPU processing completed in 1847 microseconds

=== CPU Processing ===
CPU processing completed in 23691 microseconds

=== Performance Comparison ===
GPU Time: 1847 μs
CPU Time: 23691 μs  
Speedup: 12.83x
```

### Performance Factors
- **Image Size**: Larger images show greater GPU benefits
- **GPU Model**: More CUDA cores = better performance
- **Memory Bandwidth**: GPU memory throughput advantage
- **Thread Utilization**: 16x16 blocks optimize warp efficiency

## 📁 Project Structure

```
cuda-image-processing/
├── src/
│   ├── main.cu          # Main application with OpenCV I/O
│   └── grayscale.cu     # CUDA kernels and CPU baseline
├── data/
│   ├── input.png        # Sample input image
│   └── output.png       # Generated output image  
├── build/               # Compiled binaries
├── Makefile             # Build configuration
├── run.sh               # Automated build and run script
├── README.md            # This documentation
└── execution_log.txt    # Program output and timing results
```

## 🧪 Testing & Verification

### Run Tests
```bash
# Build and run with default sample
make run

# Run performance tests with multiple image sizes
make test

# Check CUDA installation
make check-cuda

# Clean build artifacts
make clean
```

### Verify Results
- Check `data/*.pgm` files for processed images at each stage
- Review `execution_log.txt` for performance metrics
- Compare processing times for different image sizes

## 🎥 Demo Presentation Instructions

For a 5-10 minute demonstration video:

### 1. Setup Overview (1-2 minutes)
- Show project directory structure
- Demonstrate CUDA installation: `nvcc --version`, `nvidia-smi`
- Verify OpenCV: `pkg-config --modversion opencv4`

### 2. Build Process (1-2 minutes)
- Run `make clean && make all`
- Explain CUDA compilation flags and architecture targeting
- Show successful executable creation

### 3. Execution Demo (2-3 minutes)
- Run `./run.sh` with sample input image
- Display command line output with timing information
- Show before/after images side-by-side

### 4. Performance Analysis (2-3 minutes)
- Explain GPU vs CPU timing comparison
- Discuss speedup factors and parallel processing benefits
- Review `execution_log.txt` contents

### 5. Code Walkthrough (1-2 minutes)
- Highlight CUDA kernel implementations in `src/grayscale.cu`
- Explain memory management (`cudaMalloc`, `cudaMemcpy`, `cudaFree`)
- Show grid/block configuration for optimal GPU utilization

### Sample Recording Commands
```bash
# Record demo session
script -a demo_session.txt

# Show system info
nvcc --version
nvidia-smi
pkg-config --modversion opencv4

# Build and run
make clean && make all
./run.sh

# Show results
cat execution_log.txt
ls -la data/

# Exit recording
exit
```

## 🔧 Troubleshooting

### Common Issues

**CUDA Compiler Not Found**
```bash
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

**Build Errors**
```bash
# Ensure CUDA toolkit is properly installed
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Check compiler compatibility
nvcc --version
gcc --version
```

**GPU Architecture Mismatch**
```bash
# Check your GPU compute capability
nvidia-smi --query-gpu=compute_cap --format=csv

# Update COMPUTE_CAP in Makefile accordingly
```

## 📝 Implementation Details

### Code Quality Features
- **Error Handling**: Comprehensive CUDA error checking with `checkCudaError()`
- **Memory Safety**: Proper allocation/deallocation patterns
- **Modularity**: Separate compilation units for different functionality
- **Performance**: Optimized grid/block dimensions and memory access

### Educational Value
This project demonstrates:
- CUDA programming fundamentals and parallel algorithm design
- GPU memory management and optimization techniques  
- Performance comparison methodologies
- Image processing concepts and convolution operations

## 📄 License

This project is provided for educational purposes. Free to use and modify for learning CUDA programming and parallel computing concepts.

---

**Author**: CUDA Image Processing Demo  
**Course**: Parallel Computing / GPU Programming  
**Last Updated**: 2024 