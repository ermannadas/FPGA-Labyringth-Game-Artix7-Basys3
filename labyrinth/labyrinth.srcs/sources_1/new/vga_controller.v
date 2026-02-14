`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2024 07:07:53 PM
// Design Name: 
// Module Name: vga_controller
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

module vga_controller (
    input wire clk,
    input wire rst,
    output wire hsync,
    output wire vsync,
    output wire display_on,
    output wire [9:0] pixel_x,
    output wire [9:0] pixel_y
);

    // referansta belirtilen zamanlara gore counterlar yazilmis ve counterlar pikselleri indislemistir

    // VGA 640x480 @60Hz
    localparam H_DISP = 640;
    localparam H_FP = 16;       
    localparam H_PW = 96;     
    localparam H_BP = 48;
    localparam H_SYNC = H_DISP + H_FP + H_PW + H_BP; // 800

    localparam V_DISP = 480;
    localparam V_FP = 10;
    localparam V_PW = 2;
    localparam V_BP = 33;
    localparam V_SYNC = V_DISP + V_FP + V_PW + V_BP; // 525

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    always @(posedge clk) begin
        if (rst) begin
            h_counter <= 0;
        end else begin
            if(h_counter == (H_SYNC - 1))
                h_counter <= 0;
            else
                h_counter <= h_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            v_counter <= 0;
        end else begin
            if(h_counter == (H_SYNC - 1)) begin
                if(v_counter == (V_SYNC - 1))
                    v_counter <= 0;
                else
                    v_counter <= v_counter + 1;
            end
        end
    end

    assign hsync = ~((h_counter >= (H_DISP + H_FP)) && (h_counter < (H_DISP + H_FP + H_PW))); // Line senkronunun olup olmadigini belirtir
    assign vsync = ~((v_counter >= (V_DISP + V_FP)) && (v_counter < (V_DISP + V_FP + V_PW))); // Frame senkronunun olup olmadigini belirtir

    assign display_on = (h_counter < H_DISP) && (v_counter < V_DISP); // Gorunebilir alandan sonraki pikseller icin monitoru surmez
                                                                            // boylece counterin o kisimlari sadece zaman senkronizasyonunu saglar
    assign pixel_x = h_counter;
    assign pixel_y = v_counter;

endmodule