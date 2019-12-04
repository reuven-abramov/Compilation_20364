%{
    #include <string.h>
    #define NUM 301
    #define NL 302
    #define STR 303

    union {
        int ival;
        char str[80];
    } yylval;

    int line = 1;

    extern int atoi (const char *);    
%}

%option noyywrap

%%

[0-9]{2,}               { strcpy(yylval.str, yytext); return STR;}

[1-9]                   { yylval.ival = atoi(yytext); return NUM; }

[\n]                    { line++; return NL;}

.                       { strcpy(yylval.str, yytext); return STR; }

%%

void main (int argc, char **argv) 
{
    int token;
    int flag = 1;

    if (argc == 2)
        yyin = fopen(argv[1], "r");

    while ((token = yylex()) != 0)
    {
        if (flag)
        {
            if (line%2)
                printf("%d.\t", line);
            else
                printf("\t");
            flag = 0;
        }
        if (token == NUM)
            switch (yylval.ival)
            {
                case 1: printf("I");
                        break;
                case 2: printf("II");
                        break;
                case 3: printf("III");
                        break;
                case 4: printf("IV");
                        break;
                case 5: printf("V");
                        break;
                case 6: printf("VI");
                        break;
                case 7: printf("VII");
                        break;
                case 8: printf("VIII");
                        break;
                case 9: printf("IX");
                        break;
                default:printf("Error");
                        break;
            }
        else if (token == NL)
        {
            printf("\n");
            flag = 1;
        }
        else if (token == STR)
            printf(yylval.str);
        else
            printf("Error");
    }
    fclose(yyin);
    exit(0);
}