#!/bin/bash

mkdir -p build

echo "#define IPTOS_LOWDELAY 0" > src/config.h
cp src/modbus-version.h.in src/modbus-version.h
sed -i s/@LIBMODBUS_VERSION_MAJOR@/3/g src/modbus-version.h
sed -i s/@LIBMODBUS_VERSION_MINOR@/1/g src/modbus-version.h
sed -i s/@LIBMODBUS_VERSION_MICRO@/11/g src/modbus-version.h

for path in src/*.c
do
	filename=$(basename ${path})
	echo -n "Compiling " $filename "..."
	gcc -c ${path} -O2 -I src -fPIC -o build/${filename}.o
	if [ $? -eq 0 ]; then
		echo " OK"
	else
		echo " FAILED!"
		echo "Aborting..."
		exit 1
	fi
done

echo "Linking..."
gcc build/*.o --shared -o build/modbus.so

