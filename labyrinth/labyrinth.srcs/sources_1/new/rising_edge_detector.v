`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2024 11:00:07 PM
// Design Name: 
// Module Name: rising_edge_detector
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


module rising_edge_detector(
    input clk,
    input signal_i,
    output rising_edge_o
    );

    // eger sinyal 1 ken bir cevrim delaylenmis hali 0sa o cevrim sinyalin rising edgeidir
    
    reg signal_delayed;
    
    always @(posedge clk) begin
        signal_delayed <= signal_i;
    end
    
    assign rising_edge_o = (signal_delayed == 0) && (signal_i == 1);
    
endmodule
