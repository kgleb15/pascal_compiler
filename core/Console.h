//
// Created by kulgl on 10.09.2026.
//

#ifndef PASCAL_COMPILER_CONSOLE_H
#define PASCAL_COMPILER_CONSOLE_H

#include <string>
#include <vector>
using std::string;

class Console {
public:
    static void Log(int line, const string& message);
    static void Error(int line, const string& message);
    static void PrintErrors();
    static bool HasErrors();
private:
    static std::vector<string> _errors;
};

#endif //PASCAL_COMPILER_CONSOLE_H
