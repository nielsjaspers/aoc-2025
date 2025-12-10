#include <iostream>
#include <fstream>
#include <iomanip>


void Part1() {
    auto start = std::chrono::high_resolution_clock::now();
    
    
    std::ifstream file("data/day10/day10.test");
    std::string line;
    while (std::getline(file, line)) {
        // std::cout << line << std::endl;
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    
    std::cout << "Execution time: " 
              << std::fixed << std::setprecision(5)
              << duration.count() / 1000.0 << " ms (" 
              << duration.count() << " µs)" << std::endl;
    
    std::cout << "Result: " << 0 << std::endl;
}