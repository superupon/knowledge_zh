# case语句的写法

here is an example of a Verilog case statement with parameters.

```verilog
module Switch(input [2:0] sw, output reg [7:0] led);

  parameter LED_OFF = 8'h00;
  parameter LED_ON = 8'hFF;

  always @(sw)
  begin
    case(sw)
      3'b000: led = LED_OFF;
      3'b001: led = LED_ON;
      3'b010: led = LED_ON;
      3'b011: led = LED_OFF;
      3'b100: led = LED_ON;
      3'b101: led = LED_OFF;
      3'b110: led = LED_ON;
      3'b111: led = LED_OFF;
      default: led = LED_OFF;
    endcase
  end
endmodule
```

这个例子使用了一个switch(`sw`)来控制一个LED. switch的值是一个3bit的二进制数。依赖于switch的值，LED要么打开，`LED_ON`或`LED_OFF`.
