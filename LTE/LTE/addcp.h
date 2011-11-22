#pragma once

#include "types.h"
#include <string.h>

inline void addcp(cfloat data[512], int tail_len){
  memcpy( data-tail_len, data+(512-tail_len), sizeof(cfloat)*tail_len);
}
