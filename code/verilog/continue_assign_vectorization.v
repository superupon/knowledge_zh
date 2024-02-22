module DIV_AND_GATE(
  input [7:0] dcnt,
  input clk,
  input den,
  input[3:0] dnum,
  input div_en
);
  wire [7:0] en_grp;
  wire gate_en;
  reg en;
  generate
    genvar i;
    for (i = 0; i < 8; i = i+1) begin
      assign en_grp[i] = (dcnt[i:0] == {(i+1){1'b0}}) ? 1'b1 : 1'b0;
    end
  endgenerate
  assign gate_en = (dcnt[1:0] == 2'b1) ? 1'b0 : 1'b1;
  always @posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
      en <= 1'b0;
    end
    else if ((den == 1'b0) || (dnum > 8)) begin
      en <= 1'b1;
    end
    else if (div_en == 1'b1) begin
      if(dnum == 4'b0001) begin
        en <= gate_en;
      end
      else begin
        en <= (en_grp[dnum-4'b0010] == 1'b1);
      end
    end
  end
  assign gate_en = en;
endmodule


module test();
  reg[7:0] data;
  reg clk;
  reg rst;
  reg en;
  reg num;
  reg quard_en;
  DIV_AND_GATE d(data, clk, rst, en, num, quard_en);
endmodule
