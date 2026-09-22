//
// Created by kulgl on 10.09.2026.
//

#ifndef PASCAL_COMPILER_CONSOLE_H
#define PASCAL_COMPILER_CONSOLE_H

#include <string>
#include <vector>


class Console {
public:
    static void Log(int line, const std::string& message);
    static void Error(int line, const std::string& message);
    static void PrintErrors();
    static bool HasErrors();
    static void LogInt(int line, const std::string& kind, long long value);
    static void LogReal(int line, const std::string& kind, double value);
private:
    static std::vector<std::string> _errors;
};

#endif //PASCAL_COMPILER_CONSOLE_H
