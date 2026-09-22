//
// Created by kulgl on 10.09.2026.
//

#ifndef PASCAL_COMPILER_BUFFER_H
#define PASCAL_COMPILER_BUFFER_H


#include <string>

class Buffer {
private:
    std::string _content;
    int _startLine = -1;

public:
    void reset();

    void append(const std::string& text);

    void setStartLine(int line);

    int getStartLine() const;

    std::string current() const;
};


#endif //PASCAL_COMPILER_BUFFER_H
