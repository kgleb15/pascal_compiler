//
// Created by kulgl on 10.09.2026.
//

#ifndef PASCAL_COMPILER_CONSOLE_H
#define PASCAL_COMPILER_CONSOLE_H

#include <string>
#include <vector>
#include <cstdio>
using std::string;

class Console {
public:
    static void Log(int line, const string& message);
    static void Error(int line, const string& message);
    static void PrintErrors();
    static bool HasErrors();
    static void LogInt(int line, const string& kind, long long value);
    static void LogReal(int line, const string& kind, double value);
private:
    static std::vector<string> _errors;
};

#endif //PASCAL_COMPILER_CONSOLE_H
