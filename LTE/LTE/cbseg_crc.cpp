

/*
 * code block segemtation and code block CRC attach
 */
void cbseg_crc( /*const bit b[]*/, int B, bit c[], TBC *tbc){
  enum{
    Z   = 6144, //maximim of codeblocks len
  };
  
  // B<40:      filter bits are add to the beginning of the code block
  //            filter bits shall be <NULL>
  if (B < 40) { 
    for (int i = 0; i < 40-B; ++i) out[i]=CODE_NULL;
    memcpy( &out[40-B], in, B);
    return;
  }

  

  // determin total number of code blocks C
  int L, C, B_;  
  if (B<=Z) {
    L   = 0;
    C   = 1;
    B_  = B;            // @note B_ means B'
  } else {
    L   = 24;
    C   = (B+(Z-L-1))/(Z-L);
    B_  = B + C*L;      // @note B_ means B'
  }


  
  int K_max;                            // K+: number of code block size
  int K_min;                            // K-: second segemetation size
  int delta_K;                          // 𝛥K = K+ - K-;
  int C_max;                            // C+: number of segemation of size K_
  int C_min;                            // C-: number of segemation of size K+
  int F;                                // F:  number of filter bits
  if (C==1) {
    C_max = 1;
    K_min = 0;
    C_min = 0;
  } else {
    //@warning K_max
    //@warning K_min
    delta_K     = K_max-K_min;
    C_min       = ((C*K_max-B_)+(delta_K-1))/delta_K;
    C_max       = C-C_min;
  }
  F = C_max*K_max + C_min*K_min - B_;

  for (int k = 0; k < F; ++k) {
    c[0][k] = CODE_NULL;
  }


  int s = 0;
  for (int r = 0; r < C; ++r) {
    int k=(r==0?F:0);
    
    if (r<C_min)        K_r = K_min;
    else                K_r = K_max;
    
    for ( ; k < K_r-L; ++k,++s) {
      c[r][k] = b[s];
    }

    if (C>1) {
      Byte p = convert<Byte>crc24b(c[r], K_r-L);
      for ( ; k<K_r; ++k) {
        c[r][k] = p[k+L-K_r];
      }
    }
  }
}
