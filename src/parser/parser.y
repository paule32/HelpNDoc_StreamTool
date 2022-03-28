%{
#include "misc.hh"

int yylex(); 
int yywrap() { return 1; }

extern int yyerror(const char*);
%}

//-- SYMBOL SEMANTIC VALUES -----------------------------
%union {
  uint64_t val_int64;
  char*    val_charp;
};

%start program
//-- GRAMMAR RULES ---------------------------------------

%token <val_int64> TOK_NUMBER

%%

program: /* empty */ ;
	
%%
