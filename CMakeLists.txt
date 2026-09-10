cmake_minimum_required(VERSION 3.20)
project(pascal_compiler CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX REQUIRED)

get_filename_component(FLEX_BIN_DIR ${FLEX_EXECUTABLE} DIRECTORY)
find_path(FLEXLEXER_INCLUDE_DIR FlexLexer.h
        PATHS ${FLEX_BIN_DIR} ${FLEX_BIN_DIR}/../include
)
if (NOT FLEXLEXER_INCLUDE_DIR)
    message(FATAL_ERROR "FlexLexer.h not found near flex executable. "
            "Set -DFLEXLEXER_INCLUDE_DIR=<path> manually when running CMake.")
endif ()
message(STATUS "Found FlexLexer.h in: ${FLEXLEXER_INCLUDE_DIR}")

FLEX_TARGET(PascalLexer
        ${CMAKE_SOURCE_DIR}/lexer.l
        ${CMAKE_BINARY_DIR}/lex.yy.cpp
        COMPILE_FLAGS "--c++"
)

add_executable(pascal_lexer
        main.cpp
        ${FLEX_PascalLexer_OUTPUTS}
        core/Console.cpp
        core/Console.h
)

target_include_directories(pascal_lexer PRIVATE
        ${CMAKE_SOURCE_DIR}
        ${FLEXLEXER_INCLUDE_DIR}
)