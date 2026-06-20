module timer_top (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire tim_psel,
	input wire tim_pwrite,
	input wire tim_penable,
	input wire [11:0] tim_paddr,
	input wire [31:0] tim_pwdata,
	output wire [31:0] tim_prdata,
	input wire [3:0] tim_pstrb,
	output wire tim_pready,
	output wire tim_pslverr,
	output wire tim_int,
	input wire dbg_mode
);
	wire [31:0] rdata_wire;
	reg [31:0] rdata;
	assign rdata_wire = rdata;

	wire wr_en, rd_en;
	wire [31:0] wdata;
	wire [11:0] addr;
	wire [3:0] pstrb;
	wire [31:0] tcr;
	wire tcr_prohibit_violation;


	apbSlave MyApbSlave (
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.tim_psel(tim_psel),
		.tim_pwrite(tim_pwrite),
		.tim_penable(tim_penable),
		.tim_paddr(tim_paddr),
		.tim_pwdata(tim_pwdata),
		.tim_prdata(tim_prdata),
		.tim_pstrb(tim_pstrb),
		.tcr(tcr),
		.tim_pready(tim_pready),
		.tim_pslverr(tim_pslverr),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.wdata(wdata),
		.rdata(rdata_wire),
		.addr(addr),
		.tcr_prohibit_violation(tcr_prohibit_violation),
		.pstrb(pstrb)
	);

	wire div_en, timer_en;
	wire [3:0] div_val;
	wire falling_edge;
	TCR myTCR (
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.wr_en(wr_en),
		.addr(addr),
		.wdata(wdata),
		.pstrb(pstrb),
		.tcr_prohibit_violation(tcr_prohibit_violation),
		.tcr(tcr),
		.div_en(div_en),
		.timer_en(timer_en),
		.div_val(div_val),
		.falling_edge(falling_edge)
	);	

	wire actual_cnt_en;
	wire halt_active;
	wire halt_req;
	ControlCounter MyControlCounter (
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.timer_en(timer_en),
		.div_en(div_en),
		.dbg_mode(dbg_mode),
		.halt_req(halt_req),
		.div_val(div_val),
		.halt_active(halt_active),
		.actual_cnt_en(actual_cnt_en)
	);

	wire [31:0] tdr0, tdr1;
	wire [63:0] cnt;
	wire tdr0_wr_en;
	wire tdr1_wr_en;
	assign tdr0_wr_en = ((addr == 12'd4) && (wr_en));
	assign tdr1_wr_en = ((addr == 12'd8) && (wr_en));
	Counter64b MyCnt(
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.tdr0_wr_en(tdr0_wr_en),
		.tdr1_wr_en(tdr1_wr_en),
		.tdr_wdata(wdata),
		.cnt_en(actual_cnt_en),
		.falling_edge(falling_edge),
		.pstrb(pstrb),
		.tdr0(tdr0),
		.tdr1(tdr1),
		.cnt(cnt)
	);

	wire [31:0] tcmp0;
	TCMP0 MyTCMP0 (
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.wr_en(wr_en),
		.wdata(wdata),
		.addr(addr),
		.pstrb(pstrb),
		.tcmp0(tcmp0)
	);

	wire [31:0] tcmp1;
	TCMP1 MyTCMP1(
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.wr_en(wr_en),
		.addr(addr),
		.wdata(wdata),
		.pstrb(pstrb),
		.tcmp1(tcmp1)
	);
	
	wire [63:0] tcmp = {tcmp1, tcmp0};
	wire [31:0] tisr, tier;
	Interrupt myInt (
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.wdata(wdata),
		.addr(addr),
		.cnt(cnt),
		.tcmp(tcmp),
		.wr_en(wr_en),
		.pstrb(pstrb),
		.tisr(tisr),
		.tier(tier),
		.tim_int(tim_int)
	);		

	wire [31:0] thcsr;
	THCSR MyTHCSR (
		.clk(sys_clk),
		.rst_n(sys_rst_n),
		.wr_en(wr_en),
		.addr(addr),
		.wdata(wdata),
		.halt_active(halt_active),
		.pstrb(pstrb),
		.thcsr(thcsr),
		.halt_req(halt_req)
	);

	always @* begin
		if(rd_en == 1) begin
			case (addr)
				12'h00: rdata = tcr;
				12'h04: rdata = tdr0;
				12'h08: rdata = tdr1;
				12'h0C: rdata = tcmp0;
				12'h10: rdata = tcmp1;
				12'h14: rdata = tier;
				12'h18: rdata = tisr;
				12'h1C: rdata = thcsr;
				default: rdata = 32'b0;
			endcase
		end
		else begin
			rdata <= 32'h0;
		end
	end


endmodule
