// ============================================================
// axis_fifo_ctrl 模块例化代码
// 由 verilog-inst 技能自动生成
// 日期：2026/05/26
// ============================================================

// 参数覆盖块（按需修改）
// DATA_WIDTH : 数据位宽         默认 32
// DEPTH      : FIFO 深度        默认 512
// PROG_FULL  : 可编程满阈值      默认 480

axis_fifo_ctrl #(
  .DATA_WIDTH ( 32  ),  // 数据位宽
  .DEPTH      ( 512 ),  // FIFO 深度
  .PROG_FULL  ( 480 )   // 可编程满阈值
) u_axis_fifo_ctrl (
  // ---- 全局 ----
  .clk             ( clk              ),  // 系统时钟
  .rstn            ( rstn             ),  // 低有效同步复位

  // ---- AXI-Stream 写端口（Slave）----
  .s_axis_tdata    ( s_axis_tdata     ),  // 输入数据
  .s_axis_tvalid   ( s_axis_tvalid    ),  // 输入有效
  .s_axis_tready   ( s_axis_tready    ),  // 接收就绪
  .s_axis_tlast    ( s_axis_tlast     ),  // 帧结束

  // ---- AXI-Stream 读端口（Master）----
  .m_axis_tdata    ( m_axis_tdata     ),  // 输出数据
  .m_axis_tvalid   ( m_axis_tvalid    ),  // 输出有效
  .m_axis_tready   ( m_axis_tready    ),  // 下游就绪
  .m_axis_tlast    ( m_axis_tlast     ),  // 帧结束透传

  // ---- 状态 ----
  .fifo_count      ( fifo_count       ),  // 当前数据量
  .full            ( fifo_full        ),  // 满标志
  .empty           ( fifo_empty       ),  // 空标志
  .prog_full       ( fifo_prog_full   )   // 可编程满标志
);
