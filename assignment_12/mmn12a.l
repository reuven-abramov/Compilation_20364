%{
    #include <string.h>
    #include "definitions.h"
%}

%option noyywrap
%x COMMENT

%%
.+"\.ou"                        { return 1; }

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

"/*"                            { BEGIN(COMMENT); }
<COMMENT>"*/"                   { BEGIN(0); }
<COMMENT>\n                     { line++; }
<COMMENT>.

("=="|"!="|"<"|">"|">="|"<=")   { strcpy(yylval.op, yytext); return RELOP; }
("+"|"-")                       { strcpy(yylval.op, yytext); return ADDOP; }
("*"|"/")                       { strcpy(yylval.op, yytext); return MULOP; }
"||"                            { strcpy(yylval.op, yytext); return OR; }
"&&"                            { strcpy(yylval.op, yytext); return AND; }
"!"                             { strcpy(yylval.op, yytext); return NOT; }

[a-zA-Z][a-zA-Z0-9]*            { if(strlen(yytext) > 9) fprintf(stderr, "LINE:  %d\tERROR: ID \"%s\" is longer the 9 characters\n", line, yytext);
                                  else { strcpy(yylval.id, yytext); return ID; } }
([0-9]+|[0-9]+"."[0-9]+)        { yylval.num = atoi(yytext); return NUM; }

\n                              { line++; }
[\t ]+
.                               { fprintf(stderr, "LINE:  %d\tERROR: \"%c\" unrecognized token\n", line, yytext[0]); }

%%

main (int argc, char **argv) 
{
    int token;
    
    if (argc != 2)
    {
        printf("Usage: cla <input file name>\n");
        exit(1);
    }
    else if(!(argv[1][strlen(argv[1]) - 3] == '.' &&
        (argv[1][strlen(argv[1]) - 2] == 'o' || argv[1][strlen(argv[1]) - 2] == 'O') &&
        (argv[1][strlen(argv[1]) - 1] == 'u' || argv[1][strlen(argv[1]) - 1] == 'U')))
    {
        printf("Unrecognized file extension (should be .ou)\n");
        exit(1);
    }
    
    yyin = fopen(argv[1], "r");
    if(yyin == NULL)
    {
        printf("ERROR: File \"%s\" does not exist\n", argv[1]); 
        exit(1);
    }

    FILE *output = fopen("output.txt", "w");
    while ((token = yylex()) != 0)
        fprintf(output, "LINE:  %d\tTOKEN: %d\tLEXEME: %s\n", line, token, yytext);
    fclose(yyin);
    fclose(output);
    exit(0);
}