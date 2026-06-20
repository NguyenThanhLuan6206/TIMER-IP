task run_test();
	reg [31:0] rd;
	reg [11:0] ran_addr;
	begin
		for(ran_addr = 0; ran_addr < 12'b1111_1111_1111; ran_addr = ran_addr + 1) begin
			if (!(ran_addr == 12'h00 || ran_addr == 12'h04 ||ran_addr == 12'h08 ||
				ran_addr == 12'h0C || ran_addr == 12'h10 || ran_addr == 12'h14 ||
				 ran_addr == 12'h18 ||  ran_addr == 12'h1C)
			) begin
				check_reg(ran_addr, 32'h0000_0000, "ALL OTHER ADDR");
			end
		end

		apb_write(12'h00, 32'h0000_0000, 4'hF);
		check_reg(12'h00, 32'h0000_0000, "TCR");
		reset_system();
		apb_write(12'h00, 32'h5555_5555, 4'hF);
		check_reg(12'h00, 32'h0000_0501, "TCR");
		reset_system();
		apb_write(12'h00, 32'hFFFF_FFFF, 4'hF);
		check_reg(12'h00, 32'h0000_0100, "TCR");
		reset_system();
		apb_write(12'h00, 32'hAAAA_AAAA, 4'hF);
		check_reg(12'h00, 32'h0000_0100, "TCR");
		reset_system();



		apb_write(12'h04, 32'h0000_0000, 4'hF);
		check_reg(12'h04, 32'h0000_0000, "TDR0");
		reset_system();
		apb_write(12'h04, 32'hFFFF_FFFF, 4'hF);
		check_reg(12'h04, 32'hFFFF_FFFF, "TDR0");
		reset_system();
		apb_write(12'h04, 32'h5555_5555, 4'hF);
		check_reg(12'h04, 32'h5555_5555, "TDR0");
		reset_system();
		apb_write(12'h04, 32'hAAAA_AAAA, 4'hF);
		check_reg(12'h04, 32'hAAAA_AAAA, "TDR0");
		reset_system();
		


		apb_write(12'h08, 32'h0000_0000, 4'hF);
		check_reg(12'h08, 32'h0000_0000, "TDR1");
		reset_system();
		apb_write(12'h08, 32'hFFFF_FFFF, 4'hF);
		check_reg(12'h08, 32'hFFFF_FFFF, "TDR1");
		reset_system();
		apb_write(12'h08, 32'h5555_5555, 4'hF);
		check_reg(12'h08, 32'h5555_5555, "TDR1");
		reset_system();
		apb_write(12'h08, 32'hAAAA_AAAA, 4'hF);
		check_reg(12'h08, 32'hAAAA_AAAA, "TDR1");
		reset_system();


		apb_write(12'h0C, 32'h0000_0000, 4'hF);
		check_reg(12'h0C, 32'h0000_0000, "TCMP0");
		reset_system();
		apb_write(12'h0C, 32'hFFFF_FFFF, 4'hF);
		check_reg(12'h0C, 32'hFFFF_FFFF, "TCMP0");
		reset_system();
		apb_write(12'h0C, 32'h5555_5555, 4'hF);
		check_reg(12'h0C, 32'h5555_5555, "TCMP0");
		reset_system();
		apb_write(12'h0C, 32'hAAAA_AAAA, 4'hF);
		check_reg(12'h0C, 32'hAAAA_AAAA, "TCMP0");
		reset_system();



		apb_write(12'h10, 32'h0000_0000, 4'hF);
		check_reg(12'h10, 32'h0000_0000, "TCMP1");
		reset_system();
		apb_write(12'h10, 32'hFFFF_FFFF, 4'hF);
		check_reg(12'h10, 32'hFFFF_FFFF, "TCMP1");
		reset_system();
		apb_write(12'h10, 32'h5555_5555, 4'hF);
		check_reg(12'h10, 32'h5555_5555, "TCMP1");
		reset_system();
		apb_write(12'h10, 32'hAAAA_AAAA, 4'hF);
		check_reg(12'h10, 32'hAAAA_AAAA, "TCMP1");
		reset_system();


		apb_write(12'h14, 32'h5555_5555, 4'hF);
		check_reg(12'h14, 32'h0000_0001, "TIER");
		reset_system();



		apb_write(12'h18, 32'h5555_5555, 4'hF);
		check_reg(12'h18, 32'h0000_0000, "TISR");
		reset_system();



		apb_write(12'h1C, 32'h5555_5555, 4'hF);
		check_reg(12'h1C, 32'h0000_0001, "THCSR");
		reset_system();
	end
endtask
