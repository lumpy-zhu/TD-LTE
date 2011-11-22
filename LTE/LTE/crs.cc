#include "Frame.h"

void gold_seq( int c[/*M_PN*/], int c_init){
  const int M_PN=2*2*N_MAX_RB;
  const int N_c =1600;

  int x1[31+N_c+M_PN];
  int x2[31+N_c+M_PN];

  // init x1
  x1[0] = 1;
  for (int i = 1; i <= 30; ++i) {
    x1[i] = 0;
  }

  // init x2
  for (int i = 0; i <= 30; ++i) {
    x2[i] = (c_init & (1<<i)) >> i;
  }

  // caculate x1
  for (int n = 0; n < ARRAY_LEN(x1)-31; ++n) {
    x1[n+31] = x1[n+3] ^ x1[n];
  }

  // caculate x2
  for (int n = 0; n < ARRAY_LEN(x2)-31; ++n) {
    x2[n+31] = x2[n+3] ^ x2[n+2] ^ x2[n+1] ^ x2[n];
  }

  // caculate n
  for (int n = 0; n < M_PN; ++n) {
    c[n] = x1[n+N_c] ^ x2[n+N_c];
  }
  
}

cfloat Frame::vcrs[N_OFDM][N_CRS];
void Frame::init_crs(){
  int c[2*2*N_MAX_RB];

  for (int nid = 0; nid < N_OFDM; ++nid) {
    cfloat*     crs     = vcrs[nid];
    int         ns      = nid/2;
    int         l       = nid%2;    
    int         c_init  = (1<<10) * (7*(ns+1)+l+1) * (2*N_CELL_ID+1) + 2*N_CELL_ID + N_CP;
    gold_seq(c, c_init);
    for (int i = 0; i < N_CRS; ++i) {
      
      /*
       * m = [0,1,...6*N_MAX_RB-1]
       * r = 1/sqrt(2) * ( 1-2*c[2m], 1-2*c[2m+1])
       * m_= m+N_MAX_RB-N_RB    @note i == m_
       * a = r[m_]
       */
      crs[i] = cfloat( 1-2*c[2*(i+N_MAX_RB-N_RB)], 1-2*c[2*(i+N_MAX_RB-N_RB)+1])/sqrtf(2);
    }
  }
}

