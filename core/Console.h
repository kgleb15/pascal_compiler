//
// Created by kulgl on 10.09.2026.
//

#ifndef PASCAL_COMPILER_CONSOLE_H
#define PASCAL_COMPILER_CONSOLE_H

#include <string>
using std::string;

class Console {
public:
    static void Log(const string& message);
    static void Warning(const string& message);
    static void Error(const string& message);
};

#endif //PASCAL_COMPILER_CONSOLE_H
