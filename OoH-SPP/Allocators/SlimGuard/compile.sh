sed -i 's/#define GP '$2'/#define GP '$3'/g' include/slimguard.h
make clean && make
cp libSlimGuard.so lib_$1.so
