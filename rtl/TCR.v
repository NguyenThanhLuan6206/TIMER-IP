module TCR(
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire [11:0] addr,
	input wire [31:0] wdata,
	input wire [3:0] pstrb,
	input wire tcr_prohibit_violation,
	output wire [31:0] tcr,
	output reg div_en,
	output reg timer_en,
	output reg [3:0] div_val,
	output wire falling_edge
);

	wire tcr_wr_sel;
	assign tcr_wr_sel = (addr == 12'h0) && wr_en && ~tcr_prohibit_violation;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) timer_en <= 0;
		else if (tcr_wr_sel & pstrb[0]) begin
			timer_en <= wdata[0];
		end
		else timer_en <= timer_en;
	end
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) div_en <= 0;
		else if (tcr_wr_sel && pstrb[0]) div_en <= wdata[1];
		else div_en <= div_en;
	end


	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) div_val <= 4'b0001;
		else if (tcr_wr_sel && pstrb[1]) div_val <= wdata[11:8];
		else div_val <= div_val;
	end

	assign tcr = {20'b0, div_val, 6'b0, div_en, timer_en};

	reg timer_en_delay;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) timer_en_delay <= 1'b0;
	        else timer_en_delay <= timer_en;
	end

	assign falling_edge = timer_en_delay & ~timer_en;

endmodule
