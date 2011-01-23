#include <stdio.h>
#include <stdlib.h>
#include "md5_hash.h" 

int main(argc,argv) {

   printf("%s\n",md5_hash("123 456 789 SECRET123")); 
   return 0;
}

