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
    
    reg [2:0] rgb;
    reg [27:0] counter;
    reg [15:0] decimator;
    
    wire [6:0] r;
    wire [6:0] g;
    wire [6:0] b;
    wire [6:0] c;
    
initial begin
    rgb <=  0;
    counter <= 0;
    decimator <= 0;
end

always @(posedge CLK_25M_i)
begin
  decimator <= decimator + 1;
  
  if (decimator == 1000)
  begin
  decimator <=  0;
  counter <= counter + 1;

  rgb[2] <= (c>r) ? 1 : 0;
  rgb[1] <= (c>g) ? 1 : 0;
  rgb[0] <= (c>b) ? 1 : 0;
  end
end

assign LED_o = rgb;
assign r = counter[27:20];
assign g = counter[19:12];
assign b = counter[11:4];
assign c = counter[3:0];

endmodule
