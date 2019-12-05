%{
    #include <string.h>
    #include "definitions.h"
%}

%option noyywrap

%%

"break"                         { return BREAK; }
"case"                          { return CASE; }
"default"                       { return DEFAULT; }
"else"                          { return ELSE; }
"float"                         { return FLOAT; }
"if"                            { return IF; }
"input"                         { return INPUT; }
"int"                           { return INT; }
"output"                        { return OUTPUT; }
"static_cast"                   { return STATIC_CAST; }
"switch"                        { return SWITCH; }
"while"                         { return WHILE; }

"("                             { return LFPAREN; }
")"                             { return RTPAREN; }
"{"                             { return LFBRACK; }
"}"                             { return RTBRACK; }
","                             { return COMMA; }
":"                             { return COLON; }
";"                             { return SEMCOLON; }
"="                             { return SET; }

("=="|"!="|"<"|">"|">="|"<=")   { strcpy(yylval.op, yytext); return RELOP; }
("+"|"-")                       { strcpy(yylval.op, yytext); return ADDOP; }
("*"|"/")                       { strcpy(yylval.op, yytext); return MULOP; }
"||"                            { strcpy(yylval.op, yytext); return OR; }
"&&"                            { strcpy(yylval.op, yytext); return AND; }
"!"                             { strcpy(yylval.op, yytext); return NOT; }

[a-zA-Z][a-zA-Z0-9]*            { if(strlen(yytext) > 9) printf("ERROR: ID cannot be longer the 9 characters\n");
                                  else strcpy(yylval.id, yytext); return ID; }
([0-9]+|[0-9]+"."[0-9]+)        { yylval.num = atoi(yytext); return NUM; }

\n                              { line++; }
[\t ]+
"/*".*"*/"
.                              { printf("unrecognized token %c\n", yytext[0]); }

%%

main (int argc, char **argv) 
{
    int token;

    if (argc != 2)
    {
        printf("Usage: mylex <input file name>\n");
        exit(1);
    }

    yyin = fopen(argv[1], "r");

    while ((token = yylex()) != 0)
        printf("LINE: %d\tTOKEN: %d\tLEXEME: %s\n", token, yytext);
    fclose(yyin);
    exit(0);
}