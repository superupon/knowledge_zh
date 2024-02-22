#include "Vtest.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char **argv, char **env) {
   Verilated::commandArgs(argc, argv);
   Vtest* top = new Vtest;
   top->eval();
   
   delete top;
   exit(0);
}
