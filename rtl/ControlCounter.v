module ControlCounter (
	input wire clk,
	input wire rst_n,
	input wire timer_en,
	input wire div_en,
	input wire dbg_mode,
	input wire halt_req,
	input wire [3:0] div_val,
	output wire halt_active,
	output wire actual_cnt_en
);
	reg [7:0] limit;
	always @* begin
		case (div_val)
			4'b0000: limit = 8'd0;
			4'b0010: limit = 8'd3;
			4'b0011: limit = 8'd7;
			4'b0100: limit = 8'd15;
			4'b0101: limit = 8'd31;
			4'b0110: limit = 8'd63;
			4'b0111: limit = 8'd127;
			4'b1000: limit = 8'd255;
			default: limit = 8'd1;
		endcase
	end
	wire cnt_clr;
	reg [7:0] cnt_prev;
	assign cnt_clr = (~timer_en || ~div_en || (limit == cnt_prev));

	assign halt_active = (dbg_mode && halt_req);

	wire increase_cnt = timer_en && div_en && (div_val != 4'b0);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) cnt_prev <= 8'b0;
		else if (halt_active) cnt_prev <= cnt_prev;
		else if (cnt_clr) cnt_prev <= 8'b0;
		else if (increase_cnt) cnt_prev <= cnt_prev + 1;
		else cnt_prev <= cnt_prev;
	end
	wire cnt_en;
	wire condition1 = ~div_en && timer_en;
	wire condition2 = timer_en && div_en && (div_val != 0) && (cnt_prev == limit);
	wire condition3 = timer_en && div_en && (div_val == 0);
	assign cnt_en = condition1 || condition2 || condition3;

	assign actual_cnt_en = (cnt_en && ~halt_active);

endmodule
