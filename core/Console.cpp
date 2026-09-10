//
// Created by kulgl on 10.09.2026.
//

#include "Console.h"

#include <iostream>

using std::cout;
using std::cerr;
using std::endl;

void Console::Log(const string& message) {
    cout << message << endl;
}

void Console::Warning(const string& message) {
    cerr << "WARNING: " << message << endl;
}

void Console::Error(const string& message) {
    cerr << "ERROR: " << message << endl;
}