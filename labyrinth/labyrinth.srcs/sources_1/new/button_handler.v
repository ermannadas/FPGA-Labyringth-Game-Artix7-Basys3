`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 02:39:28 AM
// Design Name: 
// Module Name: button_handler
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


module button_handler(
    input clk,
    input btnu_i,
    input btnd_i,
    input btnr_i,
    input btnl_i,
    input btnc_i,
    output btnU_o,
    output btnD_o,
    output btnR_o,
    output btnL_o,
    output btnC_o
    );

    wire btnU_db, btnD_db, btnL_db, btnR_db, btnC_db;
    debouncer dbU(.clk_i(clk), .btn_i(btnu_i), .debounce_o(btnU_db)); // Butonlar burada debounce edilir
    debouncer dbD(.clk_i(clk), .btn_i(btnd_i), .debounce_o(btnD_db));
    debouncer dbR(.clk_i(clk), .btn_i(btnr_i), .debounce_o(btnR_db));
    debouncer dbL(.clk_i(clk), .btn_i(btnl_i), .debounce_o(btnL_db));
    debouncer dbC(.clk_i(clk), .btn_i(btnc_i), .debounce_o(btnC_db));
    
    rising_edge_detector edU(.clk(clk), .signal_i(btnU_db), .rising_edge_o(btnU_o)); // Butonlarin rising edgei burada verilir
    rising_edge_detector edD(.clk(clk), .signal_i(btnD_db), .rising_edge_o(btnD_o));
    rising_edge_detector edR(.clk(clk), .signal_i(btnR_db), .rising_edge_o(btnR_o));
    rising_edge_detector edL(.clk(clk), .signal_i(btnL_db), .rising_edge_o(btnL_o));
    rising_edge_detector edC(.clk(clk), .signal_i(btnC_db), .rising_edge_o(btnC_o));
    
endmodule
