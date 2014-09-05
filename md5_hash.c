/*
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

 */

#include "md5.h"
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
	you must free memory after result usage using free(void*)
*/
char * md5_hash(char * md5_string)
{
  int status = 0;

	md5_state_t state;
	md5_byte_t digest[16];
	char* hex_output = malloc(16*2 + 1);
	int di;

	md5_init(&state);
	md5_append(&state, (const md5_byte_t *)md5_string, strlen(md5_string));
	md5_finish(&state, digest);

	for (di = 0; di < 16; ++di)
	    sprintf(hex_output + di * 2, "%02x", digest[di]);

    return hex_output;
}
