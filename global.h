#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <string.h>
#include <vector>
#include "symbol.h"
#include "parser.hpp"

#define REFERENCESIZE 4
#define NONESIZE 0
#define INTEGERSIZE 4
#define REALSIZE 8

#define ERROR_CODE -666
#define GLOBAL_CONTEXT 1
#define LOCAL_CONTEXT 0


using namespace std;

extern int linenumber;
extern bool error_occurred;
extern bool verbose_mode;

extern ArrayOfSymbols arrayOfSymbols;

extern "C" int yylex();
int yylex_destroy();
int yyparse();
void yyerror(const char* error_type);
string get_name(int t);

enum op {ADD, SUB, MUL, DIV, MOD, EQ, NE, G, GE, L, LE, OR_OP, AND, AND_B, OR_B, SHIFT_L, SHIFT_R};
int mapper(string op);

void saveToFile(string file_name);

class Emitter{
	public:
	Emitter();
	~Emitter();
	
	stringstream stream;
	stringstream temporary_stream; //for function and procedure

	string adressFormat(Symbol symbol, bool transparent_mode = false, bool p_ref = false);
	void write(string a, string b = "");
	void write(Symbol symbol);
	void assign(Symbol destination, Symbol source);
	void push(Symbol arg, Symbol expected);
	void call(string function_name);
	void incsp(int bytes);
	void read(Symbol symbol);
	void intToReal(Symbol source, Symbol destination);
	void realToInt(Symbol source, Symbol destination);
	int mulop(Symbol r1, int op, Symbol r2);
	int addop(Symbol r1, int op, Symbol r2, bool pref = false);
	void jump(Symbol r1, int op, Symbol r2, Symbol label, bool force = false);
	void startFunction();
	void stopFunction(string offset);

};
extern Emitter emitter;

