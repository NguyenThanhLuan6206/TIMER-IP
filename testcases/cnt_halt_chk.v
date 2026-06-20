task run_test();
	integer i;
	integer pulse;
	reg [7:0] prev_cnt;
	reg [31:0] val_prev;
	begin
		apb_write(12'h00, 32'h0000_0001, 4'hF);
		dbg_mode = 0;
		apb_write(12'h1C, 32'h0000_0000, 4'hF);
		if (dut.MyControlCounter.actual_cnt_en == 1'b1)
			$display("PASS TEST 1");
		else 
			$display("FAIL TEST 1");

		apb_write(12'h1C, 32'h0000_0001, 4'hF);
		if (dut.MyControlCounter.actual_cnt_en == 1'b1) 
			$display("PASS TEST 2");
		else 
			$display("FAIL TEST 2");

		dbg_mode = 1; #1;
		if (dut.MyControlCounter.halt_active == 1'b1 && dut.MyControlCounter.actual_cnt_en == 1'b0)
			$display("PASS TEST 3");
		else 
			$display("FAIL TEST 3");

		reset_system();

		apb_write(12'h00,32'h0000_0203, 4'hF);
		dbg_mode = 1;
		apb_write(12'h1C, 32'h0000_0001, 4'hF);#1;
		if (dut.MyControlCounter.halt_active == 1'b1) 
			$display("PASS TEST 4");
		else
			$display("FAIL TEST 4");
		@(posedge sys_clk); #1;
		check_reg(12'h1C, 32'h0000_0003, "THCSR");
		
		pulse = 0;
		dbg_mode = 0;
		for ( i = 0; i < 20; i = i + 1) begin
			@(posedge sys_clk);
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) pulse = pulse + 1;
		end

		if (pulse == 5)
			$display("PASS TEST 5");
		else 
			$display("FAIL TEST 5");
		reset_system();



		$display("TEST 6");
		dbg_mode = 1;
		apb_write(12'h00, 32'h0000_0803, 4'b1111);
		repeat (1000) @(posedge sys_clk); #1;
		apb_write(12'h1C, 32'h0000_0001, 4'b1111);
		repeat(10) @(posedge sys_clk); #1;
		prev_cnt = dut.MyControlCounter.cnt_prev;
		apb_write(12'h00, 32'h0000_0802, 4'b1111);
		apb_write(12'h00, 32'h0000_0003, 4'b1111);
		repeat(10) @(posedge sys_clk); #1;
		dbg_mode = 0; #1;
		if (prev_cnt == dut.MyControlCounter.cnt_prev)
			$display("PASS TEST 6");
		else 
			$display("FAIL TEST 6");



	end
endtask
