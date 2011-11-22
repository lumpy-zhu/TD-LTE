#include <stdlib.h>
#include <math.h>
#include <mex.h>

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
	double N_C;
	unsigned char *gold_seq;

	/* Check for proper number of arguments */
	if ((nrhs != 6 )||(nlhs  < 1)||(nlhs  > 2)) 
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
		N_C = *mxGetPr(prhs[5]);
    
		/* create the output vector */
		plhs[0] = mxCreateLogicalMatrix(1, len_output_seq);
		gold_seq = mxGetPr(plhs[0]);
		gold_seq[0] = 1;
	}
}