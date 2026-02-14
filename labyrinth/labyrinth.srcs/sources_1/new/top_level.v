`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2024 06:07:52 PM
// Design Name: 
// Module Name: top_level
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


module top_level(
    input clk_int_i,
    input [15:0] switch_i,
    output [15:0] led_o,
    output [6:0] segment_o,
    output [3:0] anode_o,
    input btnU_i,
    input btnD_i,
    input btnL_i,
    input btnR_i,
    input btnC_i,
    output Hsync_o,
    output Vsync_o,
    output [3:0] vgaRed_o,
    output [3:0] vgaGreen_o,
    output [3:0] vgaBlue_o,
    input RsRx_i
);

    // top levelda butun modullerin baglantisi saglanmistir

    wire clk_100MHz;
    wire clk_25MHz;
    wire locked;

    clk_wiz_0 clk_wiz_inst (
        .clk_in1(clk_int_i),
        .clk_out1(clk_100MHz),
        .clk_out2(clk_25MHz),
        .locked(locked)
    );

    wire btnU, btnD, btnR, btnL, btnC;
    button_handler button_unit (
        .clk(clk_int_i),
        .btnu_i(btnU_i),
        .btnd_i(btnD_i),
        .btnr_i(btnR_i),
        .btnl_i(btnL_i),
        .btnc_i(btnC_i),
        .btnU_o(btnU),
        .btnD_o(btnD),
        .btnR_o(btnR),
        .btnL_o(btnL),
        .btnC_o(btnC)  
    );
    
    wire [15:0] switch;
    switch_handler switch_unit (
        .clk(clk_int_i),
        .sw_i(switch_i),
        .switch_o(switch)
    );
    
    wire move_up_uart;
    wire move_down_uart;
    wire move_right_uart;
    wire move_left_uart;
    wire break_wall_uart;
    wire load_map_uart;
    wire auto_level_up_uart;
    wire random_map_uart;
    wire [3:0] map_selection_uart;
    wire [3:0] map_size_uart;
    
    uart_handler uart_unit (
        .clk(clk_100MHz),
        .rst(switch[15]),
        .rx(RsRx_i),
        .move_up_o(move_up_uart),
        .move_down_o(move_down_uart),
        .move_right_o(move_right_uart),
        .move_left_o(move_left_uart),
        .break_wall_o(break_wall_uart),
        .load_map_o(load_map_uart),
        .auto_level_up_o(auto_level_up_uart),
        .random_map_o(random_map_uart),
        .map_selection_o(map_selection_uart),
        .map_size_o(map_size_uart)
    );
    
    wire [13:0] points;
    
    map_size map_size_inst (
        .clk_game(clk_100MHz),
        .clk_render(clk_25MHz),
        .rst(switch[15]),
        .map_size_i(switch[14] ? map_size_uart : switch[3:0]),
        .move_up_i(switch[14] ? move_up_uart : btnU),
        .move_down_i(switch[14] ? move_down_uart : btnD),
        .move_left_i(switch[14] ? move_left_uart : btnL),
        .move_right_i(switch[14] ? move_right_uart : btnR ),
        .break_wall_i(switch[14] ? break_wall_uart : btnC),
        .load_map_i(switch[14] ? load_map_uart : switch[9]),
        .random_map_i(switch[14] ? random_map_uart : switch[8]),
        .select_map_i(switch[14] ? map_selection_uart : switch[7:4]),
        .auto_level_up_i(switch[14] ? auto_level_up_uart : switch[10]),
        .points_o(points),
        .break_wall_lives_o(led_o),
        .Hsync_o(Hsync_o),
        .Vsync_o(Vsync_o),
        .vgaRed_o(vgaRed_o),
        .vgaGreen_o(vgaGreen_o),
        .vgaBlue_o(vgaBlue_o)
    );
    
     seven_segment_controller seven_segmen_unit (
        .clk(clk_100MHz),
        .rst(switch[15]),
        .num(points),
        .segments(segment_o),
        .digit_select(anode_o)
    );

endmodule


