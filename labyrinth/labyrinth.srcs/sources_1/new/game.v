`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2024 07:25:32 AM
// Design Name: 
// Module Name: game
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


module game #(parameter MAP_SIZE = 32, MOVE_SIZE = 5) (
    input clk,
    input rst,
    input move_up_i, // hareket girdisi
    input move_down_i,
    input move_left_i,
    input move_right_i,
    input break_wall_i, // duvar kirma girdisi
    input load_map_i,   // haritayi yukle girdisi
    input random_map_i, // haritanin rastgele mi olusturulacagi girdisi
    input [3:0] select_map_i, // onceden belirlenmis haritalarin secim girdisi
    input auto_level_up_i,    // otomatik seviye atlanilacak mi girdisi
    input  [(MAP_SIZE * MAP_SIZE)-1:0] map1, //onceden tanimli haritalar
    input  [(MAP_SIZE * MAP_SIZE)-1:0] map2,
    input  [(MAP_SIZE * MAP_SIZE)-1:0] map3,
    input  [(MAP_SIZE * MAP_SIZE)-1:0] map4,
    output [MOVE_SIZE-1:0] goal_x_o, // hedef bilgisi
    output [MOVE_SIZE-1:0] goal_y_o,
    output [MOVE_SIZE-1:0] player_x_o, // konum bilgisi
    output [MOVE_SIZE-1:0] player_y_o,
    output [(MAP_SIZE * MAP_SIZE)-1:0] map_o, // harita bilgisi
    output reg [13:0] points_o, // puan bilgisi
    output reg [15:0] break_wall_lives_o // tuzak kirma sayisi bilgisi
    );
    
    reg [(MAP_SIZE * MAP_SIZE)-1:0] map_init;
    reg [MOVE_SIZE-1:0] player_x_init;
    reg [MOVE_SIZE-1:0] player_y_init;
    reg [MOVE_SIZE-1:0] goal_x_init;
    reg [MOVE_SIZE-1:0] goal_y_init;
    
    wire [(MAP_SIZE * MAP_SIZE)-1:0] map_rand;
    wire [MOVE_SIZE-1:0] player_x_rand;
    wire [MOVE_SIZE-1:0] player_y_rand;
    wire [MOVE_SIZE-1:0] goal_x_rand;
    wire [MOVE_SIZE-1:0] goal_y_rand;
    
    reg [2:0] map_selection;
    wire finished;
    reg finished_delayed;
    reg [1:0] auto_level_up_counter;
    
    reg [5:0] break_wall_life_counter;
    
    wire finished_edge;
    assign finished_edge = finished & ~finished_delayed;
    
    always @(posedge clk) finished_delayed <= finished;
    
    always @(posedge clk) begin
        if(rst)
            auto_level_up_counter <= 0;
        else begin
            if(auto_level_up_i) begin
                if(finished && ~finished_delayed)
                    auto_level_up_counter <= auto_level_up_counter + 1; // rastgele uretilmeyen haritalar icin seviye atlandiginda gelecek haritanin bilgisi
                else
                    auto_level_up_counter <= auto_level_up_counter;
            end
            else
                auto_level_up_counter <= 0;
        end
    end
    
    always @(posedge clk) begin
        if(rst)
            map_selection <= 0;
        else begin
            if(~auto_level_up_i) begin
                if(random_map_i)
                    map_selection <= 4;
                else if(select_map_i == 4'b0001)    // onceden belirlenmis harita secimi bilgisi
                    map_selection <= 0;
                else if(select_map_i[3:1] == 3'b001)
                    map_selection <= 1;
                else if(select_map_i[3:2] == 2'b01)
                    map_selection <= 2;
                else if(select_map_i[3] == 1)
                    map_selection <= 3;
            end
            else begin
                if(random_map_i)
                    map_selection <= 4; // rastgele ve ya onceden belirlenmis haritanin atanma bilgisi
                else begin
                    map_selection <= auto_level_up_counter;
                end
            end
        end
    end 
   
    always @(posedge clk) begin
        if(rst) begin
            map_init <= 0;
            player_x_init <= 0;
            player_y_init <= 0;
            goal_x_init <= 0;
            goal_y_init <= 0;
        end
        else begin
            if(map_selection == 4) begin
                map_init <= map_rand;           // haritalarin uygun sekiled labyrinth_game modulune aktarilmasi
                player_x_init <= player_x_rand; 
                player_y_init <= player_y_rand;
                goal_x_init <= goal_x_rand;
                goal_y_init <= goal_y_rand;
            end
            else if(map_selection == 0) begin
                map_init <= map1;
                player_x_init <= player_x_rand; 
                player_y_init <= player_y_rand;
                goal_x_init <= goal_x_rand;
                goal_y_init <= goal_y_rand;
            end
            else if(map_selection == 1) begin
                map_init <= map2;
                player_x_init <= player_x_rand; 
                player_y_init <= player_y_rand;
                goal_x_init <= goal_x_rand;
                goal_y_init <= goal_y_rand;
            end
            else if(map_selection == 2) begin
                map_init <= map3;
                player_x_init <= player_x_rand; 
                player_y_init <= player_y_rand;
                goal_x_init <= goal_x_rand;
                goal_y_init <= goal_y_rand;
            end
            else if(map_selection == 3) begin
                map_init <= map4;
                player_x_init <= player_x_rand; 
                player_y_init <= player_y_rand;
                goal_x_init <= goal_x_rand;
                goal_y_init <= goal_y_rand;
            end
        end
    end
    
    always @(posedge clk) begin
        if(rst)
            break_wall_life_counter <= 0;
        else begin
            if(auto_level_up_i ? finished_edge : load_map_i)    // her yeni haritada tuzak temizleme hakki sifirlanir
                break_wall_life_counter <= 16;                  // finished'in iki saat cevrimi geldigi fark edildigi icin sadece yukselen tarafi
            else if(break_wall_i > 0)                           // dikkate alinmaktadir
                break_wall_life_counter <= break_wall_life_counter - 1; // tuzak temizleme hakkinin takibi
            else
                 break_wall_life_counter <= break_wall_life_counter;
        end
    end
    
    always @(posedge clk) begin
        if(rst)
            break_wall_lives_o <= 16'b0000000000000000;
        else begin
            case(break_wall_life_counter)
                4'b00000: break_wall_lives_o <= 16'b0000000000000000; // Tuzak temizleme hakkinin FPGA ledleri uzerindeki gostergesi
                4'b00001: break_wall_lives_o <= 16'b0000000000000001;
                4'b00010: break_wall_lives_o <= 16'b0000000000000011;
                4'b00011: break_wall_lives_o <= 16'b0000000000000111;
                4'b00100: break_wall_lives_o <= 16'b0000000000001111;
                4'b00101: break_wall_lives_o <= 16'b0000000000011111;
                4'b00110: break_wall_lives_o <= 16'b0000000000111111;
                4'b00111: break_wall_lives_o <= 16'b0000000001111111;
                4'b01000: break_wall_lives_o <= 16'b0000000011111111;
                4'b01001: break_wall_lives_o <= 16'b0000000111111111;
                4'b01010: break_wall_lives_o <= 16'b0000001111111111;
                4'b01011: break_wall_lives_o <= 16'b0000011111111111;
                4'b01100: break_wall_lives_o <= 16'b0000111111111111;
                4'b01101: break_wall_lives_o <= 16'b0001111111111111;
                4'b01110: break_wall_lives_o <= 16'b0011111111111111;
                4'b01111: break_wall_lives_o <= 16'b0111111111111111;
                5'b10000: break_wall_lives_o <= 16'b1111111111111111;
                default:  break_wall_lives_o <= break_wall_lives_o; 
            endcase
        end
    end
    
    always @(posedge clk) begin
        if(rst)
            points_o <= 0;
        else begin
            if(finished_edge && ~load_map_i) begin
                if(break_wall_life_counter > 11)            // Kac tuzak temizleme yapildigina gore bolum sonu puanlandirma
                    points_o <= points_o + (100 * MOVE_SIZE); // Oyun zorluguna gore oyuncu daha cok puan kazanir
                else if(break_wall_life_counter > 7)
                    points_o <= points_o + (50 * MOVE_SIZE);
                else if(break_wall_life_counter > 3)
                    points_o <= points_o + (25 * MOVE_SIZE);
                else if(break_wall_life_counter > 0)
                    points_o <= points_o + (10 * MOVE_SIZE);
                else
                    points_o <= points_o - (25 * MOVE_SIZE); // Tuzak temizleme haklari bittiyse oyuncu puan kaybeder
            end 
        end
    end
    
    map_generator #(.MAP_SIZE(MAP_SIZE), .MOVE_SIZE(MOVE_SIZE))  map_generator_inst( // rastgele harita uretici
        .clk(clk),
        .rst(rst),
        .map_o(map_rand),
        .player_x_o(player_x_rand),
        .player_y_o(player_y_rand),
        .goal_x_o(goal_x_rand),
        .goal_y_o(goal_y_rand)
    );

    labyrinth_game #(.MAP_SIZE(MAP_SIZE), .MOVE_SIZE(MOVE_SIZE)) labyrinth_game_inst ( // oyun temel mantigi
        .clk(clk),
        .rst(rst),
        .move_up_i(move_up_i),
        .move_down_i(move_down_i),
        .move_left_i(move_left_i),
        .move_right_i(move_right_i),
        .break_wall_i(break_wall_i),
        .load_map_i(rst ? 1'b0 : (auto_level_up_i ? finished : load_map_i)),
        .map_init_i(map_init),
        .player_x_init_i(player_x_init),
        .player_y_init_i(player_y_init),
        .goal_x_init_i(goal_x_init),
        .goal_y_init_i(goal_y_init),
        .goal_x_o(goal_x_o),
        .goal_y_o(goal_y_o),
        .finished_o(finished),
        .player_x_o(player_x_o),
        .player_y_o(player_y_o),
        .map_o(map_o)
);

endmodule
