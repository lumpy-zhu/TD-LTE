#pragma once

#include "IO.h"
#include <string.h>

class MemIO: public IO{
 public:
  MemIO(void *ptr):data(ptr){}
  virtual ~MemIO(){}
  
 protected:
  int _send(const void* src, size_t size){
    memcpy(data, src, size);
    return size;
  }
  
  int _recv(void* dst, size_t size){
    memcpy(dst, data, size);
    return size;
  }

 private:
  void *data;
};

