# Sample Images for CUDA Image Processing

This directory contains input and output images for testing the CUDA image processing project.

## Input Images

### Option 1: Automatic Generation
The `run.sh` script will automatically create a sample image if `input.png` doesn't exist:
```bash
./run.sh  # Creates sample gradient image if needed
```

### Option 2: Manual Creation with ImageMagick
```bash
# Install ImageMagick
sudo apt install imagemagick

# Create test patterns
convert -size 512x512 gradient:red-blue data/input.png
convert -size 512x512 plasma: data/input_plasma.png
convert -size 512x512 rose: data/input_rose.png
```

### Option 3: Use Your Own Images
```bash
# Copy any image to use as input
cp /path/to/your/image.jpg data/input.png

# Or specify custom paths
./run.sh /path/to/custom/input.jpg /path/to/custom/output.png
```

### Option 4: Download Sample Images
```bash
# Download a sample image from the internet
wget -O data/input.png "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Vd-Orig.png/256px-Vd-Orig.png"

# Or use curl
curl -o data/input.png "https://picsum.photos/512/512"
```

## File Formats Supported

**Input formats**: JPEG, PNG, BMP, TIFF, and other OpenCV-supported formats  
**Output format**: PNG (grayscale)

## Expected Results

After running the project:
- `input.png`: Original color/grayscale image
- `output.png`: Processed image (grayscale → blur → sharpen)
- Processing should show significant GPU speedup vs CPU

## Image Size Recommendations

- **Small (256x256)**: Quick testing and debugging
- **Medium (512x512)**: Good balance of performance demonstration  
- **Large (1024x1024+)**: Best GPU speedup demonstration

Larger images will show more dramatic GPU performance benefits due to increased parallel workload. 