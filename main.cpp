#include <fstream>
#include <iostream>
#include <FlexLexer.h>

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
    lexer.yylex();

    return 0;
}