`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 10:00:57
// Design Name: 
// Module Name: example_top
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


module example_top
(
    input  wire i_sys_clk,   // Входная тактовая частота
    input  wire i_button,    // Кнопка для повторной отправки
    output wire d_fpg3,      // Выход UART TX
    output wire o_led        // Светодиод для индикации работы
);

localparam I_SYS_CLK = 32'd25_000_000; // Частота входного тактового сигнала

wire sys_clk_ibufg;
wire clk_115200;

//-----------------------------------------------------------------------
// Буферизация тактового сигнала
IBUFG u_ibufg_sys_clk
(
    .I  (i_sys_clk),
    .O  (sys_clk_ibufg)
);

reg [1:0] tick_sh = 0;
reg       tick = 0;

reg [25:0] led_count = 0;
reg        led = 0;

meander #(.PERIOD(I_SYS_CLK/115200) baudrate (.clk(sys_clk_ibufg), .out(clk_115200));

//------------------------------------------------------------------------------
// Мигание светодиода
//------------------------------------------------------------------------------
always @(posedge sys_clk_ibufg)
begin
    led_count <= led_count + 1'b1;
    if (led_count == I_SYS_CLK / 2) begin
        led_count <= 0;
        led       <= ~led;
    end

    tick_sh[0] <= ~led;
    tick_sh[1] <= tick_sh[0];
     
    if (tick_sh[1:0] == 2'b01) tick <= 1;
    else tick <= 0;
end

assign o_led  = led;

wire u_tx_busy;
wire u_tx_done;
reg [7:0] u_tx_data = 0;
reg       u_tx_we = 0;

// Модуль UART TX
uart_tx U_TX
(
    .i_clk      (clk_115200),          // Тактовый сигнал
    .i_data  (u_tx_data),              // Данные для передачи
    .i_we     (u_tx_we),                // Сигнал записи данных
    .o_tx       (d_fpg3),                 // Выход UART TX
    .o_busy   (u_tx_busy)               // Статус занятости передатчика
    .o_done   (u_tx_done)               // Статус занятости передатчика
);

reg [7:0] msg [0:12] = {"Hello world\n"};
reg [7:0]  d_st = 0;
reg [6:0]  d_count = 0;

// Отправка текстового сообщения
always @(posedge sys_clk_ibufg)
begin
    case(d_st)
    0: // Ожидание нажатия кнопки
    begin
        if (i_button) begin
            d_count <= 0;
            d_st <= 1;
        end
    end
    
    1: // Отправка символа
    begin
        if (u_tx_busy == 0) begin
            case(d_count)
                0: u_tx_data <= "H"; // 'H'
                1: u_tx_data <= "e"; // 'e'
                2: u_tx_data <= "l"; // 'l'
                3: u_tx_data <= "l"; // 'l'
                4: u_tx_data <= "o"; // 'o'
                5: u_tx_data <= " "; // Пробел
                6: u_tx_data <= "W"; // 'W'
                7: u_tx_data <= "o"; // 'o'
                8: u_tx_data <= "r"; // 'r'
                9: u_tx_data <= "l"; // 'l'
                10: u_tx_data <= "d"; // 'd'
                11: u_tx_data <= "!"; // '!'
                12: u_tx_data <= 8'h0A; // Перевод строки (\n)
                default: begin
                    u_tx_we <= 0;
                    d_st <= 0; // Возвращаемся в состояние ожидания
                end
            endcase
            
            u_tx_we <= 1;
            d_count <= d_count + 1;
        end
    end
    
    default: d_st <= 0;
    endcase
end

endmodule
