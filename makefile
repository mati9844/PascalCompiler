program : parser.hpp parser.o symbol.o lexer.o emit.o main.o
	g++ -o program symbol.o parser.o lexer.o emitter.o main.o -lfl

lexer.o : lexer.cpp global.h
	g++ -c lexer.cpp

lexer.cpp : lexer.l global.h
	flex -o lexer.cpp lexer.l
	
symbol.o : symbol.cpp global.h
	g++ -c symbol.cpp

parser.cpp parser.hpp: parser.y
	bison -o parser.cpp -d parser.y

parser.o : parser.cpp global.h
	g++ -c parser.cpp

emit.o : emitter.cpp global.h
	g++ -c emitter.cpp

main.o : main.cpp global.h
	g++ -c main.cpp

clean : 
	-rm program 
	-rm parser.cpp
	-rm parser.hpp
	-rm lexer.cpp
	-rm *.o

clean_asm :
	-rm out/*.asm
