module D(
  input rst,
  input [31:0] div,
  input clki,
  output reg clko
);
  reg clk_div;
  reg [31:0] cnt_s;
  reg [31:0] cnt;
  always @(*) begin
    if ((div >= 32'd2) && (div <= 32'd32)) begin
        cnt_s = div - 32'd1;
    end
    else begin
      cnt_s = 32'd1;
    end
  end

  always @(posedge clki or negedge clki or negedge rst) begin
    if (rst == 0) begin
      clk_div <= 0;
      cnt <= 0;
    end
    else if (cnt >= cnt_s) begin
      clk_div <= ~clk_div;
      cnt <= 0;
    end
    else begin
      cnt <= cnt + 1;
    end
  end
  initial begin
    $monitor(cnt);
  end
  assign clko = (div == 1) ? clki : clk_div;
endmodule

module tb();
  reg rst;
  reg [31:0] div;
  reg clki;
  reg clko;
  D d(rst, div, clki, clko);
  always #5 clki = ~clki;
endmodule
        
