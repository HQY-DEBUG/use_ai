/**************************************************************************/
// Function   : spi_master_fsm Testbench — 含自动断言与结果统计
// Version    : v1.0
// Date       : 2026/05/26
// Description: 在 verilog-tb 生成的基础上，添加 check_equal/check_range
//              断言任务和 report_result 汇总，实现自动化回归验证。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

`timescale 1ns / 1ps

module spi_master_tb;

// ---- 时钟参数 ----
localparam CLK_PERIOD = 10;

// ---- DUT 信号 ----
reg          clk      ;
reg          rstn     ;
reg          start    ;
reg  [15:0]  tx_data  ;
wire [15:0]  rx_data  ;
wire         busy     ;
wire         spi_csn  ;
wire         spi_sck  ;
wire         spi_mosi ;
reg          spi_miso ;

// ---- 断言统计 ----
integer pass_cnt ;
integer fail_cnt ;

// ---- DUT 例化 ----
spi_master_fsm #(
  .CLK_DIV  ( 4  ),
  .DATA_LEN ( 16 )
) u_dut (
  .clk      ( clk      ),
  .rstn     ( rstn     ),
  .start    ( start    ),
  .tx_data  ( tx_data  ),
  .rx_data  ( rx_data  ),
  .busy     ( busy     ),
  .spi_csn  ( spi_csn  ),
  .spi_sck  ( spi_sck  ),
  .spi_mosi ( spi_mosi ),
  .spi_miso ( spi_miso )
);

// ---- 时钟 ----
initial clk = 1'b0;
always  #(CLK_PERIOD/2) clk = ~clk;

// ---- MISO 回环 ----
always @(posedge spi_sck)
  begin
    spi_miso <= spi_mosi;
  end

// ============================================================
// 断言任务：check_equal
//   检查 actual == expect，不等则报 FAIL 并记录
// ============================================================
task check_equal;
  input [63:0]  actual;
  input [63:0]  expect;
  input [127:0] msg;
  begin
    if (actual === expect)
      begin
        $display("[PASS] %0s  actual=0x%0X  expect=0x%0X", msg, actual, expect);
        pass_cnt = pass_cnt + 1;
      end
    else
      begin
        $display("[FAIL] %0s  actual=0x%0X  expect=0x%0X", msg, actual, expect);
        fail_cnt = fail_cnt + 1;
      end
  end
endtask

// ============================================================
// 断言任务：check_range
//   检查 lo <= actual <= hi
// ============================================================
task check_range;
  input signed [63:0] actual;
  input signed [63:0] lo;
  input signed [63:0] hi;
  input [127:0] msg;
  begin
    if (actual >= lo && actual <= hi)
      begin
        $display("[PASS] %0s  actual=%0d  范围[%0d, %0d]", msg, actual, lo, hi);
        pass_cnt = pass_cnt + 1;
      end
    else
      begin
        $display("[FAIL] %0s  actual=%0d  超出范围[%0d, %0d]", msg, actual, lo, hi);
        fail_cnt = fail_cnt + 1;
      end
  end
endtask

// ============================================================
// 汇总任务：report_result
// ============================================================
task report_result;
  begin
    $display("========================================");
    $display("  测试结果汇总");
    $display("  PASS: %0d", pass_cnt);
    $display("  FAIL: %0d", fail_cnt);
    if (fail_cnt == 0)
      $display("  ✓ 所有测试通过");
    else
      $display("  ✗ 存在失败项，请检查！");
    $display("========================================");
  end
endtask

// ---- 复位 ----
task do_reset;
  begin
    rstn  = 1'b0;
    start = 1'b0;
    repeat (5) @(posedge clk);
    rstn  = 1'b1;
    @(posedge clk);
  end
endtask

// ---- 发送并等待完成 ----
task do_send;
  input [15:0] data;
  begin
    tx_data = data;
    @(posedge clk);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;
    wait (busy == 1'b0);
    repeat (2) @(posedge clk);
  end
endtask

// ---- 波形文件 ----
initial
  begin
    $dumpfile("spi_master_tb.vcd");
    $dumpvars(0, spi_master_tb);
  end

// ---- 主测试流程 ----
initial
  begin
    pass_cnt = 0;
    fail_cnt = 0;

    $display("[TB] ===== 开始自动化断言测试 =====");
    do_reset;

    // 验证复位后 CSN 为高
    check_equal(spi_csn, 1'b1, "复位后 CSN 应为高");

    // 验证 MISO 回环（发送 0xA55A，期望 rx_data = 0xA55A）
    do_send(16'hA55A);
    check_equal(rx_data, 16'hA55A, "回环测试：0xA55A");

    // 发送全 1
    do_send(16'hFFFF);
    check_equal(rx_data, 16'hFFFF, "回环测试：0xFFFF");

    // 发送全 0
    do_send(16'h0000);
    check_equal(rx_data, 16'h0000, "回环测试：0x0000");

    // 发送后 busy 应回低
    check_equal(busy, 1'b0, "发送完成后 busy 应为低");

    // 发送后 CSN 应回高
    check_equal(spi_csn, 1'b1, "发送完成后 CSN 应为高");

    report_result;
    $finish;
  end

// ---- 超时保护 ----
initial
  begin
    #200000;
    $display("[TB] 超时！强制结束");
    $finish;
  end

endmodule
