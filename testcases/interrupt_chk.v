task run_test();
	begin
		$display("TEST 1");
		apb_write(12'h14, 32'h0000_0001, 4'b1111);
		apb_write(12'h04, 32'h0000_0008, 4'b1111);
		apb_write(12'h0C, 32'h0000_0008, 4'b1111);
		apb_write(12'h10, 32'h0000_0000, 4'b1111);
		@(posedge sys_clk); #1;
		if (tim_int == 1'b1) 
			$display("PASS TEST 1");
		else 
			$display("FAIL TEST 1");
		apb_write(12'h04, 32'h0000_0000, 4'b1111);
		apb_write(12'h18, 0000_0001, 4'b1111); #1;
		check_reg(12'h18, 0000_0000, "TISR");
		
		apb_write(12'h04, 32'h0000_0008, 4'b1111);
		apb_write(12'h04, 32'h0000_0000, 4'b1111);

		apb_write(12'h18, 0000_0000, 4'b1111);
		check_reg(12'h18, 0000_0001, "TISR");

		apb_write(12'h18, 32'h0000_0001, 4'b1110);
		check_reg(12'h18, 0000_0001, "TISR");

		reset_system();
	end
endtask
