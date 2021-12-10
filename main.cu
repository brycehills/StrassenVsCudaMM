#include <stdio.h>
#include<time.h>
#include <stdlib.h>
#include "kernel.cu"
#include "support.h"
#include <omp.h>
#include <iostream>
#include "mm.cpp"

//using namespace std;

int main (int argc, char *argv[])
{
    Timer timer;
    cudaError_t cuda_ret;

    //get size from user -- default is 8x8
    int input_size = 8;
    cout << "Enter Matrix Size (power of 2): ";
    cin >> input_size;
    cout << endl << "Matrix Size = " << input_size << endl;

    //*********************************************************************
    // ~~ final project driver code ~~
    //----------------------------------
    vector<float> im (input_size);
    // allocate vector matrices -- on heap
    vector<vector<float> > a(input_size,im);
    vector<vector<float> > b(input_size,im);
    vector<vector<float> > r(input_size,im);
    vector<vector<float> > r2(input_size,im);
    // populate matrices w random values
    for(int i = 0; i < input_size; i++){
	for(int j = 0; j< input_size; j++){
		a[i][j] = (rand()%100)/100.00;
		b[i][j] = (rand()%100)/100.00;
	}
     }

    //--------------------------------------------------------------------
    //naive mm driver code
    //--------------------------------------------------------------------
    cout << "starting naive mm" << endl;
    clock_t start = clock();
    mm(a,b,r,input_size);
    //PrintMatrix(r,input_size);
    clock_t end = clock();
    double timetaken = double(end - start)/CLOCKS_PER_SEC;
    printf("Time measured: %.3f seconds.\n", timetaken);
    cout << endl << endl;
    //--------------------------------------------------------------------
    // strassen driver code
    //--------------------------------------------------------------------
    cout << "starting stassen mm" << endl;
    // start strass timer
    clock_t start1 = clock();
    Strassen(a,b,r2,input_size);
    clock_t end1 = clock();
    double timetaken_strass = double(end1 - start1)/CLOCKS_PER_SEC;
    printf("Time measured for strassen mm: %.3f seconds.\n", timetaken_strass);
    //PrintMatrix(r2,input_size);
    cout << endl << endl;

    //*********************************************************************

    // Initialize host variables ----------------------------------------------

    printf("\nSetting up the problem..."); fflush(stdout);
    startTime(&timer);

    float *A_h, *B_h, *C_h;
    float *A_d, *B_d, *C_d;
    size_t A_sz, B_sz, C_sz;
    unsigned matArow, matAcol;
    unsigned matBrow, matBcol;
    dim3 dim_grid, dim_block;

    if (argc == 1) {
        matArow = 1000;
        matAcol = matBrow = 1000;
        matBcol = 1000;
    } else if (argc == 2) {
        matArow = atoi(argv[1]);
        matAcol = matBrow = atoi(argv[1]);
        matBcol = atoi(argv[1]);
    } else if (argc == 4) {
        matArow = atoi(argv[1]);
        matAcol = matBrow = atoi(argv[2]);
        matBcol = atoi(argv[3]);
    } else {
        printf("\n    Invalid input parameters!"
      "\n    Usage: ./sgemm-tiled                # All matrices are 1000 x 1000"
      "\n    Usage: ./sgemm-tiled <m>            # All matrices are m x m"
      "\n    Usage: ./sgemm-tiled <m> <k> <n>    # A: m x k, B: k x n, C: m x n"
      "\n");
        exit(0);
    }
   
    A_sz = matArow*matAcol;
    B_sz = matBrow*matBcol;
    C_sz = matArow*matBcol;

    A_h = (float*) malloc( sizeof(float)*A_sz );
    for (unsigned int i=0; i < A_sz; i++) { A_h[i] = (rand()%100)/100.00; }

    B_h = (float*) malloc( sizeof(float)*B_sz );
    for (unsigned int i=0; i < B_sz; i++) { B_h[i] = (rand()%100)/100.00; }

    C_h = (float*) malloc( sizeof(float)*C_sz );

    stopTime(&timer); printf("%f s\n", elapsedTime(timer));
    printf("    A: %u x %u\n    B: %u x %u\n    C: %u x %u\n", matArow, matAcol,
        matBrow, matBcol, matArow, matBcol);

    // Allocate device variables ----------------------------------------------

    printf("Allocating device variables..."); fflush(stdout);
    startTime(&timer);

    /*************************************************************************/
    //INSERT CODE HERE
    cudaMalloc((void**)&A_d,sizeof(float)*A_sz);
    cudaMalloc((void**)&B_d,sizeof(float)*B_sz);
    cudaMalloc((void**)&C_d,sizeof(float)*C_sz);
    /*************************************************************************/
	
    cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Copy host variables to device ------------------------------------------
    printf("Copying data from host to device..."); fflush(stdout);
    startTime(&timer);
    time_t start2 = clock();	
    /*************************************************************************/
    //INSERT CODE HERE
    cudaMemcpy(A_d,A_h,sizeof(float)*A_sz,cudaMemcpyHostToDevice);
    cudaMemcpy(B_d,B_h,sizeof(float)*B_sz,cudaMemcpyHostToDevice);

    /*************************************************************************/
    
    cudaDeviceSynchronize();
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Launch kernel using standard sgemm interface ---------------------------
    printf("Launching kernel..."); fflush(stdout);
    startTime(&timer);
    basicSgemm(matArow, matBcol, matBrow, A_d, B_d, C_d);

    cuda_ret = cudaDeviceSynchronize();
    if(cuda_ret != cudaSuccess) printf("Unable to launch kernel");
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Copy device variables from host ----------------------------------------
    printf("Copying data from device to host..."); fflush(stdout);
    startTime(&timer);

    /*************************************************************************/
    //INSERT CODE HERE
    cudaMemcpy(C_h,C_d,sizeof(float)*C_sz,cudaMemcpyDeviceToHost);
    /*************************************************************************/
    time_t end2 = clock();
    double gpu_time = double(end2 - start2)/CLOCKS_PER_SEC;
    cudaDeviceSynchronize();
    //stopTime(&timer); printf("%f s\n", elapsedTime(timer));
    printf("\nTime taken for CUDA MM:  %.3f seconds.\n", gpu_time);
    // Verify correctness -----------------------------------------------------

    printf("Verifying results..."); fflush(stdout);

    verify(A_h, B_h, C_h, matArow, matAcol, matBcol); //commented out for timing results


    // Free memory ------------------------------------------------------------

    free(A_h);
    free(B_h);
    free(C_h);

    /*************************************************************************/
    //INSERT CODE HERE
    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);   
    /*************************************************************************/

    return 0;
}

