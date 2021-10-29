#include <stdio.h>

#define TILE_SIZE 16

__global__ void mysgemm(int m, int n, int k, const float *A, const float *B, float* C) {

    /********************************************************************
     *
     * Compute C = A x B
     *   where A is a (m x k) matrix
     *   where B is a (k x n) matrix
     *   where C is a (m x n) matrix
     *
     * Use shared memory for tiling
     *
     ********************************************************************/

    /*************************************************************************/
    // INSERT KERNEL CODE HERE
    //declare shared memory/thread ints
    __shared__ float ds_M[TILE_SIZE][TILE_SIZE];
    __shared__ float ds_N[TILE_SIZE][TILE_SIZE];


    //declare matrix index vars
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int bx = blockIdx.x;
    int by = blockIdx.y;

    ///define row/col
    int Row = by * blockDim.y + ty;
    int Col = bx * blockDim.x + tx;

    
    // load data from A,B into shared mem + boundary checking & zero padding
    for(int p = 0; p < (k-1)/TILE_SIZE-1;p++)
    {
    	if(Row < m && (p * TILE_SIZE + tx < k)) //load M - within boundary;  note: (a = m x k)
	{
	    ds_M[ty][tx] = A[Row * k + p * TILE_SIZE + tx];
	}
	else // pad 0
	{
	   ds_M[ty][tx] = 0.0;
	}
	if((p*TILE_SIZE + ty < k) && Col < n) // load N - within boundary; note: (b = k x n)
	{
	   ds_N[ty][tx] = B[(p*TILE_SIZE + ty) * k + Col];
	}
	else // pad 0
	{
	    ds_N[ty][tx] = 0.0;
	}
		
    }

    //perform computation (inner product) into p variable

    //sync 
    // loop to load p variable into C    
    /*************************************************************************/
}

void basicSgemm(int m, int n, int k, const float *A, const float *B, float *C)
{
    // Initialize thread block and kernel grid dimensions ---------------------

    const unsigned int BLOCK_SIZE = TILE_SIZE;
	
    /*************************************************************************/
    //INSERT CODE HERE

    /*************************************************************************/

    // Invoke CUDA kernel -----------------------------------------------------

    /*************************************************************************/
    //INSERT CODE HERE
	
    /*************************************************************************/
}


