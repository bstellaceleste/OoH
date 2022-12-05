sed -i 's/#define GD '$2'/#define GD '$3'/g' include/slimguard.h
make clean && make
cp libSlimGuard.so lib_$1.so
