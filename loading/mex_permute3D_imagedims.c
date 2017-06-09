/*------------------------------This is a MATLAB MEX function----------------------------------------
 
  [IMG_OUT] = MEX_PERMUTE3D_IMAGEDIMS(IMG_IN,DIMS_IN,FIXED_PARAMS)
  
  Description:
  This function returns an image with dimensions permuted according to DIMS
  
  Input : IMG_IN          --> 3D array image  (LENGTH X WIDTH X HEIGHT) 
          DIMS_IN         --> 1D vector according to which the dimensions of the image are permuted (1 X 3)
                              DIMS_IN(i) \in {1,2,3}  for i = 1,2,3
                              DIMS_IN(i) \neq DIMS_IN(j) for i \neq j
          FIXED_PARAMS    --> 1D array of parameters [LENGTH WIDTH HEIGHT]

  Output: IMG_OUT         --> permuted image (size(IMG_IN,DIMS(1)) X size(IMG_IN,DIMS(2)) X size(IMG_IN,DIMS(3))) 
                  
                  
                  
 --------------------------------------------------------------------------------------------------*/
#include<stdio.h>
#include<math.h>

/*Change the following line based on the PATH/TO/MEX.H on your system*/
#include"mex.h"

/*Input Arguments*/
#define IMG_IN		prhs[0]
#define DIMS_IN         prhs[1]
#define FIXED_PARAMS    prhs[2]

/*Output Arguments*/
#define IMG_OUT         plhs[0]


#ifndef max
#define max(a,b) (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif




void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  int LENGTH; int WIDTH; int HEIGHT; 
  int LENGTH_dash; int WIDTH_dash; int HEIGHT_dash;
  double *img_out_ptr; double *img_in_ptr;double *dims_in_ptr;double *params_ptr; 
  int  i, j, k;
  int i_dash, j_dash, k_dash;
  int dims_out[3];

  /*Get the dimensions of phi*/
  params_ptr   = mxGetPr(FIXED_PARAMS);
  LENGTH       = (int)*(params_ptr);
  WIDTH        = (int)*(params_ptr+1);
  HEIGHT       = (int)*(params_ptr+2);

  /*get the img*/
  img_in_ptr= mxGetPr(IMG_IN);
  
  /*get dims*/
  dims_in_ptr= mxGetPr(DIMS_IN);

  LENGTH_dash = (int)*(params_ptr + (int)(*(dims_in_ptr + 0)-1));
  WIDTH_dash  = (int)*(params_ptr + (int)(*(dims_in_ptr + 1)-1));
  HEIGHT_dash = (int)*(params_ptr + (int)(*(dims_in_ptr + 2)-1));

  dims_out[0] = LENGTH_dash;
  dims_out[1] = WIDTH_dash;
  dims_out[2] = HEIGHT_dash;
  
  IMG_OUT = mxCreateNumericArray(3,dims_out,mxDOUBLE_CLASS,mxREAL);
  img_out_ptr = mxGetPr(IMG_OUT);

  	     
  if ( (*(dims_in_ptr + 0)-1) == 0 && (*(dims_in_ptr + 1)-1) == 1 && (*(dims_in_ptr + 2)-1) == 2)
    {
      for (i = 0; i < LENGTH; i++)
	{
	  for (j = 0; j < WIDTH; j++) 
	    {
	      for (k = 0; k < HEIGHT; k++) 
		{
		  *(img_out_ptr + i + LENGTH*j + LENGTH*WIDTH*k) = 
		    *(img_in_ptr + i + LENGTH*j + LENGTH*WIDTH*k); 
		}
	    }
	}
    }
  
  if ( (*(dims_in_ptr + 0)-1) == 0 && (*(dims_in_ptr + 1)-1) == 2 && (*(dims_in_ptr + 2)-1) == 1)
    {
      for (i = 0; i < LENGTH; i++)
	{
	  for (j = 0; j < WIDTH; j++) 
	    {
	      for (k = 0; k < HEIGHT; k++) 
		{
		  *(img_out_ptr + i + LENGTH*k + LENGTH*HEIGHT*j) = 
		    *(img_in_ptr + i + LENGTH*j + LENGTH*WIDTH*k); 
		}
	    }
	}
    }
  
  if ( (*(dims_in_ptr + 0)-1) == 1 && (*(dims_in_ptr + 1)-1) == 0 && (*(dims_in_ptr + 2)-1) == 2)
    {
      for (i = 0; i < LENGTH; i++)
	{
	  for (j = 0; j < WIDTH; j++) 
	    {
	      for (k = 0; k < HEIGHT; k++) 
		{
		  *(img_out_ptr + j + WIDTH*i + WIDTH*LENGTH*k) = 
		    *(img_in_ptr + i + LENGTH*j + LENGTH*WIDTH*k); 
		}
	    }
	}
    }

  if ( (*(dims_in_ptr + 0)-1) == 1 && (*(dims_in_ptr + 1)-1) == 2 && (*(dims_in_ptr + 2)-1) == 0)
    {
      for (i = 0; i < LENGTH; i++)
	{
	  for (j = 0; j < WIDTH; j++) 
	    {
	      for (k = 0; k < HEIGHT; k++) 
		{
		  *(img_out_ptr + j + WIDTH*k + WIDTH*HEIGHT*i) = 
		    *(img_in_ptr + i + LENGTH*j + LENGTH*WIDTH*k);
		}
	    }
	} 
    }
  
  if ( (*(dims_in_ptr + 0)-1) == 2 && (*(dims_in_ptr + 1)-1) == 0 && (*(dims_in_ptr + 2)-1) == 1)
    {
      for (i = 0; i < LENGTH; i++)
	{
	  for (j = 0; j < WIDTH; j++) 
	    {
	      for (k = 0; k < HEIGHT; k++) 
		{
		  *(img_out_ptr + k + HEIGHT*i + HEIGHT*LENGTH*j) = 
		    *(img_in_ptr + i + LENGTH*j + LENGTH*WIDTH*k); 
		}
	    }
	}
    }
  
  if ( (*(dims_in_ptr + 0)-1) == 2 && (*(dims_in_ptr + 1)-1) == 1 && (*(dims_in_ptr + 2)-1) == 0)
    {
      for (i = 0; i < LENGTH; i++)
	{
	  for (j = 0; j < WIDTH; j++) 
	    {
	      for (k = 0; k < HEIGHT; k++) 
		{
		  *(img_out_ptr + k + HEIGHT*j + HEIGHT*WIDTH*i) = 
		    *(img_in_ptr + i + LENGTH*j + LENGTH*WIDTH*k); 
		}
	    }
	}
    }
}
