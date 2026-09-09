cmake_minimum_required(VERSION 3.20)
project(pascal_compiler C)

set(CMAKE_C_STANDARD 11)

find_package(FLEX REQUIRED)

FLEX_TARGET(PascalLexer
        ${CMAKE_SOURCE_DIR}/lexer.l
        ${CMAKE_BINARY_DIR}/lex.yy.c
)

add_executable(pascal_lexer
        main.c
        ${FLEX_PascalLexer_OUTPUTS}
)

target_include_directories(pascal_lexer PRIVATE ${CMAKE_SOURCE_DIR})