# CUDA Image Processing Makefile

# Compiler and tools
NVCC = nvcc
CXX = g++

# Project directories
SRC_DIR = src
BUILD_DIR = build
DATA_DIR = data

# Target executable
TARGET = $(BUILD_DIR)/cuda_grayscale

# Source files
CUDA_SOURCES = $(SRC_DIR)/main.cu $(SRC_DIR)/grayscale.cu
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/grayscale.o

# Compiler flags
NVCC_FLAGS = -std=c++11 -O3 -Xcompiler -fPIC

# CUDA compute capability (adjust based on your GPU)
# L4 GPUs: sm_89, RTX 30/40 series: sm_86, RTX 20 series: sm_75
COMPUTE_CAP = sm_89

# Include and library directories
INCLUDE_DIRS = -I/usr/local/cuda/include
LIB_DIRS = -L/usr/local/cuda/lib64
LIBS = -lcudart

# Default target
all: $(TARGET)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Create data directory
$(DATA_DIR):
	mkdir -p $(DATA_DIR)

# Build main executable
$(TARGET): $(OBJECTS) | $(BUILD_DIR) $(DATA_DIR)
	$(NVCC) $(NVCC_FLAGS) -arch=$(COMPUTE_CAP) $(OBJECTS) -o $@ $(LIB_DIRS) $(LIBS)
	@echo "Build completed successfully!"
	@echo "Executable created: $(TARGET)"

# Compile CUDA source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cu | $(BUILD_DIR)
	$(NVCC) $(NVCC_FLAGS) -arch=$(COMPUTE_CAP) $(INCLUDE_DIRS) -c $< -o $@

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(DATA_DIR)/*.pgm
	@echo "Clean completed"

# Run the program with default settings
run: $(TARGET)
	@echo "Running CUDA image processing with synthetic data..."
	./$(TARGET)

# Run with custom image size
run-large: $(TARGET)
	@echo "Running CUDA image processing with large image (1024x1024)..."
	./$(TARGET) 1024 1024

# Check CUDA installation
check-cuda:
	@echo "Checking CUDA installation..."
	@nvcc --version || echo "CUDA not found in PATH"
	@nvidia-smi || echo "NVIDIA driver not found"

# Performance test with multiple sizes
test: $(TARGET)
	@echo "Running performance tests with multiple image sizes..."
	@echo "=== 256x256 test ==="
	./$(TARGET) 256 256
	@echo ""
	@echo "=== 512x512 test ==="
	./$(TARGET) 512 512
	@echo ""
	@echo "=== 1024x1024 test ==="
	./$(TARGET) 1024 1024

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Build the project (default)"
	@echo "  clean        - Remove build artifacts and output images"
	@echo "  run          - Build and run with default 512x512 image"
	@echo "  run-large    - Build and run with 1024x1024 image"
	@echo "  test         - Run performance tests with multiple image sizes"
	@echo "  check-cuda   - Check CUDA installation"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Usage: ./$(TARGET) [width] [height]"
	@echo "Example: ./$(TARGET) 1024 1024"

.PHONY: all clean run run-large test check-cuda help 