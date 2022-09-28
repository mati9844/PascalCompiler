#include "global.h"
#include <iostream>
#include <string>
#include <algorithm>

using namespace std;
bool verbose_mode = false;

int main(int argc, char **argv){
string file_name = "file.asm";

	if(argc > 1 && string(argv[1]) == "-v" ||  string(argv[1]) == "--verbose"){
		verbose_mode = true;
	}
	
	if(argc >= 3){
		file_name = string(argv[2]);
	}
	
	yyparse();
	error_occurred == false ? printf("Successful compilation\n") : printf("Compilation error\n");
	
	if(verbose_mode){
		printf("Symbol table dump for main program:\n");
		arrayOfSymbols.print();
		cout << endl << "Content: " << endl;
		saveToFile("out/"+file_name);
		cout<<"Filename: " << file_name << endl;
	}
return 0;
}
