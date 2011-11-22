#include "Frame.h"

/* funcs */
void linear_interp(SubFrame* sframe);

  
void Frame::channel_estimation(){
  static const float EPS=0.000001;
  
  for (int sid = 0; sid < N_SUBFRAMES/2; ++sid) {       // do for half frame
    if(sid%5 == 2 || sid%5 == 3) continue;              // up link

    // port=0
    // [l,k] = [0:0, 4:3]
    for (int c = 0; c < N_OFDM; ++c) {
      int k;
	
      if (c%7==0)		k=0; 
      else if (c%7==(4))        k=3;
      else                      continue;

      const cfloat* crs=vcrs[c];
      SubFrame& sframe =frame[sid];
      
      for (int i = 0; i < N_RB*N_SC; ++i) {
        if ( (i-k)%6 ==0) {
          cfloat	y = sframe[c][i];       // h=y
          cfloat	x = crs   [(i-k)/6];
          y = y / (x+EPS) / 2;                  // y=h*x+noise
        }
      }
    }
    
    linear_interp( &frame[sid]);
  }
}




void linear_interp(SubFrame* sframe_ptr){
  SubFrame& sframe = *sframe_ptr;
  
  //col interp
  for (int c = 0; c < N_OFDM; ++c) {
    cfloat *col=sframe[c];

    int i,k;

    //@note for port[0]
    if(c%7==0)			k=0; 
    else if(c%7==(7-3))		k=3;
    else			continue;

    // head
    cfloat step_head =(col[k+6]-col[k])/6;
    for (i=k-1; i>=0; --i) {
      col[i] = col[i+1]-step_head;
    }

    // body
    for (i=k; i+6<N_RB*N_SC; i+=6) {
      cfloat step=(col[i+6]-col[i])/6;
      for ( int j=1; j < 6; ++j) {
        col[i+j] = col[i+j-1]+step;
      }
    }

    //tail
    cfloat step_tail =(col[i]-col[i-6])/6;
    for (; i < N_RB*N_SC; ++i) {
      col[i] = col[i-1]+step_tail;
    }
  }
  
  //row interp
  for (int r = 0; r < N_RB*N_SC; ++r) {
    //cols=[0,4,7,11]
    static int cols[]={0,4,7,11};

    //head
    //@note no head
	
    //body
    for ( int i = 0; i+1 < ARRAY_LEN(cols); ++i) {
      cfloat step=(sframe[cols[i+1]][r]-sframe[cols[i]][r])/(cols[i+1]-cols[i]);
      for (int j = cols[i]+1; j < cols[i+1]; ++j) {
        sframe[j][r]=sframe[j-1][r]+step;
      }
    }
    //tail
    cfloat step_tail=(sframe[11][r]-sframe[7][r])/(11-7);
    for (int i = 11+1; i < 14; ++i) {
      sframe[i][r]=sframe[i-1][r]+step_tail;
    }
  }
}
