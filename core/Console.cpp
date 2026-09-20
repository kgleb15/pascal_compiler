//
// Created by kulgl on 10.09.2026.
//

#include "Console.h"

#include <iostream>

using std::cout;
using std::cerr;
using std::endl;

void Console::Log(int line, const string& message) {
    cout << "[" << line << "] " << message << endl;
}

void Console::Error(int line, const string& message) {
    cerr << "ERROR [" << line << "]: " << message << endl;
}