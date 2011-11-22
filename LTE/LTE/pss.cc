
#include "Frame.h"
#include <assert.h>

cfloat Frame::pss[N_PSS];

void Frame::init_pss(int nid2){
  assert(nid2>=0 && nid2<=2);
  int u_roots[]={25,29,34};
  int u_root = u_roots[nid2];
  
  float base=-M_PI*u_root/63.0;
  int   mid=N_PSS/2;
  
  for (int i = 0; i < mid; ++i) {
    float tmp=base*i*(i+1);
    pss[i]=cfloat( cos(tmp), sin(tmp));
  }

  for (int i = mid; i < N_PSS; ++i) {
    float tmp=base*(i+1)*(i+2);
    pss[i]=cfloat( cos(tmp), sin(tmp));
  }
}

