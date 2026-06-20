`timescale 1ns/1ps

module tb_timer_top;

    // --- Signals [cite: 751] ---
    reg sys_clk;
    reg sys_rst_n;
    reg tim_psel;
    reg tim_pwrite;
    reg tim_penable;
    reg [11:0] tim_paddr;
    reg [31:0] tim_pwdata;
    reg [3:0]  tim_pstrb;
    reg dbg_mode;

    wire [31:0] tim_prdata;
    wire tim_pready;
    wire tim_pslverr;
    wire tim_int;

    // --- Instantiate DUT (Device Under Test) [cite: 750, 829] ---
    timer_top dut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .tim_psel(tim_psel),
        .tim_pwrite(tim_pwrite),
        .tim_penable(tim_penable),
        .tim_paddr(tim_paddr),
        .tim_pwdata(tim_pwdata),
        .tim_prdata(tim_prdata),
        .tim_pstrb(tim_pstrb),
        .tim_pready(tim_pready),
        .tim_pslverr(tim_pslverr),
        .tim_int(tim_int),
        .dbg_mode(dbg_mode)
    );

    // --- Clock Generation ---
    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk; // 100MHz

    // --- APB Write Task (Hỗ trợ Wait State)  ---
    task apb_write(input [11:0] addr, input [31:0] data, input [3:0] strb);
    begin
        @(posedge sys_clk);
        tim_psel    <= 1'b1;
        tim_pwrite  <= 1'b1;
        tim_paddr   <= addr;
        tim_pwdata  <= data;
        tim_pstrb   <= strb;
        @(posedge sys_clk);
        tim_penable <= 1'b1;
        
        // Chờ tim_pready từ apbSlave 
        wait(tim_pready); 
        @(posedge sys_clk);
        
        tim_psel    <= 1'b0;
        tim_penable <= 1'b0;
        tim_pwrite  <= 1'b0;
        $display("[WRITE] Addr: 0x%h, Data: 0x%h", addr, data);
    end
    endtask

    // --- Main Test Sequence ---
    initial begin
        // 1. Initialize & Reset [cite: 493]
        sys_rst_n   = 0;
        tim_psel    = 0;
        tim_penable = 0;
        dbg_mode    = 0;
        tim_pstrb   = 4'h0;
        #20 sys_rst_n = 1;
        #10;

        $display("--- Bat dau kịch bản Test Pass (Advanced Level) ---");

        // 2. Thiet lap gia tri so sanh (TCMP0 = 10) [cite: 701, 724]
        // Su dung byte access (pstrb = 4'hF) [cite: 488]
        apb_write(12'h0C, 32'd10, 4'hF); 
        apb_write(12'h10, 32'h0,  4'hF); // TCMP1 = 0

        // 3. Bat ngat (TIER.int_en = 1) [cite: 738, 739]
        apb_write(12'h14, 32'h1, 4'h1);

        // 4. Bat Timer (TCR.timer_en = 1, div_en = 0) [cite: 706, 707]
        apb_write(12'h00, 32'h1, 4'h1);

        // 5. Cho cho den khi tin hieu ngat tim_int len 1 
        $display("Dang cho Timer dem den 10...");
        wait(tim_int);
        $display("[SUCCESS] Da nhan tin hieu ngat tim_int!");

        // 6. Kiem tra trang thai ngat (TISR) [cite: 744]
        #10;
        if (tim_int) $display("[STATUS] TISR.int_st dang o muc cao.");

        // 7. Xoa ngat (RW1C - Ghi 1 vao TISR.int_st) [cite: 744, 814]
        apb_write(12'h18, 32'h1, 4'h1);
        #10;
        
        if (!tim_int) $display("[SUCCESS] Da xoa ngat thanh cong.");
        else $display("[ERROR] Ngat chua duoc xoa!");

        // 8. Ket thuc
        #100;
        $display("--- Ket thuc kịch bản Test Pass ---");
        $finish;
    end

endmodule