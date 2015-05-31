/*
 * Bootstrap execution of an LLVM program. 
 * Provides a C main program, which calls _CoolMain.
 *
 */
#include <stdio.h>

extern int _CoolMain();

int main(int argc, char **argv) {
  int status;
  printf("*** Beginning execution of Cool program ***\n");
  status =  _CoolMain( );  /* This might take an argument later */
  printf("*** Returned from Cool program with status %d ***\n", status);
  return 0; 
}
  