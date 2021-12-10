# Strassen MM VS Cuda Matrix Mulitply

Comparison of Strassen MM O(n^2.8) vs utilizing shared memory/tiling & multithreading with CUDA on NVIDIA GPU

## System Requirements

Cuda Capable nvidia GPU
CUDA toolkit - (available at http://developer.nvidia.com/cuda-downloads)  
Reccomended - perf, nsys(part of cuda tk)  

## Compile/Run

Executable default no arg will pass matrix size 256 x 256   
Otherwise 1 argument n creates nxn matrices. (recommended square & power of 2)  
2 args: m & n gives - mxn & nxm input matrices.  
Default tile size set to 16

```bash
make 
./sgemm-tiled
```

## Revelant Info

![alt text](https://puu.sh/Ivhfs/522eeeadfd.png)  
![alt text](https://puu.sh/IvhfZ/927df7d197.jpg)  
