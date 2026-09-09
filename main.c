#include <stdio.h>

extern FILE *yyin;
extern int yylex(void);

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("fopen"); return 1; }
        yyin = f;
    }
    yylex();
    return 0;
}
