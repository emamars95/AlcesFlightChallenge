//#pragma once
#include <time.h>
#include <iostream>
#include <cmath>
#include <cblas.h>

// generate int or float matrix
template <class M>
M** matrix_gen(int size){
//    time_t t;
//    srand((unsigned)time(&t));
    M** matrix = new M*[size];
    for(int i=0;i<size;i++){
        matrix[i]=new M[size];
        for (int j=0;j<size;j++){
            matrix[i][j]=static_cast<M>(rand())/static_cast<M>(RAND_MAX/100);
        }
    }
    return matrix;
}

template int** matrix_gen<int>(int size);
template float** matrix_gen<float>(int size);
template double** matrix_gen<double>(int size);

// matrix multiplication
template <class M>
M** mat_mult(M** a, M** b, int size){
    M** c = new M*[size];
    for (int i=0;i<size;i++){
        c[i] = new M[size];
        for (int j=0;j<size;j++){
            c[i][j]=0;
            for (int k=0;k<size;k++)
            {
                c[i][j]+=a[i][k]*b[k][j];
            }
        }
    }
    return c;
}

template int** mat_mult<int>(int **a, int **b, int size);
template float** mat_mult<float>(float**a, float**b, int size);
template double** mat_mult<double>(double**a, double**b, int size);

// print out the matrix for debugging
template<class M>
void printMatrix(M** matrix, int size){
    for (int i=0;i<size;i++){
        for(int j=0;j<size;j++)
            std::cout<<matrix[i][j]<<"\t";
        std::cout<<"\n";
    }
}

template void printMatrix<int>(int** matrix, int size);
template void printMatrix<float>(float** matrix, int size);
template void printMatrix<double>(double** matrix, int size);

int operation(int size) {
    int nop;
    nop = 2 * pow(size,3) - pow(size,2);
//    std::cout << nop << '\n';
    return nop;
}

void result(time_t start, time_t end, int size) {
    double flop, tdiff;
    int nop; 
    nop = operation(size);
    tdiff = double(end-start)/double(CLOCKS_PER_SEC);
    std::cout << "Timing (1 core): " << tdiff << " s\n";
    flop = nop/tdiff;
    std::cout << "Operation per second (1 core): " << flop << std::endl;    
}

 void print(const double* matrix, int row, int column)
{
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            std::cout << matrix[j * row + i] << "\t";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

void cblas_time(double** c3, int size) {
    time_t start, end;
    double* m = new double[size * size];
    double* matrixo = new double[size * size];
    for (int i=0; i < size; i++) {
        for (int j=0 ; j < size; j++) {
            m[j * size + i] = c3[i][j];
        }
    }  
    start = clock();
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, size, size, size, 1, m, size, m, size, 0, matrixo, size);
    end = clock();
    result(start, end, size);
//    print(matrixo, size, size);
}

int main(int argc, char* argv[]){
    int size, nop;
    time_t start, end;
    double inop, flop, tdiff;
    if (argc < 2){
        std::cout << "Enter dim matrix: ";    // ask user for a number 
        std::cin >> size;                      // get number from keyboard and store it in variable x
        std::cout << std::endl;
    } 
    else{
        size = atoi(argv[1]);
    }
    int** matrix = matrix_gen<int>(size);
//    printMatrix<int>(matrix, size);
    float** matrix2 = matrix_gen<float>(size);
//    printMatrix<float>(matrix2,size);
    double** matrix3 = matrix_gen<double>(size);

    std::cout << std::endl << "Integer" << std::endl << std::endl; 
    start = clock();
    int** c1 = mat_mult<int>(matrix, matrix, size);
    end = clock();
    result(start, end, size);
//    printMatrix<int>(c1, size);

    std::cout << std::endl << "Float" << std::endl << std::endl; 
    start = clock();
    float** c2 = mat_mult<float>(matrix2, matrix2, size);
    end = clock();
    result(start, end, size);
//   printMatrix<float>(c2, size);

    std::cout << std::endl << "Double" << std::endl << std::endl;
    start = clock();
    double** c3 = mat_mult<double>(matrix3, matrix3, size);
    end = clock();
    result(start, end, size);
//    printMatrix<double>(c3, size);

    std::cout << std::endl << "OPENBLAS" << std::endl << std::endl;
    cblas_time(matrix3, size);
    return 0;
}
