To create lex.yy.c file type the following command in command prompt:
flex mmn12a.l

To compile the lex.yy.c file type the following command (uses gcc compiler):
gcc lex.yy.c -o cla.exe

To use the program type the following command:
cla <input file name>.ou

input file has to be with .ou extension,
the output file will have the same file name but with .tok extension.

