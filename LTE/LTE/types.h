#pragma once

#include <stdint.h>
#include <ctype.h>
#include <float.h>
#include <vector>
#include "complex.h"
#include "Bit.h"

typedef unsigned int            uint;
typedef unsigned long           ulong;
typedef unsigned char           byte;


typedef std::vector<int>    	vint;
typedef std::vector<float>  	vfloat;
typedef std::vector<cint>   	vcint;
typedef std::vector<cfloat> 	vcfloat;



template <typename T>class matrix;

template <typename T, int COLS, int ROWS>
class matrix<T[COLS][ROWS]>{
 public:  
  enum{
    cols=COLS,   
    rows=ROWS
  };
  
  T* operator[](int c){
    return _[c];
  }

  const T* operator[](int c) const {
    return _[c];
  }
  
  T     _[COLS][ROWS];
};


#define ARRAY_LEN(array)        (sizeof(array)/sizeof(array[0]))

