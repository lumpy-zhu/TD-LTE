#pragma once

#include <stdio.h>
#include "types.h"

#define vector_view(array, fmt)                 \
  ({                                            \
    printf("%s=\n", #array);                    \
    for (int i = 0; i < array.size(); ++i){     \
      printf(fmt, array[i]);                    \
    }                                           \
    printf("\n");                               \
  })


#define cvector_view(array, fmt)                \
  ({                                            \
    printf("%s=\n", #array);                    \
    for (int i = 0; i < array.size(); ++i){     \
      printf(fmt, array[i].r, array[i].i);      \
    }                                           \
    printf("\n");                               \
  })


#define matrix_view(matrix, fmt)                \
  ({                                            \
    printf("%s=\n", #matrix);                   \
    for (int r = 0; i < matrix.rows; ++r)       \
      for (int c = 0; c < matrix.cols; ++c) {   \
        printf(fmt, matrix[r][c]);              \
      }                                         \
    printf("\n");                               \
  })



#define subframe_view(sframe, fmt)              \
  ({                                            \
    printf("==%s==\n", #sframe);                \
    for (int r = 0; r < sframe.rows; ++r) {     \
      printf("%2d.%2d|  ", r/12,r%12);          \
      for (int c = 0; c < sframe.cols; ++c) {   \
        printf(fmt,                             \
               sframe[c][r].r,                  \
               sframe[c][r].i);                 \
      }                                         \
      printf("\n");                             \
    }                                           \
    printf("\n");                               \
    getchar();                                  \
  })
