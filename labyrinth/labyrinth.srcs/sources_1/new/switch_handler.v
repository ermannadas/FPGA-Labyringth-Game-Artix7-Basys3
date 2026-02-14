`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 03:05:18 AM
// Design Name: 
// Module Name: switch_handler
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


module switch_handler(
    input clk,
    input [15:0] sw_i,
    output [15:0] switch_o
    );
    
    // butun switchler debouncelanip disariya verilmistir
    debouncer dbsw0 (.clk_i(clk), .btn_i(sw_i[0]),  .debounce_o(switch_o[0]));
    debouncer dbsw1 (.clk_i(clk), .btn_i(sw_i[1]),  .debounce_o(switch_o[1]));
    debouncer dbsw2 (.clk_i(clk), .btn_i(sw_i[2]),  .debounce_o(switch_o[2]));
    debouncer dbsw3 (.clk_i(clk), .btn_i(sw_i[3]),  .debounce_o(switch_o[3]));
    debouncer dbsw4 (.clk_i(clk), .btn_i(sw_i[4]),  .debounce_o(switch_o[4]));
    debouncer dbsw5 (.clk_i(clk), .btn_i(sw_i[5]),  .debounce_o(switch_o[5]));
    debouncer dbsw6 (.clk_i(clk), .btn_i(sw_i[6]),  .debounce_o(switch_o[6]));
    debouncer dbsw7 (.clk_i(clk), .btn_i(sw_i[7]),  .debounce_o(switch_o[7]));
    debouncer dbsw8 (.clk_i(clk), .btn_i(sw_i[8]),  .debounce_o(switch_o[8]));
    debouncer dbsw9 (.clk_i(clk), .btn_i(sw_i[9]),  .debounce_o(switch_o[9]));
    debouncer dbsw10(.clk_i(clk), .btn_i(sw_i[10]), .debounce_o(switch_o[10]));
    debouncer dbsw11(.clk_i(clk), .btn_i(sw_i[11]), .debounce_o(switch_o[11]));
    debouncer dbsw12(.clk_i(clk), .btn_i(sw_i[12]), .debounce_o(switch_o[12]));
    debouncer dbsw13(.clk_i(clk), .btn_i(sw_i[13]), .debounce_o(switch_o[13]));
    debouncer dbsw14(.clk_i(clk), .btn_i(sw_i[14]), .debounce_o(switch_o[14]));
    debouncer dbsw15(.clk_i(clk), .btn_i(sw_i[15]), .debounce_o(switch_o[15]));
    
endmodule
