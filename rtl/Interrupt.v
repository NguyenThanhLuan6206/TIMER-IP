module Interrupt(
	input wire clk,
	input wire rst_n,
	input wire [31:0] wdata,
	input wire [11:0] addr,
	input wire [63:0] cnt,
	input wire [63:0] tcmp,
	input wire wr_en,
	input wire [3:0] pstrb,
	output wire [31:0] tisr,
	output wire [31:0] tier,
	output wire tim_int
);
	reg int_en;
	reg int_st;

	wire wr_en_tier;
	assign wr_en_tier = wr_en && (addr == 12'h14);	

	wire wr_en_tisr;
	assign wr_en_tisr = wr_en && (addr == 12'h18);

	wire int_clr;
	assign int_clr = int_st & wdata[0] & pstrb[0] & wr_en_tisr;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) int_en <= 1'b0;
		else if (wr_en_tier && pstrb[0]) int_en <= wdata[0];
		else int_en <= int_en;
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) int_st <= 0;
		else if (int_clr) int_st <= 0;
		else if (tcmp == cnt) int_st <= 1;
		else int_st <= int_st;
	end

	assign tisr = {31'b0, int_st};
	assign tier = {31'b0, int_en};
	assign tim_int = int_en && int_st;
endmodule
