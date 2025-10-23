// Minimal viable design without using any IOs

`default_nettype none
`timescale 1ns/1ps

module top_xlnx_fpln;

logic [4-1:0] cnt = 0;
logic cfg_clk; // actual frequency depends on family and PVT

STARTUPE2 startupe2_i (
   .CFGMCLK(cfg_clk),
   //.EOS(EOS),
   //.PREQ(PREQ),
   //.DO(cnt),
   //.DTS(4'h0),
   //.FCSBO(1'b0),
   //.FCSBTS(1'b0),
   .CLK(1'b0),
   .GSR(1'b0),
   .GTS(1'b0),
   .KEYCLEARB(1'b1),
   .PACK(1'b0),
   .USRCCLKO(1'b0),
   .USRCCLKTS(1'b0),
   .USRDONEO(&cnt),
   .USRDONETS(1'b1)
);

always_ff @(posedge cfg_clk) cnt <= cnt + 1;

endmodule
