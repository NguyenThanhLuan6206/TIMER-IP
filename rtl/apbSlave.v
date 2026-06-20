module apbSlave(
	input wire sys_clk,
	input wire sys_rst_n,
	input wire tim_psel,
	input wire tim_pwrite,
	input wire tim_penable,
	input wire [11:0] tim_paddr,
	input wire [31:0] tim_pwdata,
	output wire [31:0] tim_prdata,
	input wire [3:0] tim_pstrb,
	input wire [31:0] tcr,
	output wire tim_pready,
	output wire tim_pslverr,
	output reg wr_en,
	output wire [31:0] wdata,
	output reg rd_en,
	input wire [31:0] rdata,
	output wire [11:0] addr,
	output wire tcr_prohibit_violation,
	output wire [3:0] pstrb
);

	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			wr_en <= 0;
			rd_en <= 0;
		end
		else begin
			wr_en <= !wr_en & tim_psel & tim_penable & tim_pwrite;
			rd_en <= !rd_en & tim_psel & tim_penable & !tim_pwrite;
		end
	end
	assign tim_pready = wr_en || rd_en;
	assign wdata = tim_pwdata;
	assign addr = tim_paddr;
	assign tim_prdata = rdata;
	assign pstrb = tim_pstrb;

	wire is_tcr_write = (tim_paddr == 12'h0) && wr_en;

	wire div_change, en_change;
	assign div_change = (tcr[11:8] != tim_pwdata[11:8]) && (tim_pstrb[1]);
	assign en_change  = (tcr[1]    != tim_pwdata[1]   ) && (tim_pstrb[0]);
	
	assign tcr_prohibit_violation = is_tcr_write && (
		(tim_pwdata[11:8] > 4'd8 && tim_pstrb[1]) ||
		(tcr[0] && (div_change || en_change)));

	assign tim_pslverr = tcr_prohibit_violation;


	

endmodule
