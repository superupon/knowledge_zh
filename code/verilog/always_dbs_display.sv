module DATA_CAP #(
  parameter MD_NAME = "",
  parameter DATA_NUM = 16,
  parameter DATA_WIDTH = 32,
  parameter PRINT_FORMAT = "HEX"
)
  (
    input [31:0] round_id,
    input in_clk,
    input in_vld,
    input [DATA_WIDTH-1:0] in_data,
    input cap_start,
    input cap_en
  );
import uvm_pkg::*;
`include "uvm_macros.svh"
integer m_round_id;
reg cap_en_used;
reg [31:0] data_cnt;
  reg [DATA_WIDTH-1:0] data_stored[0:DATA_NUM-1];
  string tmp_file_name;
  initial begin
    data_cnt = 0;
    cap_en_used = 0;
  end

  always @(posedge in_clk or cap_en or posedge cap_start or round_id) begin
    if(cap_en == 0) begin
      uvm_config_int::get(null, "uvm_test_top.m_top_env", "m_run_id_curr", m_round_id);
      data_cnt <= 0;
      cap_en_used <= 0;
    end
    else if(cap_start == 1) begin
      uvm_config_int::get(null, "uvm_test_top.m_top_env", "m_run_id_curr", m_round_id);
      data_cnt <= 0;
      cap_en_used <= 1;
    end
    else if (cap_en_used == 1 && in_vld == 1 && data_cnt <DATA_NUM) begin
      data_stored[data_cnt] <= in_data;
      data_cnt <= data_cnt +1;
    end
    else if (data_cnt == DATA_NUM) begin
      data_cnt <= 0;
      cap_en_used <= 0;
      $display("%0s run%0d at %t", MD_NAME, m_round_id, $time);
      tmp_file_name = $psprintf("dfecomm/round%d/%s", m_round_id, MD_NAME);
      print_pkt(tmp_file_name);
    end
  end

  function void print_pkt(string x_file_name);
    $display("error (%0s)", x_file_name);
    return;
  endfunction

endmodule

module tb();
  reg [31:0] round_id;
  reg in_clk;
  reg in_vld;
  reg [32-1:0] in_data;
  reg cap_start;
  reg cap_en;
  DATA_CAP d(rountd_id, in_clk, in_vld, in_data, cap_start, cap_en);
  always #5 in_clk = ~in_clk;
endmodule
  
