#pragma once

#include <sstream>
template <typename Bit> inline void bit2ints( Bit bits, int ints[sizeof(Bit)*8]){
  for (int i = 0; i < sizeof(Bit)*8; ++i) {
    ints[i]= (bits&(1<<i))>>i;
  }
}


template <typename Bit> inline void bits2ints( Bit bits[], int ints[], int size){
  for (int i = 0; i < size; ++i) {
    bit2ints( bits[i], &ints[i*sizeof(Bit)*8] );
  }
}



template <typename Bit> inline void ints2bit(int ints[], Bit &bit){
  bit=0;
  for (int i = 0; i < sizeof(Bit); ++i) {
    if(ints[i])  bit |= 1<<i;
  }
}


template <typename Bit> inline void ints2bits(int ints[], Bit bit[], int size){
  for (int i = 0; i < size; ++i) {
    ints2bit(ints[i*sizeof(Bit)*8], &bit[i]);
  }
}


template <typename T,typename F>T convert(F f){
  std::stringstream ss;
  T t;
  ss<<f;
  ss>>t;
  return t;
}

