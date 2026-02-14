`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2024 06:17:24 PM
// Design Name: 
// Module Name: labyrinth_game
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

module labyrinth_game #(parameter MAP_SIZE = 32, MOVE_SIZE = 5) (
    input clk,
    input rst,
    input move_up_i,    // Hareket girdileri
    input move_down_i,
    input move_left_i,
    input move_right_i,
    input break_wall_i, // Duvar kirma girdisi
    input load_map_i,   // Harita yukleme girdisi
    input [(MAP_SIZE * MAP_SIZE)-1:0] map_init_i, // Initler ilgili degiskenin ilk degerleridir
    input [MOVE_SIZE-1:0] player_x_init_i,
    input [MOVE_SIZE-1:0] player_y_init_i,
    input [MOVE_SIZE-1:0] goal_x_init_i,
    input [MOVE_SIZE-1:0] goal_y_init_i,
    output reg [MOVE_SIZE-1:0] goal_x_o,    // Ilkdegeri aldiktan sonra verilen hedef bilgisi
    output reg [MOVE_SIZE-1:0] goal_y_o,
    output reg finished_o,                  // Hedefe ulasildi bilgisi
    output reg [MOVE_SIZE-1:0] player_x_o,  
    output reg [MOVE_SIZE-1:0] player_y_o,  // Guncellenen harita ve oyuncu konumu bilgileriv 
    output reg [(MAP_SIZE * MAP_SIZE)-1:0] map_o
);

    reg [9:0] idx;      // 2 boyutlu bir haritayi tek boyutlu bir register arrayinde saklarken uygun sekilde indexlemek icin bir index degiskeni olusturmamiz gerekit
    reg current_cell;   // Indexe bagli olarak harita uzerindeki konumdaki bilgiyi verir (tuzak bilgisi)
    
    always @* begin
        if(rst)
            idx <= 0;                                       // Sutunlar ardisik, satirlar MAP_SIZE boyutunda olmak uzere harita bu sekilde indexlenir
        else                                                // 32x32 bir harita icin ilk satir ilk sutun x=0, y=0 -> 0 + y*0 = 0
            idx = player_x_o + (player_y_o << (MOVE_SIZE)); // ve 2. satir 2. sutun x=1, y=1 -> 1 + 32*1 = 33 olarak elde edilebilir
    end                                                     
                                                            
    always @* begin
        if(rst)
            current_cell = 0;
        else
            current_cell = map_o[idx];  // O indexte tuzak olup olmadigini belirtir
    end
        
    always @(posedge clk) begin
        if(rst) begin
            goal_x_o <= MAP_SIZE-1;    // Reset halinde hedef haritanin sag alt kosesine yerlestirilmistir
            goal_y_o <= MAP_SIZE-1;
        end
        else if(load_map_i) begin
            goal_x_o <= goal_x_init_i;  // Rastgele tanimlanma halinde hedefin tutulabilmesi icin ilk deger alir
            goal_y_o <= goal_y_init_i;
        end
        else begin
            goal_x_o <= goal_x_o;       // Devaminda ilk degeri program calisma suresi boyunca saklar
            goal_y_o <= goal_y_o;
        end
    end
    
    always @(posedge clk) begin
        if(rst)
            map_o <= 0;     // Reset halinde harita sifirlanir
        else begin
            if(load_map_i)
                map_o <= map_init_i;    // Harita yukleme mantigi
                
            else if(break_wall_i == 1)
                map_o[idx] <= 0;        // Mantik-1 duvari ifade etmek uzere duvar kirma mantigi bu sekilde gerceklenir
                
            else
                map_o <= map_o;         // Bir degisim olmamasi halinde harita ayni degeri korur
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            player_x_o <= 0;    // Reset halinde oyuncu haritanin sol ust kosesine yerlestirilir
            player_y_o <= 0;    
        end
            else begin 
            if (current_cell == 1'b0) begin
                if(load_map_i == 1) begin
                    player_x_o <= player_x_init_i;  // Oyuncunun ilk konumu harita yuklenirken verilir
                    player_y_o <= player_y_init_i;
                end
                else if (move_up_i && player_y_o > 0)   // Oyuncuyu harita sinirlarinda tutar
                    player_y_o <= player_y_o - 1;       // Uygun sekilde oyuncuyu hareket ettirir
                    
                else if (move_down_i && player_y_o < MAP_SIZE-1)
                    player_y_o <= player_y_o + 1;
                    
                else if (move_left_i && player_x_o > 0)
                    player_x_o <= player_x_o - 1;
                    
                else if (move_right_i && player_x_o < MAP_SIZE-1)
                    player_x_o <= player_x_o + 1;
                    
                else begin
                    player_x_o <= player_x_o;   // Gecerli bir hareket ettirme durumu olusmazsa konum bilgisi korunur
                    player_y_o <= player_y_o;
                end
            end
        end
    end
    
    always @(posedge clk) begin
        if(rst)
            finished_o <= 0;
        else begin
            if((player_x_o == goal_x_o) && (player_y_o == goal_y_o))    // Oyuncunun hedefe ulasmasi halinde oyun bitti bilgisi verilir
                finished_o <= 1;
                
            else if(load_map_i == 1)
                finished_o <= 0;
                
            else
                finished_o <= finished_o;
        end
    end

endmodule

