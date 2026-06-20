module Counter64b (
	input wire clk,
	input wire rst_n,
	input wire tdr0_wr_en,
	input wire tdr1_wr_en,
	input wire [31:0] tdr_wdata,
	input wire cnt_en,
	input wire falling_edge,
	input wire [3:0] pstrb,
	output reg [31:0] tdr0,
	output reg [31:0] tdr1,
	output wire [63:0] cnt
);
	wire [63:0] cnt_prev;
	assign cnt_prev = cnt + 1;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) tdr0 <= 32'b0;
		else begin
			if(tdr0_wr_en) begin
				if (pstrb[0]) tdr0[7:0] <= tdr_wdata[7:0];
				else tdr0[7:0] <= tdr0[7:0];
				if (pstrb[1]) tdr0[15:8] <= tdr_wdata[15:8];
				else tdr0[15:8] <= tdr0[15:8];
				if (pstrb[2]) tdr0[23:16] <= tdr_wdata[23:16];
				else tdr0[23:16] <= tdr0[23:16];
				if (pstrb[3]) tdr0[31:24] <= tdr_wdata[31:24];
				else tdr0[31:24] <= tdr0[31:24];
			end
			else if (falling_edge) tdr0 <= 32'b0;
			else if(cnt_en) tdr0  <= cnt_prev[31:0];
			else tdr0 <= tdr0;
		end
	end



	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) tdr1 <= 32'b0;
		else begin
			if(tdr1_wr_en) begin
				if (pstrb[0]) tdr1[7:0] <= tdr_wdata[7:0];
				else tdr1[7:0] <= tdr1[7:0];
				if (pstrb[1]) tdr1[15:8] <= tdr_wdata[15:8];
				else tdr1[15:8] <= tdr1[15:8];
				if (pstrb[2]) tdr1[23:16] <= tdr_wdata[23:16];
				else tdr1[23:16] <= tdr1[23:16];
				if (pstrb[3]) tdr1[31:24] <= tdr_wdata[31:24];
				else tdr1[31:24] <= tdr1[31:24];
			end
			else if (falling_edge) tdr1 <= 32'b0;
			else if(cnt_en)  tdr1 <= cnt_prev[63:32];
			else tdr1 <= tdr1;
		end
	end
	assign cnt = {tdr1, tdr0};
endmodule
