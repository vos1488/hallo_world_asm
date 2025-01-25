.PHONY: all clean rebuild run

all: hello

rebuild: clean all

run: hello
	./hello

hello: hello.o
	ld -o hello hello.o \
		-macosx_version_min 11.0 \
		-L$(shell xcrun --show-sdk-path)/usr/lib \
		-lSystem \
		-no_pie \
		-e _main

hello.o: hello.asm
	nasm -f macho64 hello.asm -DMACHO64 -g -F dwarf

clean:
	rm -f hello hello.o