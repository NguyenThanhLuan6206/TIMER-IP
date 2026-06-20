module TCMP1 (
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire [11:0] addr,
	input wire [31:0] wdata,
	input wire [3:0] pstrb,
	output reg [31:0] tcmp1
);
	wire wr_en_tcmp1;
	assign wr_en_tcmp1 = ((addr == 12'h10) && wr_en);
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) tcmp1 <= 32'hFFFFFFFF;
		else begin
			if (pstrb[0] && wr_en_tcmp1) tcmp1[7:0] <= wdata[7:0];
			else tcmp1[7:0] <= tcmp1[7:0];

			if (pstrb[1] && wr_en_tcmp1) tcmp1[15:8] <= wdata[15:8];
			else tcmp1[15:8] <= tcmp1[15:8];

			if (pstrb[2] && wr_en_tcmp1) tcmp1[23:16] <= wdata[23:16];
			else tcmp1[23:16] <= tcmp1[23:16];

			if (pstrb[3] && wr_en_tcmp1) tcmp1[31:24] <= wdata[31:24];
			else tcmp1[31:24] <= tcmp1[31:24];
		end	
	end

endmodule
