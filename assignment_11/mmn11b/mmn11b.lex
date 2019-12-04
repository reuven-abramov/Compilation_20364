%{
    #include <string.h>
    #define TITLE 300
    #define OBJNUM 301
    #define ATTR 302
    #define NAME 303
    #define GENDER 304
    #define YEAR 305
    #define COMMA 306

    char yylval[80];
%}

%option noyywrap

%%

"**"[a-zA-Z0-9 ]*"**"   { strcpy(yylval, yytext); return TITLE; }

#[0-9]+                 { strcpy(yylval, yytext); return OBJNUM; }

"<"[a-zA-Z ]+">"        { strcpy(yylval, yytext); return ATTR; }

\"[a-zA-Z ]+\"          { strcpy(yylval, yytext); return NAME; }

([Ww]o){0,1}[Mm]an      { strcpy(yylval, yytext); return GENDER; }

[0-9]{4}(-[0-9]{4}){0,1} {strcpy(yylval, yytext); return YEAR; }

,                       { strcpy(yylval, yytext); return COMMA;}

[\n\t ]+

.                       { printf("unrecognized token %c\n", yytext[0]); }

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

    printf("TOKEN\t\t\tLEXEME\t\t\tATTRIBUTE\n------------------------------------------------------------------------\n");
    char temp[30];

    while ((token = yylex()) != 0)
        switch (token) 
        {
            case TITLE: printf("TITLE\t\t\t%s\n", yylval);
                        break;
            case OBJNUM:printf("OBJNUM\t\t\t%s\t\t\t%s\n",yylval, yylval+1);
                        break;
            case ATTR:  strcpy(temp, yylval+1);
                        temp[strlen(temp)-1] = '\0';
                        printf("ATTR\t\t\t%s\t\t\t%s\n", yylval, temp);
                        break;
            case NAME:  strcpy(temp, yylval+1);
                        temp[strlen(temp)-1] = '\0';
                        printf("NAME\t\t\t%s\t\t\t%s\n", yylval, temp);
                        break;
            case GENDER:printf("GENDER\t\t\t%s\t\t\t%s\n", yylval, yylval);
                        break;
            case YEAR:  printf("YEAR\t\t\t%s\t\t\t%s\n", yylval, yylval);
                        break;
            case COMMA: printf("COMMA\t\t\t%s\n", yylval);
                        break;
            default:    printf("error ...\n");
                        exit(1);
        }
    fclose(yyin);
    exit(0);
}