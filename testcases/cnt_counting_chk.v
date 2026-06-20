task run_test();
	begin
		$display("TEST 1");
		apb_write(12'h00, 32'h0000_0001, 4'b1111);
		repeat(3) @(posedge sys_clk);
		check_reg(12'h04, 32'h0000_0006, "TDR0");
		check_reg(12'h08, 32'h0000_0000, "TDR1");
		reset_system();
		$display("TEST 2");
		apb_write(12'h04, 32'hFFFF_FFFF, 4'b1111);
		apb_write(12'h08, 32'hFFFF_FFFF, 4'b1111);
		apb_write(12'h00, 32'h0000_0001, 4'b1111);
		repeat(3) @(posedge sys_clk);
		check_reg(12'h04, 32'h0000_0005, "TDR0");
		check_reg(12'h08, 32'h0000_0000, "TDR1");
		reset_system();
	end
endtask
