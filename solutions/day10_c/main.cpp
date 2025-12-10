#include <iostream>
#include <cstring>

#include "part1.cpp"
// #include "part2.cpp"

int main(int argc, char** argv) {
    if (strcmp(argv[1], "part1") == 0) {
        Part1();
    }
    else if (strcmp(argv[1], "part2") == 0) {
        // Part2();
    }
    else {
        std::cout << "Usage: " << argv[0] << " part1 or " << argv[0] << " part2" << std::endl;
    }
    return 0;
}