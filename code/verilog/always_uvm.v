module cap(
  input [31:0] id,
  input clk,
  input vld,
  input [31:0] data,
  input start,
  input en);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  integer m_id;
  reg [31:0] cnt;
  reg [31:0] stored [0:15];
  string name;

  always @(posedge clk or en or posedge start or id) begin
    if(en == 0) begin
      uvm_config_int::get(null, "uvm_test_top", "id", m_id);
      cnt <= 0;
    end
    else if(start == 1) begin
      uvm_config_int::get(null, "uvm_test_top", "id", m_id);
      cnt <= 0;
    end
    else if(vld == 1 && cnt < 15) begin
      stored[cnt] <= data;
      cnt <= cnt + 1;
    end
    else if(cnt == 15) begin
      cnt <= 0;
      $display("%0srun%0d at %t", "", m_id, $time);
      name = $psprintf("id%0d/%0s", m_id, "");
      print_pkt(name);
    end
  end

  function void print_pkt(string fn);
    $display("error: %0s", fn);
    return;
  endfunction
endmodule

module tb();
  reg [31:0] id;
  reg clk;
  reg vld;
  reg [31:0] data;
  reg start;
  reg en;
  cap d(id, clk, vld, data, start, en);
  always #5 clk = ~clk;
endmodule
  
