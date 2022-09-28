#include "global.h"
#include <sstream>
#include <iostream>
#include <fstream>
#include <string>


Emitter emitter;
using namespace std;


Emitter::Emitter(){};
Emitter::~Emitter(){};

string Emitter::adressFormat(Symbol symbol, bool transparent_mode, bool p_ref){

	string ref = "";
	
	if(transparent_mode == true)
		return "$"+symbol.name;
	
	//Label or value detection
	if(symbol.token == LABEL || symbol.token == NUMBER){
		return "#" + symbol.name;
	}
	
	if(symbol.isReference || symbol.token == VARIABLE){
	
		if(symbol.isGlobal && symbol.type == ARRAY){
			if(p_ref == false)
				ref += "#";
			
		}
		
		if(symbol.isReference && (symbol.isGlobal == arrayOfSymbols.isGlobalContext())){
		
			if(!p_ref)
				ref += "*";
		}
		
		if(!symbol.isGlobal){
			string sign = symbol.address >= 0 ? "+" : "-";
			ref += "BP" + sign;
		}
		
		return (symbol.address >= 0 ? ref + to_string(symbol.address) : ref + to_string(symbol.address * -1));
  	}
  	
  	if(p_ref){
  		return to_string(symbol.address);
  	}
  	
  	return "";
}

void Emitter::write(string a, string b){

	//label
	if(b.empty()){
		stream << a + ":" << endl;
		return;
	}
	
	stream << "\t" << a << "\t;" << b << endl;
}

void Emitter::write(Symbol symbol){
	
	string t = (symbol.type == REAL ? "r" : "i");
	write("write." + t + "\t" + adressFormat(symbol), "write." + t + "\t" + adressFormat(symbol, true));
}


void Emitter::assign(Symbol destination, Symbol source){
	
	if(destination.type == REAL && (source.type == ARRAY || source.type == INT)){
		int id = arrayOfSymbols.newTemp(REAL);
		emitter.intToReal(source, arrayOfSymbols.symtable[id]);
		source = arrayOfSymbols.symtable[id];
		write("mov.r\t" + adressFormat(source) + ", " + adressFormat(destination), "mov.r\t" + adressFormat(source, true) + ", " + adressFormat(destination, true));
		return;
	}
	
	if((destination.type == INT || destination.type == ARRAY) && source.type == REAL){
		int id = arrayOfSymbols.newTemp(INT);
		emitter.realToInt(source, arrayOfSymbols.symtable[id]);
		source = arrayOfSymbols.symtable[id];
		write("mov.i\t" + adressFormat(source) + ", " + adressFormat(destination), "mov.i\t" + adressFormat(source, true) + ", " + adressFormat(destination, true));
		return;
	}
	
	if(destination.type == source.type){
		string type = destination.type == REAL ? "r" : "i";
		write("mov." + type + "\t" + adressFormat(source) + ", " + adressFormat(destination), "mov." + type + "\t" + adressFormat(source, true) + ", " + adressFormat(destination, true));
		return;
	}
	
	yyerror("Incompatible types error");
}

void Emitter::push(Symbol arg, Symbol expected){
	if(!(arg.type == expected.type && arg.blockDescription.firstValue == expected.blockDescription.firstValue && arg.blockDescription.lastValue == expected.blockDescription.lastValue)){
		if(expected.type == REAL && (arg.type == ARRAY || arg.type == INT)){
			int id = arrayOfSymbols.newTemp(REAL);
			emitter.intToReal(arg, arrayOfSymbols.symtable[id]);
			arg = arrayOfSymbols.symtable[id];
		}
		else if((expected.type == INT || expected.type == ARRAY) && arg.type == REAL){
			int id = arrayOfSymbols.newTemp(INT);
			emitter.realToInt(arg, arrayOfSymbols.symtable[id]);
			arg = arrayOfSymbols.symtable[id];
		}
		else if(expected.type == arg.type){
			string type = expected.type == REAL ? "r" : "i";
		}
		else{
			yyerror("Incompatible types error");
		}
	}
	
	if(arg.token == NUMBER){
		Symbol temp = arrayOfSymbols.symtable[arrayOfSymbols.newTemp(expected.type)];
		assign(temp, arg);
		arg = temp;
	}
	
	if(arg.isReference){
		write("push.i\t" + adressFormat(arg, false, true), "push.i\t&" + arg.name);
	}else{
		write("push.i\t#" + adressFormat(arg,false, true), "push.i\t&" + arg.name);
	}
}

void Emitter::call(string function_name){
	write("call.i\t#" + function_name, "call.i\t&" + function_name);
}

void Emitter::incsp(int bytes){
	write("incsp.i\t#" + to_string(bytes), "incsp.i\t" + to_string(bytes));
}


void Emitter::read(Symbol symbol){
	string t = (symbol.type == REAL ? "r" : "i");
	write("read." + t + "\t" + adressFormat(symbol), "read." + t + "\t" + adressFormat(symbol, true));
}

void Emitter::intToReal(Symbol source, Symbol destination){
	write("inttoreal.i\t" + adressFormat(source) + "," + adressFormat(destination), "inttoreal.i\t" + adressFormat(source, true) + "," + adressFormat(destination, true));
}

void Emitter::realToInt(Symbol source, Symbol destination){
	write("realtoint.r\t" + adressFormat(source) + "," + adressFormat(destination), "realtoint.r\t" + adressFormat(source, true) + "," + adressFormat(destination, true));
}


int Emitter::mulop(Symbol r1, int op, Symbol r2){

	string instr = "";
	if(op == MUL) instr = "mul";
	if(op == DIV) instr = "div";
	if(op == MOD) instr = "mod";
	if(op == AND) instr = "and";
	
  	if(((r1.type == INT || r1.type == ARRAY) && ((r2.type == INT) || r2.type == ARRAY))
	|| (r1.type == REAL && r2.type == REAL)){
		if(r1.type == r2.type){
			string t = (r1.type == REAL ? "r" : "i");
			int result = arrayOfSymbols.newTemp(r1.type);
			write(instr+"." + t + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
			instr+"." + t + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
			return result;
		}
		int result = arrayOfSymbols.newTemp(INT);
		write(instr + ".i" + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
		instr + ".i" + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
		return result;
	}
	if(r1.type == REAL && (r2.type == INT || r2.type == ARRAY)){
		int id = arrayOfSymbols.newTemp(REAL);
		emitter.intToReal(r2, arrayOfSymbols.symtable[id]);
		r2 = arrayOfSymbols.symtable[id];
		int result = arrayOfSymbols.newTemp(REAL);
		write(instr + ".r" + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
		instr + ".r" + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
		return result;
	}
	if((r1.type == INT || r1.type == ARRAY) && r2.type == REAL){
		int id = arrayOfSymbols.newTemp(REAL);
		emitter.intToReal(r1, arrayOfSymbols.symtable[id]);
		r1 = arrayOfSymbols.symtable[id];
		int result = arrayOfSymbols.newTemp(REAL);
		write(instr + ".r" + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
		instr + ".r" + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
		return result;
	}
	yyerror("Incompatible types error");

  return ERROR_CODE;

}
int Emitter::addop(Symbol r1, int op, Symbol r2, bool pref){

	string instr = "";
	if(op == ADD) instr = "add";
	if(op == SUB) instr = "sub";
	if(op == OR_OP) instr = "or";
	
  	if(((r1.type == INT || r1.type == ARRAY) && ((r2.type == INT) || r2.type == ARRAY))
	|| (r1.type == REAL && r2.type == REAL)){
		if(r1.type == r2.type){
			string t = (r1.type == REAL ? "r" : "i");
			int result = arrayOfSymbols.newTemp(r1.type);
			write(instr+"." + t + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
			instr+"." + t + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
			return result;
		}
		int result = arrayOfSymbols.newTemp(INT);
		write(instr + ".i" + "\t" + adressFormat(r1, false, pref) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
		instr + ".i" + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
		return result;
	}
	if(r1.type == REAL && (r2.type == INT || r2.type == ARRAY)){
		int id = arrayOfSymbols.newTemp(REAL);
		emitter.intToReal(r2, arrayOfSymbols.symtable[id]);
		r2 = arrayOfSymbols.symtable[id];
		int result = arrayOfSymbols.newTemp(REAL);
		write(instr + ".r" + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
		instr + ".r" + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
		return result;
	}
	if((r1.type == INT || r1.type == ARRAY) && r2.type == REAL){
		int id = arrayOfSymbols.newTemp(REAL);
		emitter.intToReal(r1, arrayOfSymbols.symtable[id]);
		r1 = arrayOfSymbols.symtable[id];
		int result = arrayOfSymbols.newTemp(REAL);
		write(instr + ".r" + "\t" + adressFormat(r1) + "," + adressFormat(r2) + "," + adressFormat(arrayOfSymbols.symtable[result]),
		instr + ".r" + "\t" + adressFormat(r1, true) + "," + adressFormat(r2, true) + "," + adressFormat(arrayOfSymbols.symtable[result], true));
		return result;
	}
	yyerror("Incompatible types error");

  return ERROR_CODE;
}


void Emitter::jump(Symbol r1, int op, Symbol r2, Symbol label, bool force){

	if(force){
	    write("jump.i\t" + adressFormat(label) + "\t", "jump.i\t" + adressFormat(label, true));
	    return;
	}
	
	string instr = "";
	if(op == EQ) instr = "je.";
	if(op == GE) instr = "jge.";
	if(op == LE) instr = "jle.";
	if(op == NE) instr = "jne.";
	if(op == G) instr = "jg.";
	if(op == L) instr = "jl.";
	
	string t = (r1.type == REAL || r2.type == REAL ? "r" : "i");
	write(instr + t + "\t" + adressFormat(r1) + ", " + adressFormat(r2) + ", " + adressFormat(label),
	instr + t + "\t" + adressFormat(r1, true) + ", " + adressFormat(r2, true) + ", " + adressFormat(label, true));

}

void Emitter::startFunction(){
	temporary_stream.clear();
	temporary_stream.str("");
	temporary_stream << stream.str();
	stream.clear();
	stream.str(string());
}

void Emitter::stopFunction(string offset){
	write("leave\t", "leave");
	write("return\t", "return");

	stringstream function;
	function << stream.str();
	stream.clear();
	stream.str("");
	stream = stringstream();
	stream.str(string());
	stream << temporary_stream.str();
	write("enter.i\t#" + offset + "\t", "enter.i\t#" + offset);
	stream << function.str();
}

void saveToFile(string file_name){
	ofstream file_stream;
	file_stream.open(file_name);
	file_stream << emitter.stream.str();
	file_stream.close();

	cout << emitter.stream.str() << endl;
}
