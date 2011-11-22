#pragma once

#include "types.h"
#include "config.h"
#include "FrameTemplate.h"

#include <string.h>     // memset
#include <math.h>       // sqrtf

typedef cfloat   FrameCol[N_RB*N_SC];           // 25*12=300
typedef FrameCol SubFrame[N_OFDM];              // 14

class Frame{
 public:
  typedef FrameCol      Col;
  typedef FrameTemplate Template;
  
  Frame(){
    frame = new SubFrame[N_SUBFRAMES];
  }
  
  virtual ~Frame(){
    delete[] frame;
  }

  
  SubFrame& operator[](int sid){
    return frame[sid];
  }
  const SubFrame& operator[](int sid)const{
    return frame[sid];
  }


  
  void clear(){
    memset(frame, 0, sizeof(FrameCol)*N_SUBFRAMES);
  }

  void set_data(const cfloat* src){
    for (int sid = 0; sid < N_SUBFRAMES; ++sid) {
      for (int cid = 0; cid < N_OFDM; ++cid) {
        cfloat* col=frame[sid][cid];
        const vint& data_indexs = tp[sid][cid];

        for (int i = 0; i < data_indexs.size(); ++i) {
          col[data_indexs[i]] = src[i];
        }
        src += data_indexs.size();
      }
    }
  }

  void get_data(cfloat *dst) const {
    for (int sid = 0; sid < N_SUBFRAMES; ++sid) {
      for (int cid = 0; cid < N_OFDM; ++cid) {
        cfloat* col=frame[sid][cid];
        const vint& data_indexs = tp[sid][cid];

        for (int i = 0; i < data_indexs.size(); ++i) {
          dst[i] = col[data_indexs[i]];
        }
        dst += data_indexs.size();
      }
    }    
  }


  void set_pss(){
    const int PSS_START = (N_RB*N_SC-N_PSS)/2;
    const int PSS_SIZE  = N_PSS*sizeof(cfloat);

    // @warning
    // pad zero 
    
    // set pss data
    memcpy(frame[0][2]+PSS_START, pss, PSS_SIZE);
    memcpy(frame[5][2]+PSS_START, pss, PSS_SIZE);
  }

  void set_crs(){
    const float rs[2]={ 1/sqrtf(2), -1/sqrtf(2)};

    for (int sid = 0; sid < N_SUBFRAMES; ++sid) {       // 10
      if(sid%5==2 || sid%5==3) continue;                // uplink
      
      for (int oid = 0; oid < N_OFDM; ++oid) {          // 14
        cfloat* col = frame[sid][oid];          
        const cfloat* crs = vcrs[oid];
        int     v;
        
        /************************
         * @note port  0
         ************************/
        if      (oid%7==0) { v = 0; }
        else if (oid%7==4) { v = 3; }     
        else             { continue; }
        
        for (int k = v; k < N_RB*N_SC; k+=6) {
          col[k] = crs[(k-v)/6];
        }
      }
    }
  }


  void set_fftdata(int sid, int oid, const cfloat* src);
  void get_fftdata(int sid, int oid, cfloat* dst) const;


  void channel_estimation();
  
  void map(const cfloat* data) {
    set_data(data);
    set_pss();
    set_crs();
  }

  void demap(cfloat *data) const{
    get_data(data);
  }

 public:
  static void init(int nid2){
    init_pss(nid2);
    init_crs();
  }
  
 private:
  static void init_pss(int nid2);
  static void init_crs();  

 private:
  SubFrame*             frame;
  
  static Template       tp;  
  static cfloat         pss[N_PSS];
  static cfloat         vcrs[N_OFDM][N_CRS];
};
