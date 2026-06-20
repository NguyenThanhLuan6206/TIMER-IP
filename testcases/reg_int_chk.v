task run_test();
	reg [31:0] rd_data;
	begin
		apb_read(12'h0, rd_data); #1;
		if (rd_data == 32'h0000_0100) 
			$display("PASS TCR initial state");
		else 
			$display("FAIL TCR initial state, value = %h", rd_data);
		apb_read(12'h4, rd_data); #1;
		if (rd_data == 32'h0000_0000) 
			$display("PASS TDR0 initial state");
		else 
			$display("FAIL TDR0 initial state, value = %h", rd_data);
		apb_read(12'h8, rd_data); #1;
		if (rd_data == 32'h0000_0000) 
			$display("PASS TDR1 initial state");
		else 
			$display("FAIL TDR1 initial state, value = %h", rd_data);
		apb_read(12'hC, rd_data); #1;
		if (rd_data == 32'hFFFF_FFFF) 
			$display("PASS TCMP0 initial state");
		else 
			$display("FAIL TCMP0 initial state, value = %h", rd_data);
		apb_read(12'h10, rd_data); #1;
		if (rd_data == 32'hFFFF_FFFF) 
			$display("PASS TCMP1 initial state");
		else 
			$display("FAIL TCMP1 initial state, value = %h", rd_data);
		apb_read(12'h14, rd_data); #1;
		if (rd_data == 32'h0000_0000) 
			$display("PASS TIER initial state");
		else 
			$display("FAIL TIER initial state, value = %h", rd_data);
		apb_read(12'h18, rd_data); #1;
		if (rd_data == 32'h0000_0000) 
			$display("PASS TISR initial state");
		else 
			$display("FAIL TISR initial state, value = %h", rd_data);
		apb_read(12'h1C, rd_data); #1;
		if (rd_data == 32'h0000_0000) 
			$display("PASS THCSR initial state");
		else 
			$display("FAIL THCSR initial state, value = %h", rd_data);
	end
endtask
