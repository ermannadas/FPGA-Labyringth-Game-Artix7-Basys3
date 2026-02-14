`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 03:58:45 AM
// Design Name: 
// Module Name: map_generator
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


module map_generator #(parameter MAP_SIZE = 32, MOVE_SIZE = 5) (
    input clk,
    input rst,
    output reg [(MAP_SIZE * MAP_SIZE)-1:0] map_o,
    output reg [MOVE_SIZE-1:0] player_x_o,
    output reg [MOVE_SIZE-1:0] player_y_o,
    output reg [MOVE_SIZE-1:0] goal_x_o,
    output reg [MOVE_SIZE-1:0] goal_y_o
    );
    
    // rastgele sekilde harita ve konumlar olusturulmustur
    
    wire [1023:0] map;
    prand_num_gen_1024 map_generator_1024 (
        .clk(clk),
        .rst(rst),
        .initial_seed(1024'h69b48186ce9ec4c6cc5d34a1d8ab90621eb03ef04f7e19a77fcd34783c85c436c12e046180b665b885df81a5269e55b6b4937bb822eb189eb451dabc002ebb2d1ceb0d9462ca3bb069b48186ce9ec4c6cc5d34a1d8ab90621eb03ef04f7e19a77fcd34783c85c436c12e046180b665b885df81a5269e55b6b4937bb822eb189e),
        .random_number(map)
    );
    
    wire [4:0] player_x;
    prand_num_gen_32 player_x_generator_32 (
        .clk(clk),
        .rst(rst),
        .initial_seed(32'hff9c4c6e),
        .random_number(player_x)
    );
    
    wire [4:0] player_y;
    prand_num_gen_32 player_y_generator_32 (
        .clk(clk),
        .rst(rst),
        .initial_seed(32'h947e01a7),
        .random_number(player_y)
    );
    
    wire [4:0] goal_x;
    prand_num_gen_32 goal_x_generator_32 (
        .clk(clk),
        .rst(rst),
        .initial_seed(32'h6e8b7f65),
        .random_number(goal_x)
    );
    
    wire [4:0] goal_y;
    prand_num_gen_32 goal_y_generator_32 (
        .clk(clk),
        .rst(rst),
        .initial_seed(32'h02851647),
        .random_number(goal_y)
    );
    
    
    reg [(MAP_SIZE * MAP_SIZE)-1:0] map_adj;
    reg [MOVE_SIZE-1:0] goal_x_adj;
    reg [MOVE_SIZE-1:0] goal_y_adj;
    
    always @* begin
        if(goal_x == player_x && goal_y == player_y) begin
            goal_y_adj = (goal_x > 103) ? goal_x - 103 : goal_x + 103; // Eger oyuncu ile hedef ayni konumda olura hedefin yeri degistirilir
            goal_x_adj = (goal_x < 104) ? goal_x + 104 : goal_x - 104;
        end
        else begin
            goal_x_adj = goal_x;
            goal_y_adj = goal_y;
        end
        map_adj = map;
        map_adj[player_x + (player_y << (MOVE_SIZE))] = 0; // Oyuncu ve hedefin oldugu konumlarda tuzak olamaz
        map_adj[goal_x + (goal_y << (MOVE_SIZE))] = 0;
    end
    
    always @(posedge clk) begin
        if(rst) begin
            map_o <= 0;
            player_x_o <= 0;
            player_y_o <= 0;
            goal_x_o <= 0;
            goal_y_o <= 0;
        end
        else begin
            map_o <= map_adj;
            player_x_o <= player_x;
            player_y_o <= player_y;
            goal_x_o <= goal_x_adj;
            goal_y_o <= goal_y_adj;
        end
    end
    
endmodule
