module ram_sim(input clk);
  wire a, b, c, d;
  always @(posedge clk) begin
    if (a == 1'b1) begin
      $display($realtime,,"%m");
    end
    else if(b == 1'b1) begin
      $display($realtime,,"%m");
    end
    else if(c == 1'b1) begin
      $display($realtime,,"%m");
    end
    else if(d == 1'b1) begin
      $display($realtime,,"%m");
    end
  end
endmodule

module tb();
  reg clk;
  ram_sim r(clk);
  always #5
    clk = ~clk;
endmodule
