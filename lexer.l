%{
#include "global.h"

int linenumber = 1;
%}

%option noyywrap

delim [ \t]
letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
integer {digit}+
optional_fraction "."{integer}+
number {integer}{optional_fraction}?

assignop ":="
addop "-"|"+"
relop ">"|"<"|">="|"<="|"<>"|"="
mulop "*"|"/"|"div"|"mod"|"and"

%%
\r?\n		linenumber++;
{delim}		{}
program		{return PROGRAM;}
var		{return VARIABLE;}
integer		{yylval = INT; return INT;}
real		{yylval = REAL; return REAL;}
array		{return ARRAY;}
of		{return OF;}

procedure	{return PROCEDURE;}
function	{return FUNCTION;}
begin		{return BEG;}
end		{return END;}
write		{return WRITE;}
read		{return READ;}
not		{return NOT;}
or		{yylval = mapper(yytext); return OR;}
if		{return IF;}
then		{return THEN;}
else		{return ELSE;}
do		{return DO;}
while		{return WHILE;}




{assignop}	{return ASSIGNOP;}
{addop}		{yylval = mapper(yytext); return ADDOP;}
{mulop}		{yylval = mapper(yytext); return MULOP;}
{relop}		{yylval = mapper(yytext); return RELOP;}

{integer}	{yylval = arrayOfSymbols.addSymbol(Symbol(yytext, NUMBER, INT, arrayOfSymbols.isGlobalContext())); return NUMBER;}
{number}	{yylval = arrayOfSymbols.addSymbol(Symbol(yytext, NUMBER, REAL, arrayOfSymbols.isGlobalContext())); return NUMBER;}
{id}		{yylval = arrayOfSymbols.addSymbol(Symbol(yytext, IDENTIFIER, NONE, arrayOfSymbols.isGlobalContext())); return IDENTIFIER;}

<<EOF>>		{return DONE;}
.		{return *yytext;}
%%
