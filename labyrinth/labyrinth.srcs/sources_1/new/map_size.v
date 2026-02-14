`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2024 02:38:53 AM
// Design Name: 
// Module Name: map_size
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


module map_size(
    input clk_game,
    input clk_render,
    input rst,
    input [3:0] map_size_i,
    input move_up_i,
    input move_down_i,
    input move_left_i,
    input move_right_i,
    input break_wall_i,
    input load_map_i,
    input random_map_i,
    input [3:0] select_map_i,
    input auto_level_up_i,
    output reg [13:0] points_o,
    output reg [15:0] break_wall_lives_o,
    output reg Hsync_o,
    output reg Vsync_o,
    output reg [3:0] vgaRed_o,
    output reg [3:0] vgaGreen_o,
    output reg [3:0] vgaBlue_o
    );

    // 4x4, 8x8, 16x16 ve 32x32 boyutlari icin 4 adet game modulu instantiate edilmistir
    // oyun zorluguna bagli olarak bu modullerden biri secilir, secilmeyen modul reset durumunda tutulur
    // boylece zorluk her degistiginde yeni bir oyun baslamis olur

    wire [3:0] player_x_4x4, player_y_4x4, goal_x_4x4, goal_y_4x4;
    wire [15:0] map_4x4;
    wire Hsync_4x4, Vsync_4x4;
    wire [3:0] vgaRed_4x4, vgaGreen_4x4, vgaBlue_4x4;
    wire [13:0] points_o_4x4;
    wire [15:0] break_wall_lives_o_4x4;

    wire rst_4x4 =  rst & ~(map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1]);
    wire move_up_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? move_up_i : 0;
    wire move_down_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? move_down_i : 0;
    wire move_left_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? move_left_i : 0;
    wire move_right_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? move_right_i : 0;
    wire break_wall_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? break_wall_i : 0;
    wire load_map_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? load_map_i : 0;
    wire random_map_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? random_map_i : 0;
    wire [3:0] select_map_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? select_map_i : 4'b0;
    wire auto_level_up_i_4x4 = map_size_i[0] & ~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] ? auto_level_up_i : 0;
    
    wire [15:0] map_1_4x4 = 16'h3CDF;
    wire [15:0] map_2_4x4 = 16'h3C9F;
    wire [15:0] map_3_4x4 = 16'h3E9F;
    wire [15:0] map_4_4x4 = 16'h3DBF;

    game #(.MAP_SIZE(4), .MOVE_SIZE(2)) game_4x4 (
        .clk(clk_game),
        .rst(rst_4x4),
        .move_up_i(move_up_i_4x4),
        .move_down_i(move_down_i_4x4),
        .move_left_i(move_left_i_4x4),
        .move_right_i(move_right_i_4x4),
        .break_wall_i(break_wall_i_4x4),
        .load_map_i(load_map_i_4x4),
        .random_map_i(random_map_i_4x4),
        .select_map_i(select_map_i_4x4),
        .auto_level_up_i(auto_level_up_i_4x4),
        .map1(map_1_4x4),
        .map2(map_2_4x4),
        .map3(map_3_4x4),
        .map4(map_4_4x4),
        .goal_x_o(goal_x_4x4),
        .goal_y_o(goal_y_4x4),
        .player_x_o(player_x_4x4),
        .player_y_o(player_y_4x4),
        .map_o(map_4x4),
        .points_o(points_o_4x4),
        .break_wall_lives_o(break_wall_lives_o_4x4)
    );

    render #(.MAP_SIZE(4), .MOVE_SIZE(2)) render_4x4 (
        .clk(clk_render),
        .rst(rst),
        .game_map_i(map_4x4),
        .player_x_i(player_x_4x4),
        .player_y_i(player_y_4x4),
        .goal_x_i(goal_x_4x4),
        .goal_y_i(goal_y_4x4),
        .Hsync_o(Hsync_4x4),
        .Vsync_o(Vsync_4x4),
        .vgaRed_o(vgaRed_4x4),
        .vgaGreen_o(vgaGreen_4x4),
        .vgaBlue_o(vgaBlue_4x4)
    );

    wire rst_8x8 = rst | ~(map_size_i[1] & ~map_size_i[3] & ~map_size_i[2]);
    wire move_up_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? move_up_i : 0;
    wire move_down_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? move_down_i : 0;
    wire move_left_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? move_left_i : 0;
    wire move_right_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? move_right_i : 0;
    wire break_wall_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? break_wall_i : 0;
    wire load_map_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? load_map_i : 0;
    wire random_map_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? random_map_i : 0;
    wire [3:0] select_map_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? select_map_i : 4'b0;
    wire auto_level_up_i_8x8 = map_size_i[1] & ~map_size_i[3] & ~map_size_i[2] ? auto_level_up_i : 0;
    
    wire [7:0] player_x_8x8, player_y_8x8, goal_x_8x8, goal_y_8x8;
    wire [63:0] map_8x8;
    wire Hsync_8x8, Vsync_8x8;
    wire [3:0] vgaRed_8x8, vgaGreen_8x8, vgaBlue_8x8;
    wire [13:0] points_o_8x8;
    wire [15:0] break_wall_lives_o_8x8;
    
    wire [63:0] map_1_8x8 = 64'hFF81B9A1ADA181FF;
    wire [63:0] map_2_8x8 = 64'hFF81BD91F781B9FF;
    wire [63:0] map_3_8x8 = 64'hFF81B9A9A9B981FF;
    wire [63:0] map_4_8x8 = 64'hFF81E989A9A981FF;

    game #(.MAP_SIZE(8), .MOVE_SIZE(3)) game_8x8 (
        .clk(clk_game),
        .rst(rst_8x8),
        .move_up_i(move_up_i_8x8),
        .move_down_i(move_down_i_8x8),
        .move_left_i(move_left_i_8x8),
        .move_right_i(move_right_i_8x8),
        .break_wall_i(break_wall_i_8x8),
        .load_map_i(load_map_i_8x8),
        .random_map_i(random_map_i_8x8),
        .select_map_i(select_map_i_8x8),
        .auto_level_up_i(auto_level_up_i_8x8),
        .map1(map_1_8x8),
        .map2(map_2_8x8),
        .map3(map_3_8x8),
        .map4(map_4_8x8),
        .goal_x_o(goal_x_8x8),
        .goal_y_o(goal_y_8x8),
        .player_x_o(player_x_8x8),
        .player_y_o(player_y_8x8),
        .map_o(map_8x8),
        .points_o(points_o_8x8),
        .break_wall_lives_o(break_wall_lives_o_8x8)
    );

    render #(.MAP_SIZE(8), .MOVE_SIZE(3)) render_8x8 (
        .clk(clk_render),
        .rst(rst),
        .game_map_i(map_8x8),
        .player_x_i(player_x_8x8),
        .player_y_i(player_y_8x8),
        .goal_x_i(goal_x_8x8),
        .goal_y_i(goal_y_8x8),
        .Hsync_o(Hsync_8x8),
        .Vsync_o(Vsync_8x8),
        .vgaRed_o(vgaRed_8x8),
        .vgaGreen_o(vgaGreen_8x8),
        .vgaBlue_o(vgaBlue_8x8)
    );

    wire rst_16x16 = rst | ~(map_size_i[2] & ~map_size_i[3]);
    wire move_up_i_16x16 = map_size_i[2] & ~map_size_i[3] ? move_up_i : 0;
    wire move_down_i_16x16 = map_size_i[2] & ~map_size_i[3] ? move_down_i : 0;
    wire move_left_i_16x16 = map_size_i[2] & ~map_size_i[3] ? move_left_i : 0;
    wire move_right_i_16x16 = map_size_i[2] & ~map_size_i[3] ? move_right_i : 0;
    wire break_wall_i_16x16 = map_size_i[2] & ~map_size_i[3] ? break_wall_i : 0;
    wire load_map_i_16x16 = map_size_i[2] & ~map_size_i[3] ? load_map_i : 0;
    wire random_map_i_16x16 = map_size_i[2] & ~map_size_i[3] ? random_map_i : 0;
    wire [3:0] select_map_i_16x16 = map_size_i[2] & ~map_size_i[3] ? select_map_i : 4'b0;
    wire auto_level_up_i_16x16 = map_size_i[2] & ~map_size_i[3] ? auto_level_up_i : 0;
    
    wire [15:0] player_x_16x16, player_y_16x16, goal_x_16x16, goal_y_16x16;
    wire [255:0] map_16x16;
    wire Hsync_16x16, Vsync_16x16;
    wire [3:0] vgaRed_16x16, vgaGreen_16x16, vgaBlue_16x16;
    wire [13:0] points_o_16x16;
    wire [15:0] break_wall_lives_o_16x16;

    wire [255:0] map_1_16x16 = 256'hAEBDA081BEFD8001FFFFA115AF55A855ABD5AA15AAF5AA05BBFD80018001FFFF;
    wire [255:0] map_2_16x16 = 256'hFFFF80018001957D9545955595559755945595D5941597F590059FFD8001FFFF;
    wire [255:0] map_3_16x16 = 256'hFFFF80019FBD902197AF90A19EAF82A1FAAF8AA1AABDA801AFFD80018001FFFF;
    wire [255:0] map_4_16x16 = 256'hFFFF8001BFFDA005AFE5A825ABA5AA25AAE5AAA5AAA5A2A5BEA580018001FFFF;
    
    game #(.MAP_SIZE(16), .MOVE_SIZE(4)) game_16x16 (
        .clk(clk_game),
        .rst(rst_16x16),
        .move_up_i(move_up_i_16x16),
        .move_down_i(move_down_i_16x16),
        .move_left_i(move_left_i_16x16),
        .move_right_i(move_right_i_16x16),
        .break_wall_i(break_wall_i_16x16),
        .load_map_i(load_map_i_16x16),
        .random_map_i(random_map_i_16x16),
        .select_map_i(select_map_i_16x16),
        .auto_level_up_i(auto_level_up_i_16x16),
        .map1(map_1_16x16),
        .map2(map_2_16x16),
        .map3(map_3_16x16),
        .map4(map_4_16x16),
        .goal_x_o(goal_x_16x16),
        .goal_y_o(goal_y_16x16),
        .player_x_o(player_x_16x16),
        .player_y_o(player_y_16x16),
        .map_o(map_16x16),
        .points_o(points_o_16x16),
        .break_wall_lives_o(break_wall_lives_o_16x16)
    );

    render #(.MAP_SIZE(16), .MOVE_SIZE(4)) render_16x16 (
        .clk(clk_render),
        .rst(rst),
        .game_map_i(map_16x16),
        .player_x_i(player_x_16x16),
        .player_y_i(player_y_16x16),
        .goal_x_i(goal_x_16x16),
        .goal_y_i(goal_y_16x16),
        .Hsync_o(Hsync_16x16),
        .Vsync_o(Vsync_16x16),
        .vgaRed_o(vgaRed_16x16),
        .vgaGreen_o(vgaGreen_16x16),
        .vgaBlue_o(vgaBlue_16x16)
    );

    wire rst_32x32 = rst | ~(map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0]));
    wire move_up_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? move_up_i : 0;
    wire move_down_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? move_down_i : 0;
    wire move_left_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? move_left_i : 0;
    wire move_right_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? move_right_i : 0;
    wire break_wall_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? break_wall_i : 0;
    wire load_map_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? load_map_i : 0;
    wire random_map_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? random_map_i : 0;
    wire [3:0] select_map_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? select_map_i : 4'b0;
    wire auto_level_up_i_32x32 = (map_size_i[3] | (~map_size_i[3] & ~map_size_i[2] & ~map_size_i[1] & ~map_size_i[0])) ? auto_level_up_i : 0;

    wire [31:0] player_x_32x32, player_y_32x32, goal_x_32x32, goal_y_32x32;
    wire [1023:0] map_32x32;
    wire Hsync_32x32, Vsync_32x32;
    wire [3:0] vgaRed_32x32, vgaGreen_32x32, vgaBlue_32x32;
    wire [13:0] points_o_32x32;
    wire [15:0] break_wall_lives_o_32x32;
    
    wire [1023:0] map_1_32x32 = 1024'hFFFFFFFFA000200187FF3FF980080009800BFE0980080209BFCFF3F98002200187F21FF980200009BF2FD5F980282A4187E82A3F80282A0181E82BC182082841A1E7E79FA0800401AF8FF3D1A08800918F8F3C918092249180F2279F8002200183FF3FF9820C0009A083FE09A0800209A08182099F8183F980018001FFFFFFFF;
    wire [1023:0] map_2_32x32 = 1024'hFFFFFFFFA000200187FF3FF980080009800BFE0980080209BFCFF3F98002200187F21FF980200009BF2FD5F980282A41FFE82A3F80282A0181E82BC182082841F9E7E79F80800401FF8FF3D1808800918F8F3C9188922491B8F2279F81002001F9FFDFF98100400981FFFE0981040209810902097F0F03F9800F0001FFFFFFFF;
    wire [1023:0] map_3_32x32 = 1024'hFFFFFFFFFFFFFFC980010049FBFF5E4981015249F9FD5249812552499F255249A125D249A1241249A127F249A1240249AF27FE4981200049B93F9FC980289209FFE893F980089001AFE89FC181088041F97E7E4181420241FF2FE24180442241FF473F3F814400018147FFC1814400418145F041BF441041807C0FC1FFFFFFFF;
    wire [1023:0] map_4_32x32 = 1024'hFFFFFFFFBFFFFFFFA00000018FFFFFF98900000989FFFFC989400249895FF249894002499F5FFE49815400499F57FFC9815400499F57FE49815402498F54F249895492498954924989549249894C924989409249897F92498980124989FFF2498900024989FFFE498900004983FFFFC980000009BFFFFFF980000001FFFFFFFF;

    game #(.MAP_SIZE(32), .MOVE_SIZE(5)) game_32x32 (
        .clk(clk_game),
        .rst(rst_32x32),
        .move_up_i(move_up_i_32x32),
        .move_down_i(move_down_i_32x32),
        .move_left_i(move_left_i_32x32),
        .move_right_i(move_right_i_32x32),
        .break_wall_i(break_wall_i_32x32),
        .load_map_i(load_map_i_32x32),
        .random_map_i(random_map_i_32x32),
        .select_map_i(select_map_i_32x32),
        .auto_level_up_i(auto_level_up_i_32x32),
        .map1(map_1_32x32),
        .map2(map_2_32x32),
        .map3(map_3_32x32),
        .map4(map_4_32x32),
        .goal_x_o(goal_x_32x32),
        .goal_y_o(goal_y_32x32),
        .player_x_o(player_x_32x32),
        .player_y_o(player_y_32x32),
        .map_o(map_32x32),
        .points_o(points_o_32x32),
        .break_wall_lives_o(break_wall_lives_o_32x32)
    );

    render #(.MAP_SIZE(32), .MOVE_SIZE(5)) render_32x32 (
        .clk(clk_render),
        .rst(rst),
        .game_map_i(map_32x32),
        .player_x_i(player_x_32x32),
        .player_y_i(player_y_32x32),
        .goal_x_i(goal_x_32x32),
        .goal_y_i(goal_y_32x32),
        .Hsync_o(Hsync_32x32),
        .Vsync_o(Vsync_32x32),
        .vgaRed_o(vgaRed_32x32),
        .vgaGreen_o(vgaGreen_32x32),
        .vgaBlue_o(vgaBlue_32x32)
    );
    
    always @(*) begin
        if(map_size_i[3] == 1) begin
            points_o <= points_o_32x32;
            break_wall_lives_o = break_wall_lives_o_32x32;
            Hsync_o = Hsync_32x32;
            Vsync_o = Vsync_32x32;
            vgaRed_o = vgaRed_32x32;
            vgaGreen_o = vgaGreen_32x32;
            vgaBlue_o = vgaBlue_32x32;
        end
        else if(map_size_i[2] == 1) begin
            points_o <= points_o_16x16;
            break_wall_lives_o = break_wall_lives_o_16x16;
            Hsync_o = Hsync_16x16;
            Vsync_o = Vsync_16x16;
            vgaRed_o = vgaRed_16x16;
            vgaGreen_o = vgaGreen_16x16;
            vgaBlue_o = vgaBlue_16x16;
        end
        else if(map_size_i[1] == 1) begin
            points_o <= points_o_8x8;
            break_wall_lives_o = break_wall_lives_o_8x8;
            Hsync_o = Hsync_8x8;
            Vsync_o = Vsync_8x8;
            vgaRed_o = vgaRed_8x8;
            vgaGreen_o = vgaGreen_8x8;
            vgaBlue_o = vgaBlue_8x8;
        end
        else if(map_size_i[0] == 1) begin
            points_o <= points_o_4x4;
            break_wall_lives_o = break_wall_lives_o_4x4;
            Hsync_o = Hsync_4x4;
            Vsync_o = Vsync_4x4;
            vgaRed_o = vgaRed_4x4;
            vgaGreen_o = vgaGreen_4x4;
            vgaBlue_o = vgaBlue_4x4;
        end
        else begin
            points_o <= points_o_32x32;
            break_wall_lives_o = break_wall_lives_o_32x32;
            Hsync_o = Hsync_32x32;
            Vsync_o = Vsync_32x32;
            vgaRed_o = vgaRed_32x32;
            vgaGreen_o = vgaGreen_32x32;
            vgaBlue_o = vgaBlue_32x32;
        end
    end

endmodule
