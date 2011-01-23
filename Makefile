all:	md5_hash.o md5.o
	gcc -shared -o libmd5varnish.so md5_hash.o md5.o

md5.o:	md5.c md5.h
	gcc -fPIC -c md5.c

md5_hash.o:	md5_hash.c md5_hash.h 
	gcc -fPIC -c md5_hash.c 

test:	test.o 
	gcc -o test test.o -L. -lmd5varnish 

test.o: test.c
		gcc -c test.c 

clean: 
		rm -f *.o *.so 
