#pragma once

/* sys-header */
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <assert.h>
#include <stdio.h>

/* types */
#include "types.h"
#include "time.h"
#include "fft.h"
#include "print.h"

/* lte headers */
#include "Frame.h"
#include "fde.h"
#include "addcp.h"
#include "modulation.h"

/* utils */
#include "IO.h"
#include "fft.h"


/* funcs */
void lte_tx(const vcint &code_data, IO &io);
int lte_rx(const cfloat* data, int size, bool sync_ok, uint64_t index, cfloat *out);

