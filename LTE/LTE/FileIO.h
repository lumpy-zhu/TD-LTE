#pragma once

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string>
#include "IO.h"

class FileIO: public IO{
 public:
  
  FileIO(std::string filename, std::string mode){
    file = fopen(filename.c_str(), mode.c_str());
    assert(file!=0);
  }

  virtual ~FileIO(){
    fclose(file);
  }
  
 protected:
  int _send(const void* data, size_t len){
    return fwrite(data, 1, len, file);
  }
  
  int _recv(void* data, size_t len){
    return fread(data,  1, len, file);
  }

 private:
  FILE* file;
};

  
