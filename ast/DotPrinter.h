#ifndef PASCAL_COMPILER_DOTPRINTER_H
#define PASCAL_COMPILER_DOTPRINTER_H
#include <ostream>
#include <string>
#include <vector>
#include "ProgramNode.h"

class DotPrinter {
public:
    static void Print(ProgramNode* root, std::ostream& stream);

private:
    static std::ostream* out;
};


#endif //PASCAL_COMPILER_DOTPRINTER_H
