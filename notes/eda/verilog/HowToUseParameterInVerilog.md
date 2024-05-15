# verilog中parameter的用法

here's an example of a Verilog module with parameters:

```verilog
module counter #(
  parameter WIDTH = 4,
  parameter INITIAL_VALUE = 0
) (
  input clk,
  input reset,
  output reg [WIDTH-1:0] count
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= INITIAL_VALUE;
    end else begin
      count <= count + 1;
    end
  end

endmodule
```

In this example, the module is named `counter` and it has two parameters: `WIDTH` and `INITIAL_VALUE`. `WIDTH` is an integer parameter with a default value of 4, and `INITIAL_VALUE` is an integer parameter with a default value of 0.

The module has three ports: `clk`, `reset`, and `count`. `clk` and `reset` are inputs, and `count` is an output. The `count` output is a `reg` data type with a width of `WIDTH`.

The module contains an `always` block that increments the `count` variable on every positive edge of the `clk` signal, except when `reset` is high, in which case the `count` variable is set to `INITIAL_VALUE`.