#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

#define MM_SIZE 1000

void mm(float a[][MM_SIZE], float b[][MM_SIZE], int a_row_size, int a_col_size, int b_row_size, int b_col_size){

	int r[a_row_size][b_col_size];
	cout << "starting normal mult..." << endl;

	for(int i = 0; i < a_row_size; i++){
		for(int j = 0; j < a_col_size; j++){
			r[i][j] = 0;
			for(int k = 0; k < b_row_size; k++){
				r[i][j] += a[i][k] * b[k][j];
			}
		cout << r[i][j] << "\t";
		}
	cout << endl;
	}

} 
	
