`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 04:17:18 AM
// Design Name: 
// Module Name: prand_num_gen_32
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


module prand_num_gen_32(
    input clk, // 100 MHz saatle yuksek degisimli bir gurultu elde edilir
    input rst,
    input [31:0] initial_seed,
    output reg [31:0] random_number
);

    // xorlanacak tap-in noktalari
    wire feedback = random_number[31] ^ random_number[21] ^ random_number[1] ^ random_number[0];

    always @(posedge clk) begin
        if (rst) begin
            random_number <= initial_seed;
        end else begin
            random_number <= {random_number[30:0], feedback}; // kapali cevrim feedbacki buradan eklenir
        end
    end

endmodule