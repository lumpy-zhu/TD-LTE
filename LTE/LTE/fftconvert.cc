#include "Frame.h"

void Frame::set_fftdata(int sid, int oid, const cfloat* in) {
  cfloat *out = frame[sid][oid];
  out[0] = cfloat(0);
  memset(out+151, 0, sizeof(cfloat)*(512-300-1));
  
  memcpy(out+1,         in+150,         150*sizeof(cfloat));
  memcpy(out+512-150,   in,             150*sizeof(cfloat));  
}



void Frame::get_fftdata(int sid, int oid, cfloat *out) const {
  const cfloat *in = frame[sid][oid];
  memcpy(out+150,        in+1,          150*sizeof(cfloat));
  memcpy(out,            in+512-150,	150*sizeof(cfloat));  
}
