#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

#define MM_SIZE 1000

void mm(float a[MM_SIZE][MM_SIZE], float b[MM_SIZE][MM_SIZE]){

	float r[MM_SIZE][MM_SIZE];
	cout << "starting normal mult..." << endl;

	for(int i = 0; i < MM_SIZE; i++){
		for(int j = 0; j < MM_SIZE; j++){
			r[i][j] = 0;
			for(int k = 0; k < MM_SIZE; k++){
				r[i][j] += a[i][k] * b[k][j];
			}
		cout << r[i][j] << "     ";
		}
	cout << endl;
	}

} 
	
