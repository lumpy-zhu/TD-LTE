
#include "config.h"
#include "types.h"

// Y = HX + N
// N: noise
inline void fde(const cfloat *y, const cfloat *h, cfloat *x, int size=N_PDSCH){
  for (int i = 0; i < size; ++i) {
    x[i] = y[i]/h[i];
  }
}

