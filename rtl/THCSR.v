module THCSR(
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire [11:0] addr,
	input wire [31:0] wdata,
	input wire halt_active,
	input wire [3:0] pstrb,
	output wire [31:0] thcsr,
	output reg halt_req
);

	reg halt_ack;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			halt_ack <= 1'b0;
			halt_req <= 1'b0;
		end
		else begin
			halt_ack <= halt_active;
			if ((addr == 12'h1C) && wr_en && pstrb[0]) halt_req <= wdata[0];
			else halt_req <= halt_req;
		end
	end
	assign thcsr = {30'b0, halt_ack, halt_req};

endmodule
