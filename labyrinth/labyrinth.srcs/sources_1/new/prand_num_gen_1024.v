`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 04:05:47 AM
// Design Name: 
// Module Name: prand_num_gen_1024
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

module prand_num_gen_1024(
    input clk, // 100 MHz saatle yuksek degisimli bir gurultu elde edilir
    input rst,
    input [1023:0] initial_seed,
    output reg [1023:0] random_number
);

    // xorlanacak tap-in noktalari
    wire feedback = (random_number[1023] ^ random_number[1010] ^ random_number[500] ^ random_number[250] ^ random_number[100] ^ random_number[50] ^ random_number[1]) & (~random_number[350]) & (~random_number[750]);

    always @(posedge clk) begin
        if (rst) begin
            random_number <= initial_seed;
        end else begin
            random_number <= {random_number[1022:0], feedback}; // kapali cevrim feedbacki buradan eklenir
        end
    end

endmodule
