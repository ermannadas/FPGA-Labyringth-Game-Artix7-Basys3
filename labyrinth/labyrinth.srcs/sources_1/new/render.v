`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2024 11:10:43 PM
// Design Name: 
// Module Name: render
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


module render #(parameter MAP_SIZE = 32, MOVE_SIZE = 5) (
    input clk,
    input rst,
    
    input [(MAP_SIZE * MAP_SIZE)-1:0] game_map_i, // Harita bilgileri buradan alinir
    input [MOVE_SIZE-1:0] player_x_i,
    input [MOVE_SIZE-1:0] player_y_i,
    input [MOVE_SIZE-1:0] goal_x_i,
    input [MOVE_SIZE-1:0] goal_y_i,
    
    output Hsync_o,          // VGA portuna verilecek sinyaller
    output Vsync_o,
    output [3:0] vgaRed_o,
    output [3:0] vgaGreen_o,
    output [3:0] vgaBlue_o
    
    );
       
    wire [9:0] pixel_x; // pixel konumu
    wire [9:0] pixel_y;
    wire display_on;

    vga_controller vga_unit ( // vga surucusu pixelleri tarar
        .clk(clk),
        .rst(rst),
        .hsync(Hsync_o),
        .vsync(Vsync_o),
        .display_on(display_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    localparam integer CELL_WIDTH = 640 / MAP_SIZE;      // gruplanacak hucre boyutu burada belirleni
    localparam integer CELL_HEIGHT = 480 / MAP_SIZE;

    wire [MOVE_SIZE-1:0] cell_x = pixel_x / CELL_WIDTH;  // pixeller 640 x 480 cozunurluk icin harita boyutuna gore gruplanir
    wire [MOVE_SIZE-1:0] cell_y = pixel_y / CELL_HEIGHT; // her gruplanmis hucre haritanin bir indisini ifade eder

    wire [MOVE_SIZE+MOVE_SIZE-1:0] cidx = (cell_y << MOVE_SIZE) + cell_x;                        // harita indexiyle ayni hucre indexi
    wire current_cell_bit = (cell_x < MAP_SIZE && cell_y < MAP_SIZE) ? game_map_i[cidx] : 1'b0;  // harita hucrenin indexine gore indexlenir

    wire [9:0] local_x = pixel_x % CELL_WIDTH;  // oyuncunun bastirilmasi icin her hucre local olarak indislenir
    wire [9:0] local_y = pixel_y % CELL_HEIGHT;

    wire player_here = (cell_x == player_x_i) && (cell_y == player_y_i);    // oyuncunun o hucrede olup olmadigi belirlenir
    wire player_pixel = (local_x >= CELL_WIDTH/4 && local_x <= (3*CELL_WIDTH)/4 && local_y >= CELL_WIDTH/4 && local_y <= (3*CELL_WIDTH)/4); // oyuncu local hucrede bu boyutlarda renderlanir

    reg [3:0] red, green, blue;
    always @(*) begin
        if (!display_on) begin
            red = 0;
            green = 0;
            blue = 0;
        end 
        else begin
            if (cell_x == goal_x_i && cell_y == goal_y_i) begin // hedefin renderlanmasi
                if (player_here && player_pixel) begin
                    red = 4'hF; green = 4'd0; blue = 4'd0;  // localde oyuncunun oldugu yerler kirmiziya boyanir
                end else begin
                    red = 4'd0; green = 4'hF; blue = 4'd0;  // kalanlar yesil
                end
            end 
            else if (current_cell_bit == 1'b1) begin            // tuzagin renderlanmasi
                if (player_here && player_pixel) begin
                    red = 4'hF; green = 4'd0; blue = 4'd0;
                end 
                else begin
                    red = 4'd0; green = 4'd0; blue = 4'd0;  // kalanlar siyah
                end
            end 
            else begin
                if (player_here && player_pixel) begin          // bos indisin renderlanmasi
                    red = 4'hF; green = 0; blue = 0;
                end 
                else begin
                    red = 4'hF; green = 4'hF; blue = 4'hF;  //kalanlar beyaz
                end
            end
        end
    end

    assign vgaRed_o   = red;    // renk yogunluklari vgaya gonderilir
    assign vgaGreen_o = green;
    assign vgaBlue_o  = blue;

endmodule
