
all: demo_jpl_strcmp io writer clean

#######################################
demo_jpl_strcmp: demo_jpl_strcmp.o jpl_string.o
	clang -arch i386 demo_jpl_strcmp.o jpl_string.o -o demo_jpl_strcmp.out

demo_jpl_strcmp.o: jpl_string.h demo_jpl_strcmp.c
	clang -arch i386 -c demo_jpl_strcmp.c jpl_string.h

jpl_string.o: jpl_string.asm
	nasm -f macho32 jpl_string.asm
#######################################

#######################################
io: io.o headers.o
	clang -arch i386 headers.o io.o -o io.out

io.o: io.asm
	nasm -f macho32 io.asm 

headers.o: headers.c
	clang -c headers.c -arch i386
#######################################

#######################################
writer: writer.o
	ld writer.o -o writer

writer.o: writer.asm
	nasm -f macho64 writer.asm -o writer.o

#######################################

clean:
	rm -rf *.o
