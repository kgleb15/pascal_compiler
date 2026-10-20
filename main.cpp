#include <fstream>
#include <iostream>
#include <FlexLexer.h>

#include "core/Console.h"
#include "parser.hpp"

static yyFlexLexer *g_lexer = nullptr;

int yylex() { return g_lexer->yylex(); } // bison вызывает yylex() сам

int main(int argc, char **argv) {
    std::ifstream file;
    std::istream *input = &std::cin;

    if (argc > 1) {
        file.open(argv[1]);
        if (!file.is_open()) {
            std::cerr << "Error opening file: " << argv[1] << std::endl;
            return 1;
        }
        input = &file;
    }

    yyFlexLexer lexer(input, &std::cout);
    g_lexer = &lexer;

    yydebug = 1; // включение трассы отладки
    yyparse();   // вызов парсера
    Console::PrintErrors();

    return 0;
}
