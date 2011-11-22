#pragma once

#include "types.h"

void modulation(const vcint &data, vcfloat &symbol, int modorder);
void demod(const vcfloat &symbol, vcfloat &data, int modorder);
