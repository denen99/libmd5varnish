#Add the following to your vcl file 

C{
  #include <dlfcn.h>
  #include <stdlib.h>
  #include <stdio.h>

static const char* (*md5_hash)(char* str) = NULL;

__attribute__((constructor)) void
load_module()
{
        const char* symbol_name = "md5_hash";
        const char* plugin_name = "/etc/varnish/modules/md5/libmd5varnish.so";
        void* handle = NULL;

        handle = dlopen( plugin_name, RTLD_NOW );
        if (handle != NULL) {
                md5_hash = dlsym( handle, symbol_name );
                if (md5_hash == NULL)
                        fprintf( stderr, "\nError: Could not load MD5 plugin:\n%s\n\n", dlerror() );
                else
                        printf( "MD5 plugin loaded successfully.\n");
        }
        else
                fprintf( stderr, "\nError: Could not load MD5 plugin:\n%s\n\n", dlerror() );
}
}C

## An Example of How to use it in vcl_recv
#
sub vcl_recv { 

 C{
     VRT_SetHdr(sp, HDR_REQ, "\006X-MD5:", (*md5_hash)("some string of choice"), vrt_magic_string_end);
  }C


}
