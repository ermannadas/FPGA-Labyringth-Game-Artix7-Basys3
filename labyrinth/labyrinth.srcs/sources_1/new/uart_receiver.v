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
    input rx,
    output reg [7:0] data,
    output reg rx_done_tick
);
    parameter CLKS_PER_BIT = 10417;

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state = IDLE;
    reg [15:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] shift_reg = 0;

    always @(posedge clk) begin
        rx_done_tick <= 0;
        case(state)
            IDLE: begin
                if(~rx) begin
                    state <= START;
                    clk_count <= 0;
                end
            end
            START: begin
                if(clk_count == (CLKS_PER_BIT-1)/2) begin
                    state <= DATA;
                    clk_count <= 0;
                end else begin
                    clk_count <= clk_count + 1;
                end
            end
            DATA: begin
                if(clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;                     
                    shift_reg <= {rx, shift_reg[7:1]};
                    if(bit_index < 7)
                        bit_index <= bit_index + 1;
                    else begin
                        state <= STOP;
                        data <= {shift_reg[6:0], rx};
                        bit_index <= 0;
                    end
                end
            end
            STOP: begin
                if(clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    rx_done_tick <= 1;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
endmodule
