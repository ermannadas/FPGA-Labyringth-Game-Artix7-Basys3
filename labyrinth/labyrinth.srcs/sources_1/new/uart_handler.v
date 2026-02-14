`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2024 05:30:18 AM
// Design Name: 
// Module Name: uart_handler
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


module uart_handler(
    input wire clk,
    input wire rst,
    input wire rx,
(*mark_debug = "true"*) output reg move_up_o,
(*mark_debug = "true"*) output reg move_down_o,
(*mark_debug = "true"*) output reg move_right_o,
(*mark_debug = "true"*) output reg move_left_o,
(*mark_debug = "true"*) output reg break_wall_o,
(*mark_debug = "true"*) output reg load_map_o,
(*mark_debug = "true"*) output reg auto_level_up_o,
(*mark_debug = "true"*) output reg random_map_o,
(*mark_debug = "true"*) output reg [3:0] map_selection_o,
(*mark_debug = "true"*) output reg [3:0] map_size_o
);

(*mark_debug = "true"*) wire [7:0] received_data;
(*mark_debug = "true"*) wire rx_done;

    // 9600 baud rate icin 100000000 / 9600 = 10416.666 = 10416 cevrimde bir sembol gelir

    uart_receiver #(.CLKS_PER_BIT(10416)) receiver (
        .clk(clk),
        .rx(rx),
        .data(received_data),
        .rx_done_tick(rx_done)
    );

    // uarttan okunan degerlere gore uart kontrollerinin atamasi yapilir
    always @(posedge clk) begin
        if(rst) begin
            move_up_o <= 0;
            move_down_o <= 0;
            move_right_o <= 0;
            move_left_o <= 0;
            break_wall_o <= 0;
            load_map_o <= 0;
            auto_level_up_o <= 0;
            random_map_o <= 0;
            map_selection_o <= 4'b0001;
            map_size_o <= 4'b1000;
        end else begin
            if(rx_done) begin
                if(received_data == 220)
                    move_up_o <= 1;
                if(received_data == 132)
                    move_left_o <= 1;
                if(received_data == 204)
                    move_down_o <= 1;
                if(received_data == 144)
                    move_right_o <= 1;
                if(received_data == 136)
                    break_wall_o <= 1;
                if(received_data == 136)
                    break_wall_o <= 1;
                if(received_data == 176)
                    load_map_o <= 1;
                if(received_data == 172)
                    auto_level_up_o <= ~auto_level_up_o;
                if(received_data == 212)
                    random_map_o <= ~random_map_o;
                if(received_data == 196)
                    map_selection_o <= 4'b0001;
                if(received_data == 200)
                    map_selection_o <= 4'b0010;
                if(received_data == 204)
                    map_selection_o <= 4'b0100;
                if(received_data == 208)
                    map_selection_o <= 4'b1000;
                if(received_data == 232)
                    map_size_o <= 4'b0001;
                if(received_data == 224)
                    map_size_o <= 4'b0010;
                if(received_data == 140)
                    map_size_o <= 4'b0100;
                if(received_data == 216)
                    map_size_o <= 4'b1000;
            end else begin
                move_up_o <= 0;
                move_down_o <= 0;
                move_right_o <= 0;
                move_left_o <= 0;
                break_wall_o <= 0;
                load_map_o <= 0;
                auto_level_up_o <= auto_level_up_o;
                random_map_o <= random_map_o;
                map_selection_o <= map_selection_o;
                map_size_o <= map_size_o;
            end
        end
    end

endmodule
