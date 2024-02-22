module ram(clk, we, addr);
  input clk;
  input we;
  input [7:0] addr;
  reg [7:0] addr_sv;
  real time_clk;

  always @(posedge clk) begin
    if (we == 1'b1) begin
      time_clk <= $realtime;
      addr_sv <= addr;
    end
  end

  initial begin
    #10
    $display(addr_sv, time_clk);
  end
endmodule

module tb();
  reg clk;
  reg awe;
  reg [7:0] waddr;
  ram r(clk, awe, waddr);
  always #5
    clk = ~clk;
  initial begin
    #10
    waddr =1;
    #10
    awe = 1;
  end
endmodule
