// top wrapper for DE1-SOC


module dino_quartus_demo_top(
    input  wire        CLOCK_50,
    input  wire [3:0]  KEY,
    input  wire [17:0] SW,

    output wire VGA_HS,
	 output wire VGA_VS,
	 output wire [7:6] VGA_R,
	 output wire [7:6] VGA_G,
	 output wire [7:6] VGA_B,
	 output wire VGA_CLK
);

    wire clk_25mhz;
    wire [7:0] uio_oe;
    wire [6:0] uio_out;
    wire out_sound;

    //---------------------------------------------
    // TinyTapeout module wrapper
    //---------------------------------------------
	 
	 //  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
	 
	 
    tt_um_uwasic_dinogame dino_inst(
        .ui_in({5'b00000, start, up, down}),     // button mapping
        .uo_out({VGA_HS, VGA_B[6], VGA_G[6], VGA_R[6], VGA_VS, VGA_B[7], VGA_G[7], VGA_R[7]}),                           // VGA
        .uio_in(8'b0),
        .uio_out({out_sound, uio_out}),
        .uio_oe(uio_oe),
        .clk(clk_25mhz),
        .rst_n(~reset),                          // active low reset
        .ena(1'b1)
    );

    //---------------------------------------------
    // assign your DE1 buttons to start/up/down
    //---------------------------------------------
    wire up    = ~KEY[3];
    wire down  = ~KEY[2];
    wire start = SW[0];
    wire reset = ~KEY[0];

    //---------------------------------------------
    // clock divider – same as your TT code
    //---------------------------------------------
    clock_div clk_div_inst (
        .clk(CLOCK_50),
        .reset(1'b0),
        .clk_out(clk_25mhz)
    );
	 
	 assign VGA_CLK = clk_25mhz;


endmodule

module clock_div (clk,reset, clk_out);
 
input clk;
input reset;
output clk_out;
 
reg r_reg;
wire [1:0] r_nxt;
reg clk_track;
 
always @(posedge clk or posedge reset)
 
begin
  if (reset)
     begin
        r_reg <= 1'b0;
	clk_track <= 1'b0;
     end
 
  else if (r_nxt == 2'b01)
 	   begin
	     r_reg <= 0;
	     clk_track <= ~clk_track;
	   end
 
  else 
      r_reg <= r_nxt;
end
 
 assign r_nxt = r_reg+1;   	      
 assign clk_out = clk_track;
endmodule


