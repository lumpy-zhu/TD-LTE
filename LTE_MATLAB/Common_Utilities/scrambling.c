#include <stdlib.h>
#include <math.h>
#include <mex.h>

#define	MAX_LEN_PLHS	100000
#define N_C				1600

void mexFunction(
				 int            nlhs,
				 mxArray       *plhs[],
				 int            nrhs,
				 const mxArray *prhs[] )
{

	mwSize len_output_seq;
	double n_RNTI;
	double q;
	double n_subframe;
	double n_cellID;
	unsigned char *gold_seq;
	int	poly_order = 31;
	int len_seq_x; 
	unsigned char x1[31 + MAX_LEN_PLHS + N_C];
	unsigned char x2[31 + MAX_LEN_PLHS + N_C];
	double c_init;
	long i;
	/* PN register state of the first m-seqence */  
	


	/* Check for proper number of arguments */
	if ((nrhs != 5 )||(nlhs  < 1)||(nlhs  > 2)) 
	{
		mexErrMsgTxt("Incorrect usage!");
	} 
	else 
	{
		/* Get input parameters */
		len_output_seq = (mwSize) (*mxGetPr(prhs[0]));
		n_RNTI = *mxGetPr(prhs[1]);
		q = *mxGetPr(prhs[2]);
		n_subframe = *mxGetPr(prhs[3]);
		n_cellID = *mxGetPr(prhs[4]);
		
				
		/* create the output vector */
		plhs[0] = mxCreateLogicalMatrix(1, len_output_seq);
		gold_seq = mxGetPr(plhs[0]);
		c_init = pow(2, 14) * n_RNTI + pow(2, 13) * q + pow(2, 9) * ((int) n_subframe/2) + n_cellID;
		
		/* PN register state of the second m-seqence */ 
		
		len_seq_x = 31 + MAX_LEN_PLHS + N_C;
		for(i = 0 ; i < len_seq_x ; i++)
		{
			x1[i] = 0;
			x2[i] = 0;
		}
		/* initial state of first sequence */
		x1[0] = 1;
		
		/* initial state of second sequence */
		for(i = 30 ; i >= 0 ; i--)
		{
			x2[i] = c_init / pow(2,i);
			c_init = c_init - x2[i] * pow(2,i);
		}
		
		for (i = 0; i < len_output_seq + N_C ; i++) 
		{
			if(i >= N_C)
				gold_seq[i - N_C] = x1[i] ^ x2[i];
			x1[i + poly_order] = x1[i] ^ x1[i + 3];
			x2[i + poly_order] = (x2[i] ^ x2[i + 1]) ^ (x2[i + 2] ^ x2[i + 3]);
		}
		
	}
}