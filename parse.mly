%{
(* 
 * Parser for our IMP concrete syntax. 
 * See http://caml.inria.fr/pub/docs/manual-ocaml/manual026.html
 * but basically it works just like Yacc/Bison.
 * See http://en.wikipedia.org/wiki/YACC
 *)

open Imp		    (* IMP abstract syntax *)

let error msg	= failwith msg

%}

%token <string>         IDENTIFIER
%token <int>            INT

%token PLUS 
%token MINUS 
%token TIMES 
%token DIV 
%token MOD 
%token TRUE
%token FALSE
%token EQ_TOK
%token LE_TOK
%token NOT
%token AND
%token OR 
%token SKIP
%token SET 
%token SEMICOLON
%token IF
%token THEN
%token ELSE
%token WHILE
%token DO 
%token PRINT
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token QUOTE
%token DECLAREINT
%token DECLAREPROTO
%token END
%token PERIOD


%token EOF

%start com
%type <Imp.com> com

%left AND
%left OR
%left PLUS MINUS
%left TIMES
%left LE_TOK EQ_TOK
%nonassoc NOT

%%

aexp : INT                                   { Const($1) }
| IDENTIFIER                                 { Var($1) }
| aexp PLUS aexp                             { Add ($1,$3) } 
| aexp MINUS aexp                            { Sub ($1,$3) } 
| aexp TIMES aexp                            { Mul ($1,$3) } 
| aexp DIV aexp                              { Div ($1,$3) } 
| aexp MOD aexp                              { Mod ($1,$3) } 
| LPAREN aexp RPAREN                         { $2 } 
;

bexp : TRUE                                  { True }
| FALSE                                      { False }
| aexp EQ_TOK aexp                           { EQ ($1,$3) }
| aexp LE_TOK aexp                           { LE($1,$3) }
| NOT bexp                                   { Not($2) }
| bexp AND bexp                              { And($1,$3)  }
| bexp OR bexp                               { Or($1,$3) }
| LPAREN bexp RPAREN                         { $2 }
;

com : SKIP                                   { Skip }
| IDENTIFIER SET aexp                        { Set($1,$3) } 
| com SEMICOLON com                          { Seq($1,$3) }
| IF bexp THEN com END			     { If($2,$4) }
| IF bexp THEN com END ELSE com END          { Ifelse($2,$4,$7) }
| WHILE bexp DO com                          { While($2,$4) }
| PRINT aexp                                 { Print($2) }
| LBRACE com RBRACE                          { $2 } 
| DECLAREINT IDENTIFIER			     { Declareint($2) }
| DECLAREPROTO IDENTIFIER QUOTE IDENTIFIER PERIOD IDENTIFIER QUOTE QUOTE IDENTIFIER QUOTE { Declareproto($2,$4,$9) } 
;
