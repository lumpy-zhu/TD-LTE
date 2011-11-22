#pragma once

#include <fftw3.h>
#include "types.h"

class FFTPlan{
 public:
  FFTPlan (int size)
      :size_(size){

    cfloat *data = malloc();

    p1=fftwf_plan_dft_1d(size, (fftwf_complex*)data, (fftwf_complex*)data, FFTW_FORWARD,  FFTW_MEASURE);
    p2=fftwf_plan_dft_1d(size, (fftwf_complex*)data, (fftwf_complex*)data, FFTW_BACKWARD, FFTW_MEASURE);

    free(data);
  }

  cfloat* malloc(size_t len=0){
    if(len==0)	len=size_;
    return (cfloat*)fftwf_malloc(sizeof(cfloat)*len);
  }

  void	free(cfloat* ptr){
    fftwf_free(ptr);
  }
  
  ~FFTPlan(){
    fftwf_destroy_plan(p1);
    fftwf_destroy_plan(p2);
  }

  void fft (cfloat *in, cfloat *out){
    fftwf_execute_dft(p1, (fftwf_complex*)in, (fftwf_complex*)out);
  }

  void fft(cfloat *data){
    fft(data, data);
  }
  
  void ifft(cfloat *in, cfloat *out){
    fftwf_execute_dft(p2, (fftwf_complex*)in, (fftwf_complex*)out);
    for (int i = 0; i < size_; ++i) {
      out[i]/=size_;
    }
  }

  void ifft(cfloat *data){
    ifft(data, data);
  }
  
 private:
  int           size_;
  fftwf_plan    p1;
  fftwf_plan    p2;
};
