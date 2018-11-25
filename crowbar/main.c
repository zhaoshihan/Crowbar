#include <stdio.h>
#include "CRB.h"
#include "MEM.h"

const int BUFFERSIZE = 1024;

int
main(int argc, char **argv)
{
    CRB_Interpreter     *interpreter;
    FILE *fp = NULL;
	errno_t error;
	char* filename = malloc(BUFFERSIZE); 
    //if (argc != 2) {
    //    fprintf(stderr, "usage:%s filename", argv[0]);
    //    exit(1);
    //}
	printf("Input the source file name:\n");
	gets_s(filename, BUFFERSIZE);
	if (filename != "")
	{
		error = fopen_s(&fp, filename, "r");
	}
	else
	{
		fp = stdin;
	}


    //fp = fopen(argv[1], "r");
    //if (fp == NULL) {
    //    fprintf(stderr, "%s not found.\n", argv[1]);
    //    exit(1);
    //}
    interpreter = CRB_create_interpreter();
    CRB_compile(interpreter, fp);
    CRB_interpret(interpreter);
    CRB_dispose_interpreter(interpreter);

    MEM_dump_blocks(stdout);

	if (fp != NULL)
	{
		fclose(fp);
		fp = NULL;
	}
	free(filename);

	system("pause");
    return 0;
}
