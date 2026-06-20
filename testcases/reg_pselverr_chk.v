task run_test();
	begin
		$display("TEST 1");
		apb_write(12'h00, 32'h0000_0000, 4'b1111);
		apb_write(12'h00, 32'h0000_0F00, 4'b1111);
		check_reg(12'h00, 32'h0000_0000, "TCR");
		$display("TEST 2");
		apb_write(12'h00, 32'h0000_0503, 4'b1111);
		apb_write(12'h00, 32'h0000_0103, 4'b1111);
		check_reg(12'h00, 32'h0000_0503, "TCR");
		$display("TEST 3");
		apb_write(12'h00, 32'h0000_0501, 4'b1111);
		check_reg(12'h00, 32'h0000_0503, "TCR");

		reset_system();
		$display("TEST 4");
		apb_write(12'h00, 32'h0000_0001, 4'b1111);
		check_reg(12'h00, 32'h0000_0001, 4'b1111);
		apb_write(12'h00, 32'h0000_0003, 4'b1111);
		check_reg(12'h00, 32'h0000_0001, 4'b1111);
		apb_write(12'h00, 32'h0000_0501, 4'b1111);
		check_reg(12'h00, 32'h0000_0001, 4'b1111);
		apb_write(12'h00, 32'h0000_0A01, 4'b1111);
		check_reg(12'h00, 32'h0000_0001, 4'b1111);
		
		reset_system();
		$display("TEST 5");
		apb_write(12'h00, 32'h0000_0001, 4'b1111);
		apb_write(12'h00, 32'h0000_0001, 4'b1111);
		check_reg(12'h00, 32'h0000_0001, 4'b1111);

		$display("TEST 6");
		reset_system();
		apb_write(12'h00, 32'h0000_0F00, 4'b1111);
		check_reg(12'h00, 32'h0000_0100, "TCR");
		
	end
endtask
