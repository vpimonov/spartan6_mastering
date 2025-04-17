`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 17:13:38
// Design Name: 
// Module Name: blink
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module blink(
    input CLK_25M_i,
    output [2:0] LED_o
    );
    
    wire clk;
    wire fast_m;
    
    wire [2:0] slow;

    meander # (.WIDTH (9), .T_LO (100), .T_HI (400)) m_clk (.clk (CLK_25M_i), .out(clk));
    meander # (.WIDTH (9), .T_LO (150), .T_HI (150)) m_fast (.clk (clk), .out(fast_m));
    meander # (.WIDTH (9), .T_LO (151), .T_HI (151)) m_r (.clk (clk), .out(slow[2]));
    meander # (.WIDTH (9), .T_LO (152), .T_HI (152)) m_g (.clk (clk), .out(slow[1]));
    meander # (.WIDTH (9), .T_LO (153), .T_HI (153)) m_b (.clk (clk), .out(slow[0]));


assign LED_o = {fast_m,fast_m,fast_m} ^ slow | {clk,clk,clk};

endmodule
