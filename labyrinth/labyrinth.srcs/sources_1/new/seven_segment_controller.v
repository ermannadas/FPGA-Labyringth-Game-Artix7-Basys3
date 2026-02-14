`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 11:27:11 PM
// Design Name: 
// Module Name: seven_segment_controller
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


module seven_segment_controller(
    input clk, 
    input rst, 
    input [15:0] num,
    output reg [6:0] segments,
    output reg [3:0] digit_select
    );

    reg [1:0] current_digit;
    reg [19:0] refresh_clock;
    

    always @(*) begin
        // dolasilan basamaga gore segment katotlarini ayarlar
        case(current_digit)
            2'd0: begin
                case(num[3:0])
                    4'd0: segments = 7'b1000000;
                    4'd1: segments = 7'b1111001;
                    4'd2: segments = 7'b0100100;
                    4'd3: segments = 7'b0110000;
                    4'd4: segments = 7'b0011001;
                    4'd5: segments = 7'b0010010;
                    4'd6: segments = 7'b0000010;
                    4'd7: segments = 7'b1111000;
                    4'd8: segments = 7'b0000000;
                    4'd9: segments = 7'b0010000;
                    default: segments = 7'b0000000;
                endcase
            end
            2'd1: begin
                case(num[7:4])
                    4'd0: segments = 7'b1000000;
                    4'd1: segments = 7'b1111001;
                    4'd2: segments = 7'b0100100;
                    4'd3: segments = 7'b0110000;
                    4'd4: segments = 7'b0011001;
                    4'd5: segments = 7'b0010010;
                    4'd6: segments = 7'b0000010;
                    4'd7: segments = 7'b1111000;
                    4'd8: segments = 7'b0000000;
                    4'd9: segments = 7'b0010000;
                    default: segments = 7'b0000000;
                endcase
            end
            2'd2: begin
                case(num[11:8])
                    4'd0: segments = 7'b1000000;
                    4'd1: segments = 7'b1111001;
                    4'd2: segments = 7'b0100100;
                    4'd3: segments = 7'b0110000;
                    4'd4: segments = 7'b0011001;
                    4'd5: segments = 7'b0010010;
                    4'd6: segments = 7'b0000010;
                    4'd7: segments = 7'b1111000;
                    4'd8: segments = 7'b0000000;
                    4'd9: segments = 7'b0010000;
                    default: segments = 7'b0000000;
                endcase
            end
            2'd3: begin
                case(num[15:12])
                    4'd0: segments = 7'b1000000;
                    4'd1: segments = 7'b1111001;
                    4'd2: segments = 7'b0100100;
                    4'd3: segments = 7'b0110000;
                    4'd4: segments = 7'b0011001;
                    4'd5: segments = 7'b0010010;
                    4'd6: segments = 7'b0000010;
                    4'd7: segments = 7'b1111000;
                    4'd8: segments = 7'b0000000;
                    4'd9: segments = 7'b0010000;
                    default: segments = 7'b0000000;
                endcase
            end
            default: segments = 7'b0000000;
        endcase
    end

    // 100MHz / 4000 = 100000000 / 4000 = 25000 = 25 kHz yenilenme frekansi bu sekilde belirlenir
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_clock <= 0;
        end else begin
            if(refresh_clock == 3999)
                refresh_clock <= 0;
            else
                refresh_clock <= refresh_clock + 1;
        end
    end

    // yenilenme frekansinda basamaklari dolasir
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_digit <= 0;
        end else begin
            if(refresh_clock == 0)
                current_digit <= current_digit + 1;
        end
    end

    // dolasilan basamaga gore anotlari ayarlar
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_select <= 4'b1110;
        end else begin
            case(current_digit)
                2'd0: digit_select <= 4'b1110;
                2'd1: digit_select <= 4'b1101;
                2'd2: digit_select <= 4'b1011;
                2'd3: digit_select <= 4'b0111;
                default: digit_select <= 4'b1111;
            endcase
        end
    end

endmodule