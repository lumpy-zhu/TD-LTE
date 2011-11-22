#pragma once

class IO{
 public:
  virtual ~IO(){}
  
  template <typename T>int send(const T* data, size_t size){
    return _send(data, size*sizeof(T)) /sizeof(T);
  }
  
  template <typename T>int recv(T* data, size_t size){
    return _recv(data, size*sizeof(T)) /sizeof(T);
  }
  
 protected:
  virtual int _send(const void* buff, size_t size)=0;
  virtual int _recv(void* buf, size_t size)=0;
  
};

