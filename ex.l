%{
    #include <string.h>
    #define NUM 300
    #define ID 301
    #define STRING 302

    union 
    {
        int ival;
        char name[30];
        char str[80];
    } yylval;

    extern int atoi (const char *);    
%}

%option noyywrap

%x COMMENT

%%

[0-9]+                  { yylval.ival = atoi(yytext); return NUM; }

[a-zA-Z][a-zA-Z0-9]*    { strcpy(yylval.name, yytext); return ID; }

\"([^\\"\n]|\\.)*\"     { strcpy(yylval.str, yytext); return STRING; }

[\n\t ]+

"//"                    { BEGIN(COMMENT); }

<COMMENT>.+
<COMMENT>\n             { BEGIN(0); }

.                       { fprintf(stderr, "unrecognized token %c\n", yytext[0]); }

%%
main (int argc, char **argv) 
{
    int token;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: mylex <input file name>\n", yytext[0]);
        exit(1);
    }

    yyin = fopen(argv[1], "r");

    while ((token = yylex()) != 0)
        switch (token) 
        {
            case NUM:   printf("NUMBER : %d\n", yylval.ival);
                        break;
            case ID:    printf("ID : %s\n", yylval.name);
                        break;
            case STRING:printf("STRING : %s\n", yylval.str);
                        break;
            default:    fprintf(stderr, "error ...\n");
                        exit(1);
        }
    fclose(yyin);
    exit(0);
}