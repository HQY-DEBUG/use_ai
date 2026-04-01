/**************************************************************************/
// Function   : uart_rx 模块的 Testbench
// Version    : v1.0
// Date       : 2026/03/23
// Description: 验证 uart_rx 接收逻辑：发送标准 UART 帧，检查输出数据
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/23  创建文件
/**************************************************************************/

`timescale 1ns / 1ps

module uart_rx_tb;

// ---- 参数 ----//
parameter CLK_PERIOD  = 10;         // 100 MHz 时钟，单位 ns
parameter BAUD_RATE   = 115200;
parameter BIT_PERIOD  = 1_000_000_000 / BAUD_RATE; // 单位 ns

// ---- 激励信号 ----//
reg        clk;
reg        rst_n;
reg        rx;

// ---- 观测信号 ----//
wire [7:0] rx_data;
wire       rx_valid;

// ---- DUT 实例化 ----//
uart_rx #(
    .CLK_FREQ  (100_000_000),
    .BAUD_RATE (BAUD_RATE  )
) u_dut (
    .clk      (clk     ),
    .rst_n    (rst_n   ),
    .rx       (rx      ),
    .rx_data  (rx_data ),
    .rx_valid (rx_valid)
);

// ---- 时钟生成 ----//
initial clk = 1'b0;
always #(CLK_PERIOD / 2) clk = ~clk;

// ---- 复位序列 ----//
initial
begin
    rx    = 1'b1;                   // 空闲高电平
    rst_n = 1'b0;
    repeat(20) @(posedge clk);
    rst_n = 1'b1;
end

// ---- 激励任务：发送一字节 UART 帧 ----//
task send_byte;
    input [7:0] data;
    integer     i;
    begin
        // 起始位
        rx = 1'b0;
        #(BIT_PERIOD);
        // 数据位（LSB first）
        for (i = 0; i < 8; i = i + 1)
        begin
            rx = data[i];
            #(BIT_PERIOD);
        end
        // 停止位
        rx = 1'b1;
        #(BIT_PERIOD);
    end
endtask

// ---- 激励主体 ----//
initial
begin
    @(posedge rst_n);
    repeat(5) @(posedge clk);

    // 发送 0x55
    send_byte(8'h55);
    @(posedge rx_valid);
    if (rx_data === 8'h55)
        $display("[PASS] 接收数据正确：0x%02X", rx_data);
    else
        $display("[FAIL] 期望 0x55，实际 0x%02X", rx_data);

    repeat(10) @(posedge clk);

    // 发送 0xA3
    send_byte(8'hA3);
    @(posedge rx_valid);
    if (rx_data === 8'hA3)
        $display("[PASS] 接收数据正确：0x%02X", rx_data);
    else
        $display("[FAIL] 期望 0xA3，实际 0x%02X", rx_data);

    repeat(20) @(posedge clk);
    $display("仿真完成");
    $finish;
end

// ---- 波形转储 ----//
initial
begin
    $dumpfile("uart_rx_tb.vcd");
    $dumpvars(0, uart_rx_tb);
end

endmodule
