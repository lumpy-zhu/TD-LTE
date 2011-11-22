
#include <time.h>
#include <sys/time.h>
#include <stdio.h>


#define TIME_USE_GET_TIME  (tv[1].tv_sec-tv[0].tv_sec)*1000.0+(tv[1].tv_usec-tv[0].tv_usec)/1000.0

#define LUMPY_TIME_USE( fmt...)                                         \
  for( struct timeval tv[2]={};                                         \
       gettimeofday( &tv[0], 0),                                        \
           tv[1].tv_sec!=-1;                                            \
       gettimeofday( &tv[1], 0),                                        \
           printf("[%.6f]   ",TIME_USE_GET_TIME), printf(fmt), printf("\n"), \
           tv[1].tv_sec=-1                                              \
       )



#define CPU_TIME_USE_GET_TIME  (t[1]-t[0])/1000.0
#define LUMPY_CPU_TIME_USE( fmt...)                                     \
  for( int t[2]={};                                                     \
       t[0]=clock(), t[1]!=-1;                                          \
       t[1]=clock(),                                                    \
           printf("[%.6] ",CPU_TIME_USE_GET_TIME), printf(fmt) ,    printf("\n"), \
           t[1]=-1                                                      \
       )



#ifdef DISABLE_TIME_MEASURE
#	define	TIME_USE
#	define	CPU_TIME_USE
#else
#	define	TIME_USE		LUMPY_TIME_USE
#	define	CPU_TIME_USE	LUMPY_CPU_TIME_USE
#endif
