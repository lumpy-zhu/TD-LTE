#pragma once

enum TDLTE_SIZE{
  N_SUBFRAMES           = 10,
  N_SC                  = 12,
  N_OFDM                = 14,
  N_RB                  = 25,
  N_MAX_RB      	= 110,

  N_PSS                 = 62,
  N_CRS                 = 50,
  
  PBCH_VAL      	= 1,
  PDCCH_VAL     	= 2,

  FRAME_SIZE            = ((512*7+40+36*6) * 2) * N_SUBFRAMES,
  
};




enum TDLTE_ARGUMENT{
  N_CP                  = 1,    //normal cp     [0,1]
  N_CELL_ID		= 0,  
  MODORDER              = 2,
};



extern int N_PDSCH;


