`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 09:32:29 AM
// Design Name: 
// Module Name: meander
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


module meander
#(
    parameter WIDTH = 8,
    parameter PERIOD = 100
)
(
    input clk,
    output out
);

reg [WIDTH-1 : 0] counter;
reg state;

always @(posedge clk)
begin
  counter <= counter + 1;
  if (counter < PERIOD / 2)
    state <= 1;
  else if (counter < PERIOD)
      state <= 0;
  else
  begin
    counter <= 0;
    state <= 0;
  end
end

assign out = state;

endmodule
