module TCMP0(
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire [31:0] wdata,
	input wire [11:0] addr,
	input wire [3:0] pstrb,
	output reg [31:0] tcmp0
);
	wire wr_en_tcmp0;
	assign wr_en_tcmp0 = ((addr == 12'h0C) && wr_en);
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) tcmp0 <= 32'hFFFFFFFF;
		else begin
			if (pstrb[0] && wr_en_tcmp0) tcmp0[7:0] <= wdata[7:0];
			else tcmp0[7:0] <= tcmp0[7:0];

			if (pstrb[1] && wr_en_tcmp0) tcmp0[15:8] <= wdata[15:8];
			else tcmp0[15:8] <= tcmp0[15:8];

			if (pstrb[2] && wr_en_tcmp0) tcmp0[23:16] <= wdata[23:16];
			else tcmp0[23:16] <= tcmp0[23:16];

			if (pstrb[3] && wr_en_tcmp0) tcmp0[31:24] <= wdata[31:24];
			else tcmp0[31:24] <= tcmp0[31:24];
		end	
	end
endmodule
