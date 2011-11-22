
#include "global.h"


void lte_tx(const vcint& code_data, IO &io){
  static FFTPlan	plan(512);  
  static Frame		frame;
  static vcfloat	mode_data;
  
  static cfloat*	pack_buff = plan.malloc(40+512);
  static cfloat*	pack_data = pack_buff+40;
  
  int                   send_size = 0;
  
  modulation(code_data, mode_data, MODORDER);

  for (int i = 0; i < mode_data.size(); i+=N_PDSCH) {
    frame.map(mode_data.data()+i);
	
    for (int id = 0; id < N_SUBFRAMES; ++id) {                  // 10
      for (int c = 0; c < N_OFDM; ++c) {                        // 14
        int tail_len=(c%7==0?40:36);
        cfloat *col=frame[id][c];
        
	if( id%7 !=2 && id%7 != 3){                             // down link
          frame.get_fftdata(id, c, pack_data);                  // 300->512
          plan.ifft(pack_data);                                 // ifft
          addcp(pack_data, tail_len);                           // +cp
        }
        
        io.send(pack_data-tail_len, tail_len+512);              // send
      }
    }
  }
}
