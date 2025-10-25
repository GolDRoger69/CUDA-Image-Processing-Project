#include <cuda_runtime.h>
#include <stdio.h>

// CUDA kernel for grayscale conversion (identity operation for already gray images)
__global__ void grayscaleKernel(unsigned char* input, unsigned char* output, 
                                int width, int height) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;
    
    if (idx < width && idy < height) {
        int index = idy * width + idx;
        output[index] = input[index]; // Already grayscale
    }
}

// CUDA kernel for Gaussian blur (3x3 kernel)
__global__ void gaussianBlurKernel(unsigned char* input, unsigned char* output, 
                                   int width, int height) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;
    
    if (idx > 0 && idx < width-1 && idy > 0 && idy < height-1) {
        int index = idy * width + idx;
        
        // 3x3 Gaussian kernel (simplified)
        float result = 0.0625f * input[(idy-1)*width + (idx-1)] +
                      0.125f  * input[(idy-1)*width + idx] +
                      0.0625f * input[(idy-1)*width + (idx+1)] +
                      0.125f  * input[idy*width + (idx-1)] +
                      0.25f   * input[idy*width + idx] +
                      0.125f  * input[idy*width + (idx+1)] +
                      0.0625f * input[(idy+1)*width + (idx-1)] +
                      0.125f  * input[(idy+1)*width + idx] +
                      0.0625f * input[(idy+1)*width + (idx+1)];
        
        output[index] = (unsigned char)result;
    } else if (idx < width && idy < height) {
        // Copy border pixels
        output[idy * width + idx] = input[idy * width + idx];
    }
}

// CUDA kernel for sharpening filter
__global__ void sharpenKernel(unsigned char* input, unsigned char* output, 
                              int width, int height) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;
    
    if (idx > 0 && idx < width-1 && idy > 0 && idy < height-1) {
        int index = idy * width + idx;
        
        // 3x3 sharpening kernel
        float result = 5.0f * input[index]
                     - input[(idy-1)*width + idx]    // top
                     - input[(idy+1)*width + idx]    // bottom  
                     - input[idy*width + (idx-1)]    // left
                     - input[idy*width + (idx+1)];   // right
        
        // Clamp to valid range
        result = fmaxf(0.0f, fminf(255.0f, result));
        output[index] = (unsigned char)result;
    } else if (idx < width && idy < height) {
        // Copy border pixels
        output[idy * width + idx] = input[idy * width + idx];
    }
}

// Host function to launch grayscale kernel
extern "C" void launchGrayscaleKernel(unsigned char* d_input, unsigned char* d_output, 
                                      int width, int height) {
    dim3 blockSize(16, 16);
    dim3 gridSize((width + blockSize.x - 1) / blockSize.x, 
                  (height + blockSize.y - 1) / blockSize.y);
    
    printf("Launching grayscale kernel with grid (%d, %d) and block (%d, %d)\n", 
           gridSize.x, gridSize.y, blockSize.x, blockSize.y);
    
    grayscaleKernel<<<gridSize, blockSize>>>(d_input, d_output, width, height);
    cudaDeviceSynchronize();
}

// Host function to launch Gaussian blur kernel
extern "C" void launchGaussianBlurKernel(unsigned char* d_input, unsigned char* d_output, 
                                         int width, int height) {
    dim3 blockSize(16, 16);
    dim3 gridSize((width + blockSize.x - 1) / blockSize.x, 
                  (height + blockSize.y - 1) / blockSize.y);
    
    printf("Launching Gaussian blur kernel with grid (%d, %d) and block (%d, %d)\n", 
           gridSize.x, gridSize.y, blockSize.x, blockSize.y);
    
    gaussianBlurKernel<<<gridSize, blockSize>>>(d_input, d_output, width, height);
    cudaDeviceSynchronize();
}

// Host function to launch sharpen kernel
extern "C" void launchSharpenKernel(unsigned char* d_input, unsigned char* d_output, 
                                    int width, int height) {
    dim3 blockSize(16, 16);
    dim3 gridSize((width + blockSize.x - 1) / blockSize.x, 
                  (height + blockSize.y - 1) / blockSize.y);
    
    printf("Launching sharpen kernel with grid (%d, %d) and block (%d, %d)\n", 
           gridSize.x, gridSize.y, blockSize.x, blockSize.y);
    
    sharpenKernel<<<gridSize, blockSize>>>(d_input, d_output, width, height);
    cudaDeviceSynchronize();
    
    printf("CUDA kernel execution completed\n");
}

// CPU baseline implementation
extern "C" void cpuGrayscale(unsigned char* input, unsigned char* output, 
                            int width, int height) {
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int index = y * width + x;
            output[index] = input[index]; // Already grayscale
        }
    }
} 