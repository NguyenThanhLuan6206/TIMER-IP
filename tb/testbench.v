module testbench;
	reg sys_clk, sys_rst_n;
	reg tim_psel, tim_penable, tim_pwrite;
	reg [11:0] tim_paddr;
	reg [31:0] tim_pwdata;
	reg [3:0] tim_pstrb;
	wire tim_pready, tim_pslverr, tim_int;
	wire [31:0] tim_prdata;
	reg dbg_mode;

	timer_top dut (.*);

	`include "run_test.v"

	initial begin
		sys_clk = 0;
		forever #5 sys_clk = ~sys_clk;
	end

	initial begin 
		sys_rst_n = 0;
		#10; sys_rst_n = 1;
	end



	initial begin
		#100;
		tim_psel =0; tim_penable = 0; tim_pwrite = 0;
		tim_paddr = 0;tim_pwdata = 0; tim_pstrb = 0;
		dbg_mode = 0;

		run_test();

		$monitor("tim_pwrite = %b", tim_pwrite);

		//@(posedge sys_clk);
		//tim_psel = 1; tim_penable = 1; tim_pwrite = 1; #1;
		//tim_paddr = 12'h4; tim_pwdata = 32'hCAFEFACE; tim_pstrb = 4'b1111; #1;

		//wait (tim_pready == 1); @(posedge sys_clk);
		//tim_pwrite = 0; #1;

		//wait(tim_pready == 1); #1;
		//if (tim_prdata == 32'hCAFEFACE) $display("TRUE");
		//else $display("FAIL");



		#1000;
		$finish;
	end

	task apb_write(
		input [11:0] addr,
		input [31:0] data,
		input [3:0] strb
	);
	begin
		$display("Write to addr = %h, data = %h, strb = %b", addr, data, strb);
		@(posedge sys_clk);
		tim_psel   <= 1'b1; 
		tim_pwrite <= 1'b1;
		tim_paddr  <= addr;
		tim_pwdata <= data;
		tim_pstrb  <= strb;
		tim_penable<= 1'b0;

		@(posedge sys_clk);
		tim_penable <= 1'b1;
		wait(tim_pready == 1'b1);
		if (tim_pslverr == 1'b1) begin
			$display("Write violation at addr: %h", addr);
		end

		@(posedge sys_clk);
		tim_psel    <= 1'b0;
		tim_penable <= 1'b0;
		tim_pwrite  <= 1'b0;
		tim_pstrb   <= 4'h0;

	end
	endtask

	task apb_read(
		input [11:0] addr,
		output [31:0] data
	);
	begin
		@(posedge sys_clk);
		tim_psel <= 1'b1;
		tim_pwrite <= 1'b0;
		tim_paddr <= addr;

		@(posedge sys_clk);
		tim_penable <= 1'b1;

		wait(tim_pready == 1'b1); #1;

		data = tim_prdata;

		@(posedge sys_clk);
		tim_psel <= 1'b0;
		tim_penable <= 1'b0;
		$display("Read from addr = %h, value = %h", addr, data);
	end
	endtask
	
	task reset_system();
		begin
			tim_psel <= 1'b0;
			tim_penable <= 1'b0;
			tim_pwrite <= 1'b0;
			tim_paddr <= 12'h0;
			tim_pwdata <= 32'h0;
			tim_pstrb <= 12'h0;
			dbg_mode <= 1'b0;

			sys_rst_n <= 1'b0;
			repeat(5) @(posedge sys_clk);

			sys_rst_n <= 1'b1;

			repeat(2) @(posedge sys_clk);
			$display("COMPLETE RESET ALL THE SYSTEM");
		end
	endtask

	task check_reg(
		input [11:0] addr,
		input [31:0] expected_val,
		input [8*20:1] name
	);
	reg [31:0] rdata;
	begin
		apb_read(addr, rdata);
		if (rdata == expected_val) begin
			$display("PASS %s: read %h as expected", name, rdata);
		end else begin
			$display("FAIL %s: read %h, but expected %h", name, rdata, expected_val);
		end
	end
	endtask	

endmodule
