#Add the following to your Varnish 4 vcl file
#In varnish 4 inlice C disabled by default. You must enable it using -p vcc_allow_inline_c=true 

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
        //\6X-MD5: - \6 is length of string in octal encoding
        static const struct gethdr_s VGC_HDR_REQ_VARNISH_X_MD5 = {
            HDR_REQ, "\6X-MD5:"
        };


        static const struct gethdr_s VGC_HDR_REQ_VARNISH_X_DIGEST = {
            HDR_REQ, "\24X-MD5-Digest-String:"
        };

        char* md5DigestString = VRT_GetHdr(ctx, &VGC_HDR_REQ_VARNISH_X_DIGEST);
        const char* calculatedMD5 = (*md5_hash)(md5DigestString);
        VRT_SetHdr(ctx, &VGC_HDR_REQ_VARNISH_X_MD5, calculatedMD5, vrt_magic_string_end);
        free((char*)calculatedMD5);
    }C


}
