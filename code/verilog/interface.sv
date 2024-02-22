module test(
  intf.slv intf_0);
  wire [2:0] pri;
  assign intf_0.ind = pri[0];
endmodule
  interface intf();
    wire logic ind;
    wire logic status;
    modport slv (
      ind,
      status);
    modport mst (
      ind,
      status);
  endinterface

module wrapper(intf.slv intf_0);
  test t(.intf_0(intf_0));
endmodule

module rapper(intf.slv intf_0);
  wrapper r(.intf_0(intf_0));
endmodule

module tb();
  intf intf_0();
  rapper w(.intf_0(intf_0));
endmodule
