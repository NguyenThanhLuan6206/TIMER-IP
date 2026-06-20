task run_test();
	begin
		@(posedge sys_clk); #1;
		tim_psel = 1; tim_penable = 1; tim_pwrite = 1;
		@(posedge sys_clk); #1;
		if (dut.MyApbSlave.wr_en == 1'b1)
			$display("PASS TEST 1a");
		else 
			$display("FAIL TEST 1a");
		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 0;


		@(posedge sys_clk); #1;
		tim_psel = 1; tim_penable = 1; tim_pwrite = 0;
		@(posedge sys_clk); #1;
		if (dut.MyApbSlave.rd_en == 1'b1)
			$display("PASS TEST 1b");
		else 
			$display("FAIL TEST 1b");
		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 0;

		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 1; tim_pwrite = 1;
		@(posedge sys_clk); #1;
		if (dut.MyApbSlave.wr_en == 1'b0)
			$display("PASS TEST 2a");
		else 
			$display("FAIL TEST 2a");
		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 0;


		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 1; tim_pwrite = 0;
		@(posedge sys_clk); #1;
		if (dut.MyApbSlave.rd_en == 1'b0)
			$display("PASS TEST 2b");
		else 
			$display("FAIL TEST 2b");
		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 0;

		@(posedge sys_clk); #1;
		tim_psel = 1; tim_penable = 0; tim_pwrite = 1;
		@(posedge sys_clk); #1;
		if (dut.MyApbSlave.wr_en == 1'b0)
			$display("PASS TEST 3a");
		else 
			$display("FAIL TEST 3a");
		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 0;

		@(posedge sys_clk); #1;
		tim_psel = 1; tim_penable = 0; tim_pwrite = 0;
		@(posedge sys_clk); #1;
		if (dut.MyApbSlave.rd_en == 1'b0)
			$display("PASS TEST 3b");
		else 
			$display("FAIL TEST 3b");
		@(posedge sys_clk); #1;
		tim_psel = 0; tim_penable = 0;
	end
endtask
