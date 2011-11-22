#pragma once

#include "types.h"
#include "config.h"

typedef int BlockTemplate[N_SC][N_OFDM];

class FrameTemplate{
 public:
  enum Type{
    DST1=0,             // downlink subframe 1
    DST2,		// downlink subframe 2
    DST3,		// downlink subframe 3

    SST1,		// special  subframe 1
    SST2,		// special  subframe 2

  
    UST1,		// uplink   subframe 1
    UST2,		// uplink   subframe 2

    N_TYPES
  };


  FrameTemplate():
      data_nums(0)
  {
    init_block_tps();
    init_indexs();
  }

  const vint* operator[] (int sid) const{
    return indexs[sid];
  }

 private:
  Type get_type(int sid, int rid);
  
  typedef int (*BlockTemplate_p)[N_OFDM];
  BlockTemplate_p block_tps[N_TYPES];
  void init_block_tps();
  
 private:
  int  data_nums;  
  vint indexs[N_SUBFRAMES][N_OFDM];

  void init_indexs(){
    for (int sid = 0; sid < N_SUBFRAMES; ++sid) {       // 10
      for (int rid = 0; rid < N_RB; ++rid) {            // 25
        Type            type = get_type(sid, rid);
        BlockTemplate_p btp  = block_tps[type];
        
        for (int oid = 0; oid < N_OFDM; ++oid) {        // 14
          for (int cid = 0; cid < N_SC; ++cid) {        // 12
            vint& ids=indexs[sid][oid];
            switch(btp[cid][oid]){
              case 1:
                ids.push_back(rid*N_SC+cid);
                ++data_nums;
                break;
              default:
                break;
            }
          }
        }
      }
    }
  }
};
