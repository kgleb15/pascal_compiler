#ifndef PASCAL_COMPILER_NODEID_H
#define PASCAL_COMPILER_NODEID_H


inline int NextNodeId() {
    static int counter = 0;
    return ++counter;
}


#endif //PASCAL_COMPILER_NODEID_H
