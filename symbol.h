#include <string>
#include <utility>

#define EMPTY_VALUE -505;

using namespace std;

class BlockDescription{

public:
	BlockDescription();
	BlockDescription(int firstID, int lastID, int firstValue, int lastValue, int dataType);
	~BlockDescription();
	
	int firstID = EMPTY_VALUE;
	int lastID = EMPTY_VALUE;
	int firstValue = EMPTY_VALUE;
	int lastValue = EMPTY_VALUE;
	int dataType = EMPTY_VALUE;


};

class Symbol{

public:
	Symbol();
	Symbol(string name, int token, int type, bool isGlobal = false, bool isReference = false);
	Symbol(string name, int token, int type, BlockDescription blockDescription, bool isGlobal = false, bool isReference = false);
	Symbol(string name, int token, int type, int address, bool isGlobal, bool isReference);
	~Symbol();
	string print();
	
	string name;
	int token;
	int type;
	int address;
	bool isGlobal;
	bool isReference = false;


	
	BlockDescription blockDescription;
	vector<Symbol> arguments;

};

class ArrayOfSymbols{

public:
	ArrayOfSymbols();
	~ArrayOfSymbols();
	
	vector<Symbol> initArguments(vector<int> ids_arguments);
	int searchSymbol(string name, int token = -1);
	string getSymbolName(int id);
	void updateSymbol(int id, int type, int token, BlockDescription blockDescription, bool isGlobal);
	void updateSymbol(int id, int type, int token, BlockDescription blockDescription, bool isGlobal, bool isReference);
	void updateSymbol(int id, int type, int token, vector<Symbol> ids_arguments);
	int addSymbol(Symbol symbol, bool force = false);
	int newTemp(int type);
	Symbol newArg(int type, BlockDescription blockDescription);
	int newLabel();
	void clearLocal();
	int isGlobalContext();
	void setGlobalContext(bool context);
	int getSizeOfSymbol(Symbol *symbol);
	int getToken(int id);
	int getType(int id);
	BlockDescription getBlockInfo(int id);
	int getNumberOfArguments(int id);
	int getStackSize();
	void print();
	int getAddress(string name);

	/*int REFERENCETYPESIZE = 4;
	int INTEGERTYPESIZE = 4;
	int REALTYPESIZE = 8;
	int NONETYPESIZE = 0;
*/

	vector<Symbol> symtable;
	Symbol EMPTY_SYMBOL;
	BlockDescription EMPTY_ARRAY;
	int globalContext = true;
	int tmps = 0; //counter for temporary variables
	int labels = 0; //counter for labels

	

};


