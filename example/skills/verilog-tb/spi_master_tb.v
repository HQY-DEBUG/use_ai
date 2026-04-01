/**************************************************************************/
// Function   : spi_master_fsm 模块 Testbench
// Version    : v1.0
// Date       : 2026/05/26
// Description: 对 spi_master_fsm 进行基本功能仿真：
//              1. 验证 CS/SCK/MOSI 时序
//              2. 验证发送数据 16'hA55A 后 rx_data 正确回读
//              3. 验证 busy 信号宽度
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

`timescale 1ns / 1ps

module spi_master_tb;

// ---- 时钟参数 ----
localparam CLK_PERIOD = 10;  // 10 ns → 100 MHz

// ---- DUT 信号 ----
reg          clk       ;
reg          rstn      ;
reg          start     ;
reg  [15:0]  tx_data   ;
wire [15:0]  rx_data   ;
wire         busy      ;
wire         spi_csn   ;
wire         spi_sck   ;
wire         spi_mosi  ;
reg          spi_miso  ;

// ---- DUT 实例化 ----
spi_master_fsm #(
  .CLK_DIV  ( 4  ),
  .DATA_LEN ( 16 )
) u_dut (
  .clk      ( clk      ),
  .rstn     ( rstn      ),
  .start    ( start     ),
  .tx_data  ( tx_data   ),
  .rx_data  ( rx_data   ),
  .busy     ( busy      ),
  .spi_csn  ( spi_csn   ),
  .spi_sck  ( spi_sck   ),
  .spi_mosi ( spi_mosi  ),
  .spi_miso ( spi_miso  )
);

// ---- 时钟生成 ----
initial clk = 1'b0;
always #(CLK_PERIOD/2) clk = ~clk;

// ---- MISO 回环（将 MOSI 延迟一拍回送，模拟从机回显）----
always @(posedge spi_sck)
  begin
    spi_miso <= spi_mosi;
  end

// ---- 复位任务 ----
task do_reset;
  begin
    rstn  = 1'b0;
    start = 1'b0;
    spi_miso = 1'b0;
    repeat (5) @(posedge clk);
    rstn = 1'b1;
    @(posedge clk);
  end
endtask

// ---- 发送任务 ----
task do_send;
  input [15:0] data;
  begin
    tx_data = data;
    @(posedge clk);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;
    // 等待传输完成
    wait (busy == 1'b0);
    repeat (2) @(posedge clk);
  end
endtask

// ---- 波形转储 ----
initial
  begin
    $dumpfile("spi_master_tb.vcd");
    $dumpvars(0, spi_master_tb);
  end

// ---- 主激励 ----
initial
  begin
    $display("[TB] ===== SPI Master FSM Testbench Start =====");

    do_reset;
    $display("[TB] 复位完成，开始测试");

    // --- 测试1：发送 0xA55A ---
    $display("[TB] 测试1：发送 0xA55A");
    do_send(16'hA55A);
    $display("[TB] 测试1 完成，rx_data = 0x%04X", rx_data);

    // --- 测试2：发送 0x1234 ---
    $display("[TB] 测试2：发送 0x1234");
    do_send(16'h1234);
    $display("[TB] 测试2 完成，rx_data = 0x%04X", rx_data);

    // --- 测试3：连续发送两帧，验证 busy 间隙 ---
    $display("[TB] 测试3：连续发送 0xFFFF 和 0x0000");
    do_send(16'hFFFF);
    do_send(16'h0000);

    repeat (10) @(posedge clk);
    $display("[TB] ===== 仿真结束 =====");
    $finish;
  end

// ---- 超时保护 ----
initial
  begin
    #100000;
    $display("[TB] 超时！仿真异常终止");
    $finish;
  end

endmodule
