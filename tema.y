%{
	#include <stdio.h>
     	#include <string.h>

	int yylex();
	int yyerror(const char *msg);

     	int EsteCorecta = 0;
	
%}


%union { char* sir; int val;}
%locations
%token TOK_PROGRAM TOK_VAR TOK_BEGIN TOK_END TOK_id TOK_INTEGER TOK_int TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_ASSIGN TOK_ERROR

%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIV


%%

prog: TOK_PROGRAM prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END
    {
	EsteCorecta = 1;
    }
    ;
prog_name: TOK_id
	 ;
dec_list: dec
	| dec_list ';' dec
	;
dec: id_list ':' type
   ;
type: TOK_INTEGER
    ;
id_list: TOK_id
       | id_list ',' TOK_id
       ;
stmt_list: stmt
	 | stmt_list ';' stmt
	 ;
stmt: assign
    | read
    | write
    | for
    ;
assign: TOK_id TOK_ASSIGN exp
      ;
exp: term
   | exp '+' term
   | exp '-' term
   ;
term: factor
    | term TOK_MULTIPLY factor
    | term TOK_DIV factor
    ;
factor: TOK_id
      | TOK_int
      | '(' exp ')'
      ;
read: TOK_READ '(' id_list ')'
    ;
write: TOK_WRITE '(' id_list ')'
     ;
for: TOK_FOR index_exp TOK_DO body
   ;
index_exp: TOK_id TOK_ASSIGN exp TOK_TO exp
         ;
body: stmt
    | TOK_BEGIN stmt_list TOK_END
    ;

%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}
	else
	{
		printf("INCORECTA\n");
	}	

       return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}
