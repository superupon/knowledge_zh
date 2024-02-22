#include "Vcounter10.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vcounter10* top = new Vcounter10;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("waveform.vcd");

    vluint64_t main_time = 0;
    top->rstn = 1;

    while (!Verilated::gotFinish()) {
        top->clk = (main_time % 20 < 10) ? 1 : 0;  // Generate a clock with 50% duty cycle and period of 20 units
        top->eval();

        if (main_time > 0 && main_time % 10 == 0) {
            tfp->dump(main_time);  // Dump waveform data for each change in the clock
        }

        main_time++;  // Increment the simulation time

        if (main_time > 3000) break;
    }

    tfp->close();
    delete top;
    return 0;
}