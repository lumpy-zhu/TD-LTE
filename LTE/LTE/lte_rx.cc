
#include "global.h"
#include "Buffer.h"
#include "MemIO.h"

//for half frame
void lte_rx_do(cfloat* frame_data, IO &out){
  static Frame		frame;
  static FFTPlan	plan(512);
  static cfloat*        fft_out=plan.malloc();

  //half frame, so N_PDSCH/2
  cfloat		data_x[N_PDSCH/2]; 
  cfloat		data_y[N_PDSCH/2];
  cfloat		data_h[N_PDSCH/2];

  cfloat *ptr=frame_data;

  for (int sid = 0; sid < 5; ++sid) {
    for (int i = 0; i < N_OFDM; ++i) {
      ptr += (i%7==0? 40:36);
      
      if (sid!=2 || sid!=3) continue;
      
      plan.fft(ptr, fft_out);                   // fft
      frame.set_fftdata(sid, i, fft_out);       // 512 -> 300
      
      ptr += 512;
    }
  }
  
  frame.demap(data_y);                          // demap   ----------------> y
  frame.channel_estimation();                   // channel estimation
  frame.demap(data_h);                          // demap   ----------------> h
  fde(data_y, data_h, data_x);                  // fde     ----------------> x = y / h   

  out.send(data_x, N_PDSCH/2);
}


/**
 * @param data          data recv from hardware
 * @param size          data length
 * @param sync_ok       if sync is ok
 * @param index         frame position,  this value is checked only if sync==true
 * @param out           out buffer
 * @return              how many bytes write to @param out
 */
int lte_rx(const cfloat* data, int size, bool sync_ok, uint64_t index, cfloat *out){
      
  static RxBuffer       buff(FRAME_SIZE*5,  FRAME_SIZE/2);
  static int            fail_try        = 0;
  static uint64_t       old_index       = 0;
  
  buff.push(data, size);

  if(sync_ok){
    old_index = index;
  }

  if (buff.has_data(old_index)) {
    MemIO       io(out);    
    lte_rx_do(&buff[old_index], io);
    old_index = 0ull;
    return N_PDSCH;
  }
  return 0;
}
