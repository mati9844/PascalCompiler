#!/bin/bash
make

for i in `ls ./test_programs`; do
	echo "Open $i"
	result=$(basename "test_programs/$i" ".pas")
	./program -v "$result.asm" < "test_programs/$i"
	echo ''
done
