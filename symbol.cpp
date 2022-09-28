#include "global.h"

ArrayOfSymbols arrayOfSymbols;


using namespace std;


BlockDescription::BlockDescription(){}
BlockDescription::~BlockDescription(){}

BlockDescription::BlockDescription(int firstID, int lastID, int firstValue, int lastValue, int dataType){

	this->firstID = firstID;
	this->lastID = lastID;
	this->firstValue = firstValue;
	this->lastValue = lastValue;
	this->dataType = dataType;
}

Symbol::Symbol(){}
Symbol::~Symbol(){}

Symbol::Symbol(string name, int token, int type, bool isGlobal, bool isReference){

	this->name = name;
	this->token = token;
	this->type = type;
	this->isGlobal = isGlobal;
	this->isReference = isReference;

}

Symbol::Symbol(string name, int token, int type, BlockDescription blockDescription, bool isGlobal, bool isReference){

	this->name = name;
	this->token = token;
	this->type = type;
	this->isGlobal = isGlobal;
	this->isReference = isReference;
	this->blockDescription = blockDescription;

}


Symbol::Symbol(string name, int token, int type, int address, bool isGlobal, bool isReference){

	this->name = name;
	this->token = token;
	this->type = type;
	this->isGlobal = isGlobal;
	this->isReference = isReference;
	this->address = address;
}

string Symbol::print(){
	return this->name + ", token=" + get_name(this->token) + ", type=" + get_name(this->type);
}

vector<Symbol> ArrayOfSymbols::initArguments(vector<int> ids_arguments){
	vector<Symbol> temp;
	int i = 0;
	while(i<ids_arguments.size()){
		//cout << " ARGUMENTY " << arrayOfSymbols.symtable[ids_arguments.at(i)].name << endl;
		int type = arrayOfSymbols.symtable[ids_arguments.at(i)].type;
		temp.push_back(arrayOfSymbols.newArg(type, arrayOfSymbols.symtable[ids_arguments.at(i)].blockDescription));
		i++;
	}
	return temp;
		
}
ArrayOfSymbols::ArrayOfSymbols(){

	symtable.push_back(Symbol("read",PROCEDURE,NONE, true));
	symtable.push_back(Symbol("write",PROCEDURE,NONE, true));

}
ArrayOfSymbols::~ArrayOfSymbols(){}


int ArrayOfSymbols::searchSymbol(string name, int token){
	int i = symtable.size() - 1;
	while(i>0){
		if((symtable[i].name == name && symtable[i].token == token && token != -1) || (symtable[i].name == name && token == -1))
			return i;
		i--;
	}
	return -1;
}

string ArrayOfSymbols::getSymbolName(int id){
	return arrayOfSymbols.symtable[id].name;
}
void ArrayOfSymbols::updateSymbol(int id, int type, int token, BlockDescription blockDescription, bool isGlobal){
	Symbol* symbol = &arrayOfSymbols.symtable[id];
	symbol->address = arrayOfSymbols.getAddress(symbol->name);
	symbol->type = type;       
	symbol->token = token;
	symbol->isGlobal = isGlobal;
	symbol->blockDescription = blockDescription;
}

void ArrayOfSymbols::updateSymbol(int id, int type, int token, BlockDescription blockDescription, bool isGlobal, bool isReference){
	Symbol* symbol = &arrayOfSymbols.symtable[id];
	symbol->address = arrayOfSymbols.getAddress(symbol->name);
	symbol->type = type;
	symbol->token = token;
	symbol->isGlobal = isGlobal;
	symbol->blockDescription = blockDescription;
	symbol->isReference = isReference;
}

void ArrayOfSymbols::updateSymbol(int id, int type, int token, vector<Symbol> ids_arguments){
	Symbol* symbol = &arrayOfSymbols.symtable[id];
	symbol->type = type;
	symbol->token = token;
	symbol->arguments.assign(ids_arguments.begin(),ids_arguments.end());
}

int ArrayOfSymbols::addSymbol(Symbol symbol, bool force){
	if(force == false){
		int id = searchSymbol(symbol.name);
		if(symbol.isGlobal == symtable[id].isGlobal && id >= 0)
			return id;
		
	}

	symtable.push_back(symbol);
	return symtable.size() - 1;
}

int ArrayOfSymbols::newTemp(int type){

	Symbol symbol = Symbol("tmp" + to_string(tmps), VARIABLE, type, isGlobalContext());
	symbol.address = 0;
	int id = addSymbol(symbol, true);
	//symbol jest juz dodany dlatego pobieram jego adres
	symtable[id].address = getAddress(symbol.name);
	++tmps;
	return id;
}

Symbol ArrayOfSymbols::newArg(int type, BlockDescription blockDescription){

	Symbol symbol = Symbol("arg", NONE, type, blockDescription, isGlobalContext());
	symbol.address = 1000;
	return symbol;
}

int ArrayOfSymbols::newLabel(){
	return addSymbol(Symbol("lbl" + to_string(++labels), LABEL, NONE, isGlobalContext()));
}

void ArrayOfSymbols::clearLocal(){
	int i = symtable.size() - 1;
	while(!symtable[i].isGlobal && i > 0){
		symtable.pop_back();
		i--;
	}
}

int ArrayOfSymbols::isGlobalContext(){
	return globalContext;
}

void ArrayOfSymbols::setGlobalContext(bool context){
	globalContext = context;
}

int ArrayOfSymbols::getSizeOfSymbol(Symbol *symbol){
	if(symbol == nullptr)
		return ERROR_CODE;
		
	if(symbol->isReference == true){
		return REFERENCESIZE;
	}
	
	if(symbol->token == VARIABLE){
		if(symbol->type == ARRAY){
			return (symbol->blockDescription.dataType == INT ? INTEGERSIZE : REALSIZE) * (symbol->blockDescription.lastValue - symbol->blockDescription.firstValue + 1);
		}
		
		return symbol->type == REAL ? REALSIZE : INTEGERSIZE;
	}
	return NONESIZE;
}

int ArrayOfSymbols::getToken(int id){
	return arrayOfSymbols.symtable[id].token;
}
int ArrayOfSymbols::getType(int id){

	return arrayOfSymbols.symtable[id].type;

}

BlockDescription ArrayOfSymbols::getBlockInfo(int id){

	return arrayOfSymbols.symtable[id].blockDescription;
}

int ArrayOfSymbols::getNumberOfArguments(int id){
	return arrayOfSymbols.symtable[id].arguments.size();
}

int ArrayOfSymbols::getStackSize(){
	int address = 0;

	for (Symbol symbol : symtable){
		if(symbol.token == VARIABLE && symbol.isGlobal == false){
			address = symbol.address;
		}
	}

	if(address > 0){
		return 0;
	}
	
	return address * -1;
}

void ArrayOfSymbols::print(){
  
	for(int i = 0; i<symtable.size(); i++){
	  	string glob = !(symtable[i].isGlobal) ? "local" : "global";
	  	string ref = !(symtable[i].isReference) ? "" : "ref";
	  	string off = (symtable[i].token == ARRAY || symtable[i].token == VARIABLE) ? "offset = " + to_string(symtable[i].address) : "";
	  	cout << i << "\t" 
	  	<< glob << "\t"
	  	<< ref << "\t"
	  	<< get_name(symtable[i].token) << "\t"
	  	<< symtable[i].name << "\t"
	  	<< get_name(symtable[i].type) << "\t"
	  	<< off << endl;
	}
}

int ArrayOfSymbols::getAddress(string name){
	int i = 0;
	int addr = 0;
	while(i<symtable.size()){
		if(isGlobalContext() == LOCAL_CONTEXT){
			if(isGlobalContext() == symtable[i].isGlobal && symtable[i].address <= 0){
				addr = addr - getSizeOfSymbol(&symtable[i]);
			}
		}
		else if(symtable[i].name != name){
		
			addr = addr + getSizeOfSymbol(&symtable[i]);
		}
		i++;
	}
	return addr;
}


