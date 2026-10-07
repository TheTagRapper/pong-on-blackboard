`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2026 02:59:23 PM
// Design Name: 
// Module Name: display_controller
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


module display_controller(
        input logic clk,
        input logic [3:0] btn,
        input logic [11:0] sw,
        
        output logic hdmi_clk_n, hdmi_clk_p, 
        output logic [2:0] hdmi_tx_n,
        output logic [2:0] hdmi_tx_p,
        
//        (* mark_debug = "true" , keep = "true" *)
        output logic hdmi_out_en,
        
//        (* mark_debug = "true" , keep = "true" *)
//        input logic hdmi_hpd, // Detects when monitor is plugged in
        
        output logic [9:0] led
    );
    
    
    
    
    logic btn0_debounced;
    
    debouncer #(
        .CLK_FREQ_HZ(100_000_000),  // adjust to your actual board clk
        .DEBOUNCE_MS(10)
    ) reset_debounce (
        .clk(clk),
        .btn_in(btn[0]),
        .btn_out(btn0_debounced)
    );
    
    logic nReset;
    assign nReset = ~btn0_debounced;
    
    logic px_clk;
    logic px5_clk;
    
    logic locked;
    logic hsync, vsync, video_active;
    
    
    logic [11:0] px;
    
    logic [11:0] py;
    

    // ---CLAUDE-- //
    logic locked_sync;
    always_ff @(posedge clk or negedge nReset)
    begin
        if (~nReset) locked_sync <= 1'b0;
        else locked_sync <= locked;
    end
    
    logic [15:0] lock_settle_count;
    logic lock_settled;
    always_ff @(posedge clk or negedge nReset)
    begin
        if (~nReset) begin
            lock_settle_count <= 0;
            lock_settled <= 0;
        end else if (!locked_sync) begin
            lock_settle_count <= 0;
            lock_settled <= 0;
        end else if (lock_settle_count == 16'hFFFF) begin
            lock_settled <= 1;
        end else begin
            lock_settle_count <= lock_settle_count + 1;
        end
    end
    
    logic sys_nReset;
    assign sys_nReset = nReset & lock_settled;

    // --CLAUDE--//
    // Try to remove above if 1920x1080 working now?
    



    
    
    clk_wiz_0 cw0 (.clk_in1(clk) , .clk_out1(px_clk), .locked(locked),
                   .clk_out2(px5_clk), .reset(~nReset));
    
    

    
    
    
    
    logic [7:0] red, green, blue;
    


    // Re-synchronize sys_nReset into the pix_clk (px_clk) domain specifically
    // for the OSERDESE2 reset requirement (deassertion must be sync to CLKDIV)
    logic [2:0] hdmi_rst_sync;
    always_ff @(posedge px_clk or negedge sys_nReset)
    begin
        if (~sys_nReset)
            hdmi_rst_sync <= 3'b111;
        else
            hdmi_rst_sync <= {hdmi_rst_sync[1:0], 1'b0};
    end
    
    logic hdmi_rst;
    assign hdmi_rst = hdmi_rst_sync[2];
    
    vga_controller vga_c (.clk(px_clk), .nReset(~hdmi_rst), .hsync(hsync), .vsync(vsync), .video_active(video_active), .px(px), .py(py));

    
    always_ff @(posedge px_clk or negedge sys_nReset)
    begin
        if (~sys_nReset) hdmi_out_en <= 1'b0;
        else hdmi_out_en <= ~hdmi_rst;
    end
    
    
    
    logic game_nReset;
    logic [27:0] game_wait_count;
    
    always_ff @(posedge px_clk or posedge hdmi_rst) begin
        if (hdmi_rst) begin
            game_wait_count <= 0;
            game_nReset <= 1'b0; // Hold VGA in reset
        end else if (game_wait_count == 28'd150_000_000) begin
            game_nReset <= 1'b1; // Release VGA logic safely
        end else begin
            game_wait_count <= game_wait_count + 1;
            game_nReset <= 1'b0;
        end
    end


    
    hdmi_tx_0 hdmi_to_vga (
        .pix_clk(px_clk),
        .pix_clkx5(px5_clk),
        .pix_clk_locked(locked),
        .rst(hdmi_rst),
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(video_active),
      
      // Differential outputs
      .TMDS_CLK_P(hdmi_clk_p),          
      .TMDS_CLK_N(hdmi_clk_n),          
      .TMDS_DATA_P(hdmi_tx_p),         
      .TMDS_DATA_N(hdmi_tx_n)
    );
    
    
    
    logic [7:0] r0, g0, b0;
    logic [7:0] r1, b1, g1;
    
    // Set frame / game speed
    logic [21:0] frame_divider;
    
    
    always_ff @(posedge px_clk or negedge game_nReset)
    begin 
        if (~game_nReset) frame_divider <= 0;
        else if ((frame_divider == 2504177 )) frame_divider <= 0; 
        else frame_divider <= frame_divider + 1;  
    end
    
    
    logic bar_on_0, bar_on_1, box_on;
    logic p1_scored, p2_scored;
    
    
    (* mark_debug = "true", keep = "true" *)
    logic [11:0] p1_x, p2_x;
    logic [11:0] p1_y, p2_y; 
    
    pong_bar #(.PLAYER(0)) p_ba0 (.px(px), .py(py), .sw(sw[11:0]) , .display_clock(px_clk), .nReset(game_nReset), .bar_on(bar_on_0), .frame_divider(frame_divider), .bar_px(p1_x), .bar_py(p1_y));
    
    pong_bar #(.PLAYER(1)) p_ba1 (.px(px), .py(py), .sw(sw[11:0]) , .display_clock(px_clk), .nReset(game_nReset), .bar_on(bar_on_1), .frame_divider(frame_divider), .bar_px(p2_x), .bar_py(p2_y));

    pong_box p_bo0 (.px(px), .py(py), .display_clock(px_clk), .nReset(game_nReset), .frame_divider(frame_divider), .p1_px(p1_x), .p1_py(p1_y), .p2_px(p2_x), .p2_py(p2_y), .box_on(box_on));

    
    always_comb
    begin
        if (bar_on_0 || bar_on_1) {red, green, blue} = 24'hFFFFFF;
        else if (box_on) {red, green, blue} = 24'h000000; 
        else {red, green, blue} = 24'h123456;
    end
    
    
    /*
    always_comb
    begin
        if (py[5]) {red, green, blue} = 24'hFFFFFF;
        else {red, green, blue} = 24'h000000;
    end
    */
    
    assign led[9:0] = {locked, hsync, vsync, video_active, hdmi_rst,  hdmi_out_en, 1'b0, 1'b0};

    
endmodule
