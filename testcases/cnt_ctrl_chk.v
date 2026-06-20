task run_test();
	integer count;
	integer i;
	integer j;
	reg [31:0] data;
	begin
		$display("TEST 1");
		count = 0;
		apb_write(12'h00, 32'h0000_0001, 4'b1111);
		for(i = 0; i < 20; i = i + 1) begin
			@(posedge sys_clk);
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
				count = count + 1;
			end

		end
		if (count == 20) 
			$display("PASS TEST 1");
		else 
			$display("FAIL TEST 1. count = %d", count);
		reset_system();
		$display("TEST 2");
		count = 0;
		apb_write(12'h00, 32'h0000_0003, 4'b1111);
		for(i = 0; i < 20; i = i + 1) begin
			@(posedge sys_clk);
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
				count = count + 1;
			end
		end
		if (count == 20) 
			$display("PASS TEST 2a");
		else 
			$display("FAIL TEST 2a. count = %d", count);
		reset_system();
		
		count = 0;
		apb_write(12'h00, 32'h0000_0002, 4'b1111);
		for (i = 0 ; i < 20; i = i + 1) begin
			@(posedge sys_clk); 
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
				count = count + 1;
			end
		end
		if(count == 0)
			$display("PASS test 2b");
		else 
			$display("FAIL test 2b");
		reset_system();

		count = 0;
		apb_write(12'h00, 32'h0000_0501, 4'b1111);
		for (i = 0 ; i < 20; i = i + 1) begin
			@(posedge sys_clk); 
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
				count = count + 1;
			end
		end
		if (count == 20)
			$display("PASS TEST 2c");
		else
			$display("FAIL TEST 2c");
		reset_system();

		$display("TEST 3");
		count = 0;
		apb_write(12'h00, 32'h0000_0203, 4'b1111);
		for(i = 0; i < 20; i = i + 1) begin
			@(posedge sys_clk);
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
				count = count + 1;
			end
		end
		if (count == 5) 
			$display("PASS TEST 3a");
		else 
			$display("FAIL TEST 3a. count = %d", count);
		reset_system();

		count = 0;
		apb_write(12'h00, 32'h0000_0803, 4'b1111);
		for(i = 0; i < 10000; i = i + 1) begin
			@(posedge sys_clk);
			if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
				count = count + 1;
			end
		end
		if (count == 39) 
			$display("PASS TEST 3b");
		else 
			$display("FAIL TEST 3b. count = %d", count);
		reset_system();


		apb_write(12'h00, 32'h0000_0002, 4'b1111);
		@(posedge sys_clk); #1;
		check_reg(12'h00, 32'h0000_0002, "TCR");

		reset_system();

		apb_write(12'h00, 32'h0000_0F00, 4'b1111);
		@(posedge sys_clk); #1;
		check_reg(12'h00, 32'h0000_0100, "TCR");

		apb_write(12'h00, 32'h0000_0800, 4'b1111);
		@(posedge sys_clk); #1;
		check_reg(12'h00, 32'h0000_0800, "TCR");


		apb_write(12'h00, 32'h0000_0402, 4'b1111);
		@(posedge sys_clk); #1;
		check_reg(12'h00, 32'h0000_0402, "TCR");

		reset_system();

		count = 0;
		for (i = 0; i < 9; i = i + 1) begin
			count = 0;
			data = ((i << 8) + 2'b11);
			apb_write(12'h00, data, 4'b1111);
			for(j = 0; j < 90000; j = j + 1) begin
				@(posedge sys_clk);
				if (dut.MyControlCounter.actual_cnt_en == 1'b1) begin
					count = count + 1;
				end
			end
			if (count != 90000/(1 << i)) begin
				$display("FAIL i = %d", i);
			end
			reset_system();
		end

		reset_system();
//		apb_write(12'h00, 32'h0000_0000, 4'b1111);
//		apb_write(12'h00, 32'h0000_0700, 4'b1111);
//		apb_write(12'h00, 32'h0000_0002, 4'b1111);
//		apb_write(12'h00, 32'h0000_0702, 4'b1111);
//		apb_write(12'h00, 32'h0000_0001, 4'b1111);

	end
endtask
