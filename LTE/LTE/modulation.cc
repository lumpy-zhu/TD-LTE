
#include "types.h"
#include "config.h"

#include <math.h>

float book_lens[]={
  sqrtf(2),
  sqrtf(10),
  sqrtf(42)
};

float book_codes[][8]= {
  {1,	-1							},
  {1,	3,	-1,	-3					},
  {3,	1,	5,	7,	-3,	-1,	-5,	-7	}
};

void modulation(const vcint &data, vcfloat &symbol){
  const float *book_code= book_codes[MODORDER/2-1];
  const float book_len	= book_lens [MODORDER/2-1];

  //@note:: symbol maybe alloc outside
  symbol.resize(data.size()/(MODORDER/2));
	
  // loop start, each step set symbol[i]
  const cint *d=data.data();
  for( int i=0; i< symbol.size(); ++i){
	
    //get data to pack e
    cint  e(0);
    for( int k=0; k<MODORDER/2; ++k){
      e.r = (e.r<<1) ^ d->r;
      e.i = (e.i<<1) ^ d->i;
      ++d;
    }

    symbol[i] = cfloat(book_code[e.r]/book_len, book_code[e.i]/book_len);
  }
}




inline float sign(const float v){
  return v>0? 1: -1;
}

inline void demod_4(const float& i, float& o1, float& o2){
  float a=fabsf(i);
  int   s=sign(i);
  
  o1 = a<2? -i : s*(2-2*a);
  o2 = a-2;
}

inline void demod_6(const float& i, float& o1, float& o2, float& o3){
  float a=fabsf(i);
  int   s=sign(i);

  if (s<=2)             o1=-i;                  // [0...2 ]
  else if (s<=4)        o1=sign(i)*(2*a-2);     // [2...6 ]
  else if (s<=6)        o1=sign(i)*(3*a-6);     // [6...12]
  else                  o1=sign(i)*(4*a-12);    // [12....]

  if (s<=2)             o2=2*a-6;               // [0...2 ]
  else if(s<=6)         o2=1*a-4;               // [0...2 ]
  else                  o2=2*a-10;              // [0...2 ]

  if (s<=4)             o3=-a+2;                // [0...2 ]
  else                  o3=+a-6;                // [0...2 ]
}


void demod(const vcfloat &symbol, vcfloat &data, int MODORDER){
  const float *book_code=book_codes[MODORDER/2-1];
  const float book_len	=book_lens [MODORDER/2-1];
  
  //@note:: symbol maybe alloc outside
  data.reserve(symbol.size()*(MODORDER/2));
    
  // loop start, each step set symbol[i]
  cfloat *d=data.data();
  
  
  const float sqrt_2  = sqrtf(2);
  const float sqrt_10 = sqrtf(10);
  const float sqrt_42 = sqrtf(42);
  
  // MODORDER=2  
  switch(MODORDER){
    case 2:
      for( int i=0; i< symbol.size(); ++i){
        data[i]=-symbol[i]*sqrt_2;
      }
      break;
      
    case 4:
      for( int i=0; i< symbol.size(); ++i){
        cfloat c = symbol[i]*sqrt_10;
        demod_4(c.r, data[2*i].r, data[2*i+1].r);
        demod_4(c.i, data[2*i].i, data[2*i+1].i);
      }      
      break;

    case 6:
      for( int i=0; i< symbol.size(); ++i){
        cfloat c = symbol[i]*sqrt_42;
        demod_6(c.r, data[3*i].r, data[3*i+1].r, data[3*i+2].r);
        demod_6(c.i, data[3*i].i, data[3*i+1].i, data[3*i+2].i);
      }            
      break;
  }
}

