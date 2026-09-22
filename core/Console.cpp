//
// Created by kulgl on 10.09.2026.
//

#include "Console.h"

#include <iostream>

using std::string;
using std::cout;
using std::cerr;
using std::endl;

std::vector<string> Console::_errors;

void Console::Log(int line, const string& message) {
    cout << "[" << line << "] " << message << endl;
}

void Console::Error(int line, const string& message) {
    _errors.push_back("ERROR [" + std::to_string(line) + "]: " + message);
}

void Console::PrintErrors() {
    cout.flush();
    for (int i = 0; i < _errors.size(); ++i) {
        cerr << _errors[i] << endl;
    }
}

bool Console::HasErrors() {
    return !_errors.empty();
}

void Console::LogInt(int line, const string& kind, long long value) {
    printf("[%d] %s: %lld\n", line, kind.c_str(), value);
}

void Console::LogReal(int line, const string& kind, double value) {
    printf("[%d] %s: %g\n", line, kind.c_str(), value);
}