#pragma once

#include <stdint.h>

template <typename T>struct Bit{
  enum{
    size=sizeof(T)*8
  };
  class reference;

  Bit(T t=0x0): b(t){}

  reference operator[](int i) {
    return reference(b, i);
  }
  
  reference operator[](int i) const {
    return reference(b, i);
  }

 private:
  T      b;
  
 public:
  class element{
   public:
    element(T& t, int index):
        b(t),
        i(index)
    {}
    
    element& operator=(T t){
      if(t)        b |=  (0x1<<i);
      else         b &= ~(0x1<<i);
      return *this;
    }

    operator bool() const{
      return (b&(0x1<<i)) >> i;
    }
    
   private:
    T&    b;
    int   i;
  };
};


template <typename T>class Bits{
 public:
  typedef Bit<T>       bit;
  
  Bits(int size):
      data( new bit[size/sizeof(bit)+1])
  {}
  
  virtual ~Bits(){
    delete[] data;
  }

  typename Bit<T>::element operator[](int i) {
    return data[i/sizeof(bit)][i%sizeof(bit)];
  }

  typename Bit<T>::element operator[](int i) const {
    return data[i/sizeof(bit)][i%sizeof(bit)];
  }
  
 private:
  Bit<T>*      data;
};


typedef Bit<uint8_t>  	bit8_t;
typedef Bit<uint16_t> 	bit16_t;
typedef Bit<uint32_t> 	bit32_t;
typedef Bits<uint32_t>	bits_t;

