#include<stdio.h>
#include<stdlib.h>

#define NT 9 /// number of coeffs
#define NB 8 /// number of bits

const int b[NT]={-1, -2, 6, 34, 51, 34, 6, -2, -1}; /// b coefficients array

/// Perform fixed point filtering assuming FIR direct form I
/// param x is the new input sample
/// return the new output sample
int myfilter(int x)
{
  static int sx[NT]; /// samples shift register
  static int first_run = 0; /// for cleaning shift registers
  int i; /// index
  int y; /// output sample

  /// clean the buffers in first run
  if (first_run == 0)
  {
    first_run = 1;
    for (i=0; i<NT; i++)
      sx[i] = 0;
  }

  /// shift and insert new sample in samples shift register
  for (i=NT-1; i>0; i--)
    sx[i] = sx[i-1];
  sx[0] = x;

  /// computing output sample
  y = 0;
  for (i=0; i<NT; i++)
    y += (sx[i]*b[i]) >> (NB);
    /// output samples are divided by 2^(NB) to represent them on a given number of bits
    /// (internal parallelism)

  return y;
}

int main (int argc, char **argv)
{
  FILE *fp_in; /// input samples
  FILE *fp_out; /// output samples

  int x;
  int y;

  /// check the command line
  if (argc != 3)
  {
    printf("Use: %s <input_file> <output_file>\n", argv[0]);
    exit(1);
  }

  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n");
    exit(2);
  }
  fp_out = fopen(argv[2], "w");

  /// get samples and apply filter one by one
  fscanf(fp_in, "%d", &x);
  do{
    y = myfilter(x);
    fprintf(fp_out,"%d\n", y);
    fscanf(fp_in, "%d", &x);
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);

  return 0;

}
