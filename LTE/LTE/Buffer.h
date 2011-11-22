#pragma once

#include <unistd.h>
#include <string.h>
#include <fftw3.h>

#include "types.h"

template <typename T>class Buffer{
 public:
  Buffer(int max_size, int block_size):
      MAX_SIZE(max_size),
      BLOCK_SIZE(block_size),
      data((T*)fftwf_malloc(sizeof(T)*MAX_SIZE)),
      size(0),
      head(0ull)
  {}

  virtual ~Buffer(){
    fftwf_free(data);
  }
  
  void push(const T* src, int src_len){
    T* current  = data+size;
    T* tail     = data+MAX_SIZE;
    
    if (current+src_len > tail) {
      memcpy(data, current-BLOCK_SIZE, sizeof(T)*BLOCK_SIZE);

      head += size-BLOCK_SIZE;
      size = BLOCK_SIZE;
    }

    memcpy(data+size, src, sizeof(T)*src_len);
    size+=src_len;
  }

  T& operator[](uint64_t index){
    int real_index = index-head;
    return data[index-head];
  }

  T& operator()(int index){
    return data[index];
  }

  
  bool has_data(uint64_t index){
    if(index == 0) return false;

    uint64_t id = index-head;
    return (id>=0) && (id+BLOCK_SIZE<(uint64_t)size);
  }

 public:
  const int     MAX_SIZE;
  const int     BLOCK_SIZE;
  
  T* const      data;
  int           size;

  uint64_t      head;
};


typedef Buffer<cfloat>  RxBuffer;
