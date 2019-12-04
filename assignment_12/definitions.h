#ifndef DEFINITIONS
#define DEFINITIONS

/* Keywords definitions */
#define BREAK 101
#define CASE 102
#define DEFAULT 103
#define ELSE 104
#define FLOAT 105
#define IF 106
#define INPUT 107
#define INT 108
#define OUTPUT 109
#define STATIC_CAST 110
#define SWITCH 111
#define WHILE 112

/* Symbols definitions */
#define LFPAREN 201
#define RTPAREN 202
#define LFBRACK 203
#define RTBRACK 204
#define COMMA 205
#define COLON 206
#define SEMCOLON 207
#define SET 208

/* Operator definitions */
#define RELOP 301
#define ADDOP 302
#define MULOP 303
#define OR 304
#define AND 305
#define NOT 306

/* General definitions */
#define ID 401
#define NUM 402

int line = 1;
union {
    char op[3];
    char id[10];
    float num;
} yylval;

#endif