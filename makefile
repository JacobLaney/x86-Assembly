
default: demo_jpl_strcmp.o jpl_string.o
	clang -arch i386 demo_jpl_strcmp.o jpl_string.o -o demo_jpl_strcmp

demo_jpl_strcmp.o: jpl_string.h demo_jpl_strcmp.c
	clang -arch i386 -c demo_jpl_strcmp.c jpl_string.h
	
jpl_string.o: jpl_string.asm
	nasm -f macho32 jpl_string.asm

clean:
	rm -f jpl_string.o demo_jpl_strcmp.o demo_jpl_strcmp
