(CELL
  (CELLTYPE "top")
  (INSTANCE)
  (DELAY
    (ABSOLUTE
      (INTERCONNECT s1/a s/A1 (-0.000::0.000) (-0.000::1) )
      (INTERCONNECT s2/a s/B1 (-0.000::0.000) (-1::1) )
      (INTERCONNECT s/ZN s3/a (-0.000::0.000) (-1::1) )
    )
  )
)

(CELL
  (CELLTYPE "Sub")
  (INSTANCE top/s)
  (DELAY
    (ABSOLUTE
      (IOPATH s1/a s/A1 (-0.000::0.000) (-0.000::1) )
      (INTERCONNECT s2/a s/B1 (-0.000::0.000) (-1::1) )
      (INTERCONNECT s/ZN s3/a (-0.000::0.000) (-1::1) )
    )
  )
)

`timescale 1ns/1ns
module top;
  wire [1:0] A1;
  wire ZN;
  Sub1 s1(A1[0]);
  Sub1 s2(A1[0]);
  Sub1 s2(ZN);
  Sub s (A1[0], A1[1], ZN);
  initial $sdf_annotate("t.sdf", top,,,"MINIMUM");
  initial begin
    $monitor($time,, ZN);
    #700;
    $finish();
  end
endmodule

module Sub(input A1, B1, output ZN);
  reg A1_inv;
  not (A1_inv, A1);
  nor (ZN, A1_inv, B1);
  specify
    (A1=>ZN) = (26, 24);
    (B1=>ZN) = (17, 14);
  endspecify
endmodule

module Sub1(output a);
  assign #70 a = 0;
endmodule

module Sub2 (input a);
endmodule
