cmake_minimum_required(VERSION 3.20)
project(pascal_compiler CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

get_filename_component(FLEX_BIN_DIR ${FLEX_EXECUTABLE} DIRECTORY)
find_path(FLEXLEXER_INCLUDE_DIR FlexLexer.h
        PATHS ${FLEX_BIN_DIR} ${FLEX_BIN_DIR}/../include
)
if (NOT FLEXLEXER_INCLUDE_DIR)
    message(FATAL_ERROR "FlexLexer.h not found near flex executable. "
            "Set -DFLEXLEXER_INCLUDE_DIR=<path> manually when running CMake.")
endif ()
message(STATUS "Found FlexLexer.h in: ${FLEXLEXER_INCLUDE_DIR}")

BISON_TARGET(PascalParser
        ${CMAKE_SOURCE_DIR}/parser.y
        ${CMAKE_BINARY_DIR}/parser.cpp
        DEFINES_FILE ${CMAKE_BINARY_DIR}/parser.hpp
)

FLEX_TARGET(PascalLexer
        ${CMAKE_SOURCE_DIR}/lexer.l
        ${CMAKE_BINARY_DIR}/lex.yy.cpp
        COMPILE_FLAGS "--c++"
)

ADD_FLEX_BISON_DEPENDENCY(PascalLexer PascalParser)

add_executable(pascal_lexer
        main.cpp
        ${FLEX_PascalLexer_OUTPUTS}
        ${BISON_PascalParser_OUTPUTS}
        core/Console.cpp
        core/Console.h
        core/Buffer.cpp
        core/Buffer.h
)

target_include_directories(pascal_lexer PRIVATE
        ${CMAKE_SOURCE_DIR}
        ${CMAKE_BINARY_DIR}
        ${FLEXLEXER_INCLUDE_DIR}
)