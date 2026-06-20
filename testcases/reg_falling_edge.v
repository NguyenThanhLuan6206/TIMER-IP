task run_test();
	begin
		apb_write(12'h04, 12'h0000_AAAA, 4'b1111);
		apb_write(12'h08, 12'h0000_AAAA, 4'b1111);
		apb_write(12'h00, 12'h0000_0001, 4'b1111);
		repeat(2) @(posedge sys_clk);
		apb_write(12'h00, 12'h0000_0000, 4'b1111);
		check_reg(12'h04, 32'h0000_0000, "TDR0");
		check_reg(12'h08, 32'h0000_0000, "TDR1");
	end
endtask
