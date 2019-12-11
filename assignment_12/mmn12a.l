%{
    #include <string.h>
    #include "definitions.h"
%}

%option noyywrap
%x COMMENT

%%

"break"                         { strcpy(tokenName, "BREAK"); strcpy(tokenDescription, "break keyword"); return BREAK; }
"case"                          { strcpy(tokenName, "CASE"); strcpy(tokenDescription, "case keyword"); return CASE; }
"default"                       { strcpy(tokenName, "DEFAULT"); strcpy(tokenDescription, "default keyword"); return DEFAULT; }
"else"                          { strcpy(tokenName, "ELSE"); strcpy(tokenDescription, "else keyword"); return ELSE; }
"float"                         { strcpy(tokenName, "FLOAT"); strcpy(tokenDescription, "float keyword"); return FLOAT; }
"if"                            { strcpy(tokenName, "IF"); strcpy(tokenDescription, "if keyword"); return IF; }
"input"                         { strcpy(tokenName, "INPUT"); strcpy(tokenDescription, "input keyword"); return INPUT; }
"int"                           { strcpy(tokenName, "INT"); strcpy(tokenDescription, "int keyword"); return INT; }
"output"                        { strcpy(tokenName, "OUTPUT"); strcpy(tokenDescription, "output keyword"); return OUTPUT; }
"static_cast"                   { strcpy(tokenName, "STATIC_CAST"); strcpy(tokenDescription, "static_cast keyword"); return STATIC_CAST; }
"switch"                        { strcpy(tokenName, "SWITCH"); strcpy(tokenDescription, "switch keyword"); return SWITCH; }
"while"                         { strcpy(tokenName, "WHILE"); strcpy(tokenDescription, "while keyword"); return WHILE; }

"("                             { strcpy(tokenName, "LFPAREN"); strcpy(tokenDescription, "Left ‏parentheses symbol"); return LFPAREN; }
")"                             { strcpy(tokenName, "RTPAREN"); strcpy(tokenDescription, "Right ‏parentheses symbol"); return RTPAREN; }
"{"                             { strcpy(tokenName, "LFBRACK"); strcpy(tokenDescription, "Left brackets symbol"); return LFBRACK; }
"}"                             { strcpy(tokenName, "RTBRACK"); strcpy(tokenDescription, "Right brackets symbol"); return RTBRACK; }
","                             { strcpy(tokenName, "COMMA"); strcpy(tokenDescription, "Comma symbol"); return COMMA; }
":"                             { strcpy(tokenName, "COLON"); strcpy(tokenDescription, "Colon symbol"); return COLON; }
";"                             { strcpy(tokenName, "SEMCOLON"); strcpy(tokenDescription, "Semi-colon symbol"); return SEMCOLON; }
"="                             { strcpy(tokenName, "SET"); strcpy(tokenDescription, "Set symbol"); return SET; }

"/*"                            { BEGIN(COMMENT); }
<COMMENT>"*/"                   { BEGIN(0); }
<COMMENT>\n                     { line++; }
<COMMENT>.

("=="|"!="|"<"|">"|">="|"<=")   { strcpy(tokenName, "RELOP"); strcpy(tokenDescription, "Relational operator"); strcpy(yylval.op, yytext); return RELOP; }
("+"|"-")                       { strcpy(tokenName, "ADDOP"); strcpy(tokenDescription, "Addition operator"); strcpy(yylval.op, yytext); return ADDOP; }
("*"|"/")                       { strcpy(tokenName, "MULOP"); strcpy(tokenDescription, "Multiplication operator"); strcpy(yylval.op, yytext); return MULOP; }
"||"                            { strcpy(tokenName, "OR"); strcpy(tokenDescription, "Or operator"); strcpy(yylval.op, yytext); return OR; }
"&&"                            { strcpy(tokenName, "AND"); strcpy(tokenDescription, "And operator"); strcpy(yylval.op, yytext); return AND; }
"!"                             { strcpy(tokenName, "NOT"); strcpy(tokenDescription, "Not operator"); strcpy(yylval.op, yytext); return NOT; }

[a-zA-Z][a-zA-Z0-9]*            { if(strlen(yytext) > 9) fprintf(stderr, "LINE:  %d\tERROR: ID \"%s\" is longer the 9 characters\n", line, yytext);
                                  else { strcpy(tokenName, "ID"); strcpy(tokenDescription, "An identifier"); strcpy(yylval.id, yytext); return ID; } }
([0-9]+|[0-9]+"."[0-9]+)        { strcpy(tokenName, "NUM"); strcpy(tokenDescription, "An integer"); yylval.num = atoi(yytext); return NUM; }

\n                              { line++; }
[\t ]+
.                               { fprintf(stderr, "LINE:  %d\tERROR: \"%c\" unrecognized token\n", line, yytext[0]); }

%%

main (int argc, char **argv) 
{
    int token;
    
    if (argc != 2)
    {
        printf("Usage: cla <input file name>.ou\n");
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

    char outputPath[strlen(argv[1])+1];
    strcpy(outputPath, argv[1]);
    int outputlen = strlen(outputPath);
    outputPath[outputlen+1] = 0;
    outputPath[outputlen] = 'k';
    outputPath[outputlen-1] = 'o';
    outputPath[outputlen-2] = 't';
    FILE *output = fopen(outputPath, "w");

    while ((token = yylex()) != 0)
    {
        fprintf(output, "LINE:  %d\tTOKEN: %s\tLEXEME: %s", line, tokenName, yytext);
        if(token > 300 && token < 307)
            fprintf(output, "\tOperator: %s", yylval.op);
        else if(token == 401)
            fprintf(output, "\tIdentifier: %s", yylval.id);
        else if(token == 402)
            fprintf(output, "\tNumber: %s", yylval.num);
        fprintf(output, "\n%s\n", tokenDescription);
    }

    fprintf(output, "** Written By Reuven Abramov **");
    fprintf(stderr, "** Written By Reuven Abramov **");
    fclose(yyin);
    fclose(output);
    exit(0);
}