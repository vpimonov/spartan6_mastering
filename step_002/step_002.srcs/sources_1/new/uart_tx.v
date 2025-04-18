`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 11:28:06
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input i_clk,
    input i_en,
    input [7:0] data,
    input i_we,
    output o_tx,
    output o_busy,
    output o_done
    );
    
    reg [9:0] tx_sh;
    reg [4:0] cnt;
    reg busy;
    
    always @(posedge i_clk) begin
        if (!busy && i_we) begin
            cnt <= 0;
            tx_sh <= {1'b1, data,  1'b0};
            busy <= 1'b1;
        end else if (cnt < 10) begin
            tx_sh <= {1'b1, tx_sh[9:1]};
            cnt <= cnt + 1'b1;
            busy <= 1'b1;
        end else begin
            tx_sh <= {10'b1_1111_1111_1};
            busy <= 1'b0;
        end
    end
    
    assign o_tx = tx_sh[0];
    assign o_busy = busy;
    assign o_done = cnt == 5'd10;
endmodule
