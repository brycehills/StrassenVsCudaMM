#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

#define MM_SIZE 64

void PrintMatrix(float a[MM_SIZE][MM_SIZE], int n){
	cout << "Printing matrix: " << endl;
	for(int i = 0; i < n ; i++){
		for(int j = 0; j < n;j++){
			cout << a[i][j] << " ";
		}
	cout << endl;
	}

} 


void mm(float a[MM_SIZE][MM_SIZE], float b[MM_SIZE][MM_SIZE], float r[MM_SIZE][MM_SIZE]){

	cout << "starting naive mm..." << endl;

	for(int i = 0; i < MM_SIZE; i++){
		for(int j = 0; j < MM_SIZE; j++){
			r[i][j] = 0;
			for(int k = 0; k < MM_SIZE; k++){
				r[i][j] += a[i][k] * b[k][j];
			}
		}
	} //end outer for loop
}


void AddMatrix(float a[MM_SIZE][MM_SIZE], float b[MM_SIZE][MM_SIZE], float r[MM_SIZE][MM_SIZE], int n)
{
	for(int i = 0; i < n; i++){

		for(int j = 0; j < n; j++){
			r[i][j] = a[i][j] + b[i][j];
		}
	}
}

	
void SubMatrix(float a[MM_SIZE][MM_SIZE], float b[MM_SIZE][MM_SIZE], float r[MM_SIZE][MM_SIZE], int n)
{
	for(int i = 0; i < n; i++){
		for(int j = 0; j < n; j++){
			r[i][j] = a[i][j] - b[i][j];
		}
	}
}

void Strassen(float a[MM_SIZE][MM_SIZE], float b[MM_SIZE][MM_SIZE], float r[MM_SIZE][MM_SIZE], int n)
{
	if(n==1) //base case
	{
		r[0][0] = a[0][0] * b[0][0];
		return;
	}	
	else
	{
		int d = int(n/2);
		//declare sub matrices
		float a11[MM_SIZE][MM_SIZE];
		float a12[MM_SIZE][MM_SIZE];		
		float a21[MM_SIZE][MM_SIZE];
		float a22[MM_SIZE][MM_SIZE];

		float b11[MM_SIZE][MM_SIZE];
		float b12[MM_SIZE][MM_SIZE];
		float b21[MM_SIZE][MM_SIZE];
		float b22[MM_SIZE][MM_SIZE];

		float c11[MM_SIZE][MM_SIZE];
		float c12[MM_SIZE][MM_SIZE];
		float c21[MM_SIZE][MM_SIZE];
		float c22[MM_SIZE][MM_SIZE];

		float p1[MM_SIZE][MM_SIZE];
		float p2[MM_SIZE][MM_SIZE];
		float p3[MM_SIZE][MM_SIZE];
		float p4[MM_SIZE][MM_SIZE];
		float p5[MM_SIZE][MM_SIZE];
		float p6[MM_SIZE][MM_SIZE];
		float p7[MM_SIZE][MM_SIZE];

		float AR[MM_SIZE][MM_SIZE];
		float BR[MM_SIZE][MM_SIZE];
	
	for(int i = 0; i < d; i++){
		for (int j = 0; j < d; j++){
			//div up a sub matrices
			a11[i][j] = a[i][j];
			a12[i][j] = a[i][j + d];
			a21[i][j] = a[i+d][j];
			a22[i][j] = a[i+d][j+d];
			//divide b sub matrices
			b11[i][j] = b[i][j];
			b12[i][j] = b[i][j + d];
			b21[i][j] = b[i+d][j];
			b22[i][j] = b[i+d][j+d];
		}	

	} 
	//-------------------
	// calc p1,p2,...p7
	// ------------------
	AddMatrix(a11,a22,AR,d); // add a11, a22
	AddMatrix(b11,b22,BR,d); // add b11, b22
	Strassen(AR,BR,p1,d);	// strass result a & result b into p1
 
	AddMatrix(a21,a22,AR,d); // add a21 + a22
	Strassen(AR,b11,p2,d); 	// call strassen p2 = ar * b11

	SubMatrix(b12,b22,BR,d);// sub br = b12 - b22
	Strassen(a11,BR,p3,d);// recursive call p3 = a11 * br 
	
	SubMatrix(b21,b11,BR,d);// sub b21 - b11 
	Strassen(a22,BR,p4,d);// recursive call p4 = a22 * br

	AddMatrix(a11,a12,AR,d);// add a11 + a12
	Strassen(AR,b22,p5,d);// strass p5 = ar * b22

	SubMatrix(a21,a11,AR,d); // sub a21 - a11
	AddMatrix(b11,b12,BR,d); // add b11 + b12
	Strassen(AR,BR,p6,d);// strass p6 = ar * br
	
	SubMatrix(a12,a22,AR,d); // sub a12 - a22 
	AddMatrix(b21,b22,BR,d);// add b21 + b22
	Strassen(AR,BR,p7,d);// strass p7 = ar * br
	//---------------------
	// calc c sub matrices
	AddMatrix(p3,p5,c12,d);// c12 = p3+p5
	AddMatrix(p2,p4,c21,d);// c21 = p2+p4
	//
	AddMatrix(p1,p4,AR,d);//add p1 p4
	AddMatrix(AR,p7,BR,d);//add (p1,p4) p7
	SubMatrix(BR,p5,c11,d);//sub c11= p1 + p4 - p5 + p7
	
	AddMatrix(p1,p3,AR,d);//p1 + p3
	AddMatrix(AR,p6,BR,d);//p1+p3 + p6
	SubMatrix(BR,p2,c22,d);//c22 = p1+p3-p2+p6

	//merge result matrix r
	for(int i =0; i < d; i++){
		for( int j = 0; j < d; j++){
			r[i][j] = c11[i][j];
			r[i][j+d] = c12[i][j];
			r[i+d][j] = c21[i][j];
			r[i+d][j+d] = c22[i][j];
		}
	}

	} // END ELSE STATEMENT
}
