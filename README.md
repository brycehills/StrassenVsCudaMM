# Strassen MM VS Cuda Matrix Mulitply

Comparison of improve MM time complexity O(n^2.8) vs utilizing shared memory/tiling & multithreading with CUDA on NVIDIA GPU

## System Requirements

Cuda Capable nvidia GPU
CUDA toolkit - (available at http://developer.nvidia.com/cuda-downloads)
Reccomended - perf, nsys(part of cuda tk)

## Compile/Run

Executable default no arg will pass matrix size 256 x 256 
Otherwise 1 argument n creates nxn matrices. (recommended square & power of 2)
2 args: m & n gives - mxn & nxm input matrices. 

```bash
make 
./sgemm-tiled
```
