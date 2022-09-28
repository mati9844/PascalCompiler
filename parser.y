%{
#include "global.h"

using namespace std;

extern ArrayOfSymbols arrayOfSymbols;
extern Emitter emitter;
BlockDescription tmp_ArrayDescription;

bool error_occurred = false;
int offset = 8;

std::vector<int> identifiers_vector; //id identyfikatorow zmiennych (variables)
vector<int> parametersID; //id argumentow funkcji/procedury

int mapper(string op){
	if(op=="+") return ADD;
	if(op=="-") return SUB;
	if(op=="*") return MUL;
	if(op=="div" || op=="/") return DIV;
	if(op=="mod") return MOD;
	if(op=="=") return EQ;
	if(op=="<>") return NE;
	if(op==">") return G;
	if(op==">=") return GE;
	if(op=="<") return L;
	if(op=="<=") return LE;
	if(op=="or") return OR_OP;
	if(op=="and") return AND;
	if(op=="&") return AND_B; //todo
	if(op=="|") return OR_B; //todo
	if(op=="<<") return SHIFT_L; //todo
	if(op==">>") return SHIFT_R; //todo

	return -1;
}

%}

%token-table

%token PROGRAM
%token VARIABLE
%token ARRAY
%token OF

%token PROCEDURE
%token FUNCTION
%token BEG
%token END
%token NOT
%token IF
%token THEN
%token ELSE
%token DO
%token WHILE
%token WRITE
%token READ

%token ASSIGNOP
%token ADDOP
%token OR
%token RELOP
%token MULOP

%token REAL
%token INT
%token NUMBER
%token IDENTIFIER

%token NONE
%token LABEL
%token DONE

%%
program: 
	PROGRAM IDENTIFIER
	{
		emitter.write("jump.i\t#main", "jump.i main");
		arrayOfSymbols.symtable[$2].isGlobal = true;
		arrayOfSymbols.symtable[$2].token = PROCEDURE;
	} 
	'(' program_arguments ')' ';'
	global
	declarations
	{
		emitter.write("main");
	}
	BEG function_body END
	'.' DONE
	{
		emitter.write("exit\t","exit");
		return 0;
	};
	;

program_arguments: IDENTIFIER | program_arguments ',' IDENTIFIER;

global:
	global VARIABLE identifier_list ':' type ';'
	{
		if($5 != INT && $5 != REAL && $5 != ARRAY) {
			yyerror("Unknown type");
			YYERROR;
		}

		int i = 0;
		while(i<identifiers_vector.size()){
			arrayOfSymbols.updateSymbol(identifiers_vector.at(i),$5,VARIABLE, tmp_ArrayDescription, true); //isGlobal=TRUE
			i++;
		}
		identifiers_vector.clear();

	}
	| 
	;

type:
	standard_type  
	{
		tmp_ArrayDescription = BlockDescription();
	}
	| ARRAY '[' NUMBER '.' '.' NUMBER']' OF standard_type
	{
    		$$ = ARRAY;
		int firstValue;
		int lastValue;
		istringstream(arrayOfSymbols.getSymbolName($3)) >> firstValue;
		istringstream(arrayOfSymbols.getSymbolName($6)) >> lastValue;
		tmp_ArrayDescription = BlockDescription($3, firstValue, $6, lastValue, $9);

	}
	;
standard_type: INT | REAL;

identifier_list:
	IDENTIFIER
	{
		identifiers_vector.push_back($1);

	}
	| identifier_list ',' IDENTIFIER
	{
		identifiers_vector.push_back($3);
	}
	;

declarations:
	declarations functional ';' 
	| 
	;

functional:
	proc_fun
	{
		emitter.startFunction();
		arrayOfSymbols.setGlobalContext(LOCAL_CONTEXT);
	}
	local BEG function_body END
	{
		string temp_offset = to_string(arrayOfSymbols.getStackSize());
		arrayOfSymbols.addSymbol(Symbol(temp_offset, NUMBER, INT, arrayOfSymbols.isGlobalContext()));

		emitter.stopFunction(temp_offset);

		if(verbose_mode){
			arrayOfSymbols.print();
			cout << endl;
		}
		arrayOfSymbols.clearLocal();
		arrayOfSymbols.setGlobalContext(GLOBAL_CONTEXT);
	}
	/*
	|
	procedure
	{
		emitter.startFunction();
		arrayOfSymbols.setGlobalContext(LOCAL_CONTEXT);
	}
	local BEG function_body END
	{
		string temp_offset = to_string(arrayOfSymbols.getStackSize());
		arrayOfSymbols.addSymbol(Symbol(temp_offset, NUMBER, INT, arrayOfSymbols.isGlobalContext()));

		emitter.stopFunction(temp_offset);

		if(verbose_mode){
			arrayOfSymbols.print();
			cout << endl;
		}
		arrayOfSymbols.clearLocal();
		arrayOfSymbols.setGlobalContext(GLOBAL_CONTEXT);
	}*/
	;

proc_fun: function | procedure;

function:
	FUNCTION IDENTIFIER 
	{
		emitter.write(arrayOfSymbols.getSymbolName($2));
	}
	arguments ':' type ';'
	{

		arrayOfSymbols.updateSymbol($2,$6,FUNCTION, arrayOfSymbols.initArguments(parametersID));
		parametersID.clear();


		arrayOfSymbols.addSymbol(Symbol(arrayOfSymbols.getSymbolName($2), VARIABLE, $6, 8, false, true));
	}
	;

arguments:
	'(' parameter_list ')'
	{

		int i = parametersID.size() - 1;

		while(i>=0){
			offset += REFERENCESIZE;
			arrayOfSymbols.symtable[parametersID.at(i)].address = offset;
			i--;
		}

	}
	| 
	;

parameter_list:
	parametersGroup | ;

parametersGroup:
	parametersGroup ';' parameters | parameters ;

parameters:
	identifier_list ':' type 
	{
		if($3 != INT && $3 != REAL && $3 != ARRAY) {
			yyerror("Unknown type");
			YYERROR;
		}
		
		int i = 0;
		while(i<identifiers_vector.size()){
			arrayOfSymbols.updateSymbol(identifiers_vector.at(i),$3, VARIABLE, tmp_ArrayDescription, false, true);
			i++;
		}
		parametersID.insert(parametersID.end(), identifiers_vector.begin(), identifiers_vector.end());
		//appending a vector to a vector
		identifiers_vector.clear();

	};

procedure:
	PROCEDURE IDENTIFIER
	{
		emitter.write(arrayOfSymbols.getSymbolName($2));
		offset = 4;
	}
	arguments ';'
	{

		arrayOfSymbols.updateSymbol($2,NONE,PROCEDURE, arrayOfSymbols.initArguments(parametersID));

		parametersID.clear();
	}
	;

local:
	local VARIABLE identifier_list ':' type ';' 
	{

		if($5 != INT && $5 != REAL && $5 != ARRAY) {
			yyerror("Unknown type");
			YYERROR;
		}
		int i = 0;
		while(i<identifiers_vector.size()){
		        Symbol* sym = &arrayOfSymbols.symtable[identifiers_vector.at(i)];
		        sym->address = -1;
			arrayOfSymbols.updateSymbol(identifiers_vector.at(i),$5,VARIABLE, tmp_ArrayDescription, LOCAL_CONTEXT);

			if(sym->type == REAL)
			sym->address -= 8;
			else 
			sym->address -= 4;
			i++;
		}
		identifiers_vector.clear();
	}
	| 
	;

function_body:
	statement_list | ;

statement_list:
	statement_list ';' statement | statement ;

statement:
	variable ASSIGNOP simpler_expression
	{
		emitter.assign(arrayOfSymbols.symtable[$1], arrayOfSymbols.symtable[$3]);

	}
	| BEG function_body END
	| procedure_statement
	| WHILE
	{

		$1 = arrayOfSymbols.newLabel(); //utworzenie etykiety lbl1 i zapisanie jej id do $1
		$$ = arrayOfSymbols.newLabel(); //utworzenie etykiety lbl2 i zapisanie jej id do $$. Bedzie to ostatnia etykieta dla petli

		emitter.write(arrayOfSymbols.getSymbolName($1)); //wypisanie lbl1:


	}
	expression DO 
	{   
	

		int id_0_1 = arrayOfSymbols.addSymbol(Symbol("0", NUMBER, arrayOfSymbols.symtable[$2].type, arrayOfSymbols.isGlobalContext())); 
		//dodanie symbolu 0 w celu porownania z $t0  

		emitter.jump(arrayOfSymbols.symtable[$3], EQ, arrayOfSymbols.symtable[id_0_1], arrayOfSymbols.symtable[$2]); //Jezeli $t0 == 0 to skocz do lbl2

	}
	statement
	{

		emitter.jump(Symbol(), 0, Symbol(), arrayOfSymbols.symtable[$1], true); //wypisanie skoku do lbl1

		emitter.write(arrayOfSymbols.symtable[$2].name); //wypisanie lbl2:
	

	}
	| IF expression 
	{

		//$2 przechowuje informacje o tym czy warunek jest spelniony
		int then = arrayOfSymbols.newLabel(); //utworzenie lbl3

		int id_0_1 = arrayOfSymbols.addSymbol(Symbol("0", NUMBER, arrayOfSymbols.symtable[$2].type, arrayOfSymbols.isGlobalContext())); //utworzenie symbolu 0 w celu porownania z $t0

		emitter.jump(arrayOfSymbols.symtable[$2], EQ, arrayOfSymbols.symtable[id_0_1], arrayOfSymbols.symtable[then]); //Jezeli $t0 ($2) == 0 to skocz do lbl3

		$2 = then; // $2 przechowuje informacje, gdzie znajduje sie lbl3 w tablicy symboli
		
	}
	THEN statement
	{

		int else_ = arrayOfSymbols.newLabel(); //utworzenie lbl4
		emitter.jump(Symbol(), 0, Symbol(), arrayOfSymbols.symtable[else_], true); // wypisanie jump lbl4

		emitter.write(arrayOfSymbols.symtable[$2].name); //wypisanie lbl3:
		$4 = else_; //$4 przechowuje informacje, gdzie znajduje si lbl4 w tablicy symboli
	}
	ELSE statement
	{
		emitter.write(arrayOfSymbols.symtable[$4].name);
	}

	;

simpler_expression:
	term 
	| ADDOP term
	{
		$1 != SUB 
		? 
		$$ = $2
		:  
		$$ = emitter.addop(arrayOfSymbols.symtable[arrayOfSymbols.addSymbol(Symbol("0", NUMBER, arrayOfSymbols.symtable[$2].type, arrayOfSymbols.isGlobalContext()))], SUB, arrayOfSymbols.symtable[$2]);
		 

	}
	| simpler_expression OR term
	{
		$$ = emitter.addop(arrayOfSymbols.symtable[$1], OR_OP, arrayOfSymbols.symtable[$3]);
	}
	| simpler_expression ADDOP term
	{
		$$ = emitter.addop(arrayOfSymbols.symtable[$1], $2, arrayOfSymbols.symtable[$3]);
	}
	;

  
  
  
expression:
	simpler_expression 
	| simpler_expression RELOP simpler_expression
	{

		int boolean_0_1 = arrayOfSymbols.newTemp(INT); // zmienna pomocnicza $t0, ktora okresli czy warunek (expresion) zostal spelniony

		//if 1 then not go to else_label (example lbl3)

		int jump_if_true = arrayOfSymbols.newLabel(); //utworzenie etykiety lbl1 w ktorej pozniej ustawia sie zmienna pomocnicza na 1  $t0 := 1

		emitter.jump(arrayOfSymbols.symtable[$1], $2, arrayOfSymbols.symtable[$3], arrayOfSymbols.symtable[jump_if_true]);
		//if $1 RELOP($2) $3 then jump to label[jump_if_true]

		int id_false = arrayOfSymbols.addSymbol(Symbol("0", NUMBER, INT, arrayOfSymbols.isGlobalContext())); //dodanie symbolu 0, ktory bedzie mozna wykorzystac do ustawienia $t0 na 0 (gdy nie nastapi skok do lbl1, czyli gdy warunek nie zostal spelniony).
		 
		int finish_label = arrayOfSymbols.newLabel(); //utworzenie lbl2 w ktorej wykonujemy operacje dla opcji gdy warunek zostal spelniony czyli $t0 == 1 lub gdy nie zostal i wykonujemy operacje dla bloku else w lbl3

		emitter.assign(arrayOfSymbols.symtable[boolean_0_1], arrayOfSymbols.symtable[id_false]); //ustawienie $t0 = 0 (warunek niespelniony)
		emitter.jump(Symbol(), 0, Symbol(), arrayOfSymbols.symtable[finish_label], true); //jump z main do lbl2

		emitter.write(arrayOfSymbols.symtable[jump_if_true].name); //emit lbl1: (place where it sets boolean_0_1 value to 1)

		int id_true = arrayOfSymbols.addSymbol(Symbol("1", NUMBER, INT, arrayOfSymbols.isGlobalContext())); //dodanie symbolu 1, ktory bedzie mozna wykorzystac do ustawienia $t0 na 1 (wtedy w lbl2 nie skoczymy do lbl3, czyli nie skoczymy to bloku dla operacji else).
		
		emitter.assign(arrayOfSymbols.symtable[boolean_0_1], arrayOfSymbols.symtable[id_true]); ////ustawienie $t0 = 1 (warunek spelniony)
		emitter.write(arrayOfSymbols.symtable[finish_label].name); //emit lbl:2
		$$ = boolean_0_1;
	}
	;
  
term:
	factor 
	| term MULOP factor
	{
		$$ = emitter.mulop(arrayOfSymbols.symtable[$1], $2, arrayOfSymbols.symtable[$3]);
	}
	;

procedure_statement:
	IDENTIFIER 
	{
		if(arrayOfSymbols.getToken($1) == PROCEDURE){
			emitter.call(arrayOfSymbols.getSymbolName($1));
		}
    	
		if(arrayOfSymbols.getToken($1) == FUNCTION){

		int returnVariable = arrayOfSymbols.newTemp(arrayOfSymbols.getType($1));

		emitter.push(arrayOfSymbols.symtable[returnVariable], 
			arrayOfSymbols.newArg(arrayOfSymbols.getType($1), arrayOfSymbols.getBlockInfo($1)));

		emitter.call(arrayOfSymbols.getSymbolName($1));
		arrayOfSymbols.addSymbol(Symbol(to_string(4), NUMBER, INT, arrayOfSymbols.isGlobalContext()));
		emitter.incsp(4);
			
			
		}
        
	}
	| IDENTIFIER '(' expression_list ')'
	{

		int i = 0;
		int stackpointer = 0;

		int id = arrayOfSymbols.searchSymbol(arrayOfSymbols.getSymbolName($1), PROCEDURE);


		if(id==-1)
			id = arrayOfSymbols.searchSymbol(arrayOfSymbols.getSymbolName($1), FUNCTION);
		if(id==-1){
			yyerror((arrayOfSymbols.getSymbolName($1) + " was not found.").c_str());
			YYERROR;
		}

		if(arrayOfSymbols.getNumberOfArguments(id) != identifiers_vector.size()){
			yyerror((arrayOfSymbols.getSymbolName($1) + to_string(arrayOfSymbols.getNumberOfArguments($1))+" - problem with the number of arguments" + to_string(identifiers_vector.size())).c_str());
			YYERROR;
		}

		while(i<identifiers_vector.size()){
			emitter.push(arrayOfSymbols.symtable[identifiers_vector[i]], arrayOfSymbols.symtable[id].arguments[i]);
			i++;
			stackpointer += 4;
		}
		identifiers_vector.clear();

		if(arrayOfSymbols.getToken(id) == FUNCTION){
			int returnVariable = arrayOfSymbols.newTemp(arrayOfSymbols.getType(id));
			
			emitter.push(arrayOfSymbols.symtable[returnVariable], 
				arrayOfSymbols.newArg(arrayOfSymbols.getType(id), arrayOfSymbols.getBlockInfo(id)));
			$$ = returnVariable;
			stackpointer+=4;
		}

		emitter.call(arrayOfSymbols.getSymbolName($1));
		arrayOfSymbols.addSymbol(Symbol(to_string(stackpointer), NUMBER, INT, arrayOfSymbols.isGlobalContext()));
		emitter.incsp(stackpointer);
	}
	| write 
	| read 
	;

factor:
	variable
	| NUMBER
	| NOT factor
	{
		int temporaryINT = 0;
		int zero = 0;
		int negVal = 0;
		int stop = 0;
		int falseSym = 0;
		int trueSym = 1;


		if(arrayOfSymbols.getType($2) == REAL){
			temporaryINT = arrayOfSymbols.newTemp(INT);
			emitter.realToInt(arrayOfSymbols.symtable[$2], arrayOfSymbols.symtable[temporaryINT]);
			$2 = temporaryINT;
		}

		zero = arrayOfSymbols.newLabel();
		falseSym = arrayOfSymbols.addSymbol(Symbol("0", NUMBER, INT, arrayOfSymbols.isGlobalContext()));
		emitter.jump(arrayOfSymbols.symtable[$2], EQ, arrayOfSymbols.symtable[falseSym], arrayOfSymbols.symtable[zero]);

		stop = arrayOfSymbols.newLabel();
		negVal = arrayOfSymbols.newTemp(INT);
		emitter.assign(arrayOfSymbols.symtable[negVal], arrayOfSymbols.symtable[falseSym]);
		emitter.jump(Symbol(), 0, Symbol(), arrayOfSymbols.symtable[stop], true);

		emitter.write(arrayOfSymbols.symtable[zero].name); //write label1

		trueSym = arrayOfSymbols.addSymbol(Symbol("1", NUMBER, INT, arrayOfSymbols.isGlobalContext()));
		emitter.assign(arrayOfSymbols.symtable[negVal], arrayOfSymbols.symtable[trueSym]);
		emitter.write(arrayOfSymbols.symtable[stop].name);

		$$ = negVal;
	}
	| IDENTIFIER '(' expression_list ')'
	{
		int i = 0;
		int stackpointer = 0;

		int id = arrayOfSymbols.searchSymbol(arrayOfSymbols.getSymbolName($1), FUNCTION);
		//For example y:=f(4,2) then name of $1 is f. 4 and 2 are pushed arguments to emitter. It also pushes symbol for a result ($$).

		if(id==-1){
			yyerror((arrayOfSymbols.getSymbolName($1) + " was not found.").c_str());
			YYERROR;

		}

		if(arrayOfSymbols.getNumberOfArguments(id) != identifiers_vector.size()){
			yyerror((arrayOfSymbols.getSymbolName(id) + " - problem with the number of arguments").c_str());

			YYERROR;
		}

        
		while(i<identifiers_vector.size()){
			emitter.push(arrayOfSymbols.symtable[identifiers_vector[i]], arrayOfSymbols.symtable[id].arguments[i]);
			i++;
			stackpointer += 4;
		}
		identifiers_vector.clear();

		       
		int returnVariable = arrayOfSymbols.newTemp(arrayOfSymbols.getType(id));

		emitter.push(arrayOfSymbols.symtable[returnVariable], 
		arrayOfSymbols.newArg(arrayOfSymbols.getType(id), arrayOfSymbols.getBlockInfo(id)));
		$$ = returnVariable;
		stackpointer+=4;


		emitter.call(arrayOfSymbols.getSymbolName(id));
		arrayOfSymbols.addSymbol(Symbol(to_string(stackpointer), NUMBER, INT, arrayOfSymbols.isGlobalContext()));
		emitter.incsp(stackpointer);


	}
	| '(' expression ')'
	{

		$$ = $2;
	}
	;

variable:
	IDENTIFIER 
	{
		int resultVal = 0;

		if(arrayOfSymbols.getToken($1) == PROCEDURE || arrayOfSymbols.getToken($1) == FUNCTION){
			resultVal = arrayOfSymbols.newTemp(arrayOfSymbols.getType($1));
			emitter.push(arrayOfSymbols.symtable[resultVal], arrayOfSymbols.newArg(arrayOfSymbols.getType($1), 
				arrayOfSymbols.getBlockInfo($1)));
			
			emitter.call(arrayOfSymbols.getSymbolName($1));
			arrayOfSymbols.addSymbol(Symbol(to_string(4), NUMBER, INT, arrayOfSymbols.isGlobalContext()));
			emitter.incsp(4);
			$$ = resultVal;
		}
       
	}
	| IDENTIFIER '[' expression ']' 
	{

		int id = 0;
		if(arrayOfSymbols.getType($1) != ARRAY){
			yyerror((arrayOfSymbols.getSymbolName($1) + " - expected ARRAY").c_str());
			YYERROR;
		}

		if(arrayOfSymbols.getType($3) == ARRAY){
			yyerror((arrayOfSymbols.getSymbolName($3) + " - expected INT or REAL elements inside []").c_str());
			YYERROR;
		}

		//convert from real to int
		if(arrayOfSymbols.getType($3) == REAL){
			int tmp_id = arrayOfSymbols.newTemp(REAL);
			emitter.realToInt(arrayOfSymbols.symtable[$3], arrayOfSymbols.symtable[tmp_id]);
			
			id = emitter.addop(arrayOfSymbols.symtable[tmp_id], SUB,
				arrayOfSymbols.symtable[arrayOfSymbols.symtable[$1].blockDescription.firstID]);
			
		}else{
			id = emitter.addop(arrayOfSymbols.symtable[$3], SUB, arrayOfSymbols.symtable[arrayOfSymbols.symtable[$1].blockDescription.firstID]);
		}

		string t = (arrayOfSymbols.symtable[$1].blockDescription.dataType== REAL ? "#8" : "#4");

		emitter.write("mul.i\t" + emitter.adressFormat(arrayOfSymbols.symtable[id]) + ", "+ t + ", " + emitter.adressFormat(arrayOfSymbols.symtable[id]),
		"mul.i\t" + emitter.adressFormat(arrayOfSymbols.symtable[id], true) + ", "+ t + ", " + emitter.adressFormat(arrayOfSymbols.symtable[id], true));
		
		int element = emitter.addop(arrayOfSymbols.symtable[$1], ADD, arrayOfSymbols.symtable[id],true);
		arrayOfSymbols.symtable[element].isReference = true;
		$$ = element;

	}
	;

expression_list:
	expression_list ',' expression 
	{
		identifiers_vector.push_back($3);

	}
	| expression
	{
		identifiers_vector.push_back($1);
	}
	;                                                                                                          

read:
	READ '(' expression_list ')' 
	{

		int i = 0;
		while(i<identifiers_vector.size()){

			emitter.read(arrayOfSymbols.symtable[identifiers_vector[i]]);
			i++;
		}
		identifiers_vector.clear();
	}

write:
	WRITE '(' expression_list ')' 
	{

		int i = 0;
		while(i<identifiers_vector.size()){
			emitter.write(arrayOfSymbols.symtable[identifiers_vector[i]]);
			i++;
		}
		identifiers_vector.clear();

	}
%%


void yyerror(const char* error_type){
	error_occurred = true;
	printf("Error \"%s\" in line %d\n", error_type, linenumber);
}

string get_name(int t){
	return yytname[YYTRANSLATE(t)];
}



