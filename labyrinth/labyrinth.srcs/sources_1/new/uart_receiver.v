`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2024 05:30:53 AM
// Design Name: 
// Module Name: uart_receiver
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


module uart_receiver(
    input clk,
    input rx,          // FPGA kart rx portu
    output reg [7:0] data,  // UARTtan okunan veri
    output reg rx_done_tick // 1 byte (8bit) tamamlandigini gosterir
);
    parameter CLKS_PER_BIT = 10417; // 100 MHz saat icin 9600 baud rate

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state = IDLE;
    reg [15:0] clk_count = 0; // clocka gore sembol araliklarini hesaplar
    reg [3:0] bit_index = 0;  // sembolun indexi
    reg [7:0] shift_reg = 0;  // dataya verilmeden once gelen verileri tutan shift register

    always @(posedge clk) begin
        rx_done_tick <= 0;
        case(state)
            IDLE: begin
                if(~rx) begin       // rx pullup hattidir veri gelmeye baslayacagi zaman 0 olur
                    state <= START;
                    clk_count <= 0;
                end
            end
            START: begin
                if(clk_count == (CLKS_PER_BIT-1)/2) begin // start bitinin dogru geldigini dogrulamak icin
                    state <= DATA;                        // sembol rateinin yarisi kadar bekler, dogrulayinca
                    clk_count <= 0;                       // veriyi almaya baslar
                end else begin
                    clk_count <= clk_count + 1;
                end
            end
            DATA: begin
                if(clk_count < CLKS_PER_BIT-1) begin    // sembol rateine gore sembolun samplelanacagi yeri belirler
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;                     
                    shift_reg <= {rx, shift_reg[7:1]};  // samplelanacak yere gelince samplei shift registera atar
                    if(bit_index < 7)
                        bit_index <= bit_index + 1;     // sampleladiktan sonra bir sonraki bite gecer
                    else begin
                        state <= STOP;                  // 8inci sembolu alip 1 bytei tamamladiktan sonra
                        data <= {shift_reg[6:0], rx};   // shift registerdaki veriyi dataya atip
                        bit_index <= 0;                 // stop bitinin gelecegi evreye gecer
                    end
                end
            end
            STOP: begin
                if(clk_count < CLKS_PER_BIT-1) begin    // bir sembol kadar stop bitini bekler
                    clk_count <= clk_count + 1;
                end else begin                          // stop biti bittikten sonra tamamlandi
                    rx_done_tick <= 1;                  // tickini verir ve cikar
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
endmodule
