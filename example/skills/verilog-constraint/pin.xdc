# galvo_top 管脚约束
# 目标器件：Zynq UltraScale+ XCZU3EG-SFVC784
# 生成时间：2026/05/26
# 说明：所有 IO 电平须与硬件原理图核对后使用

# ============================================================
# 时钟输入
# ============================================================
set_property PACKAGE_PIN    H11           [get_ports sys_clk_p]
set_property PACKAGE_PIN    G11           [get_ports sys_clk_n]
set_property IOSTANDARD     DIFF_SSTL12   [get_ports sys_clk_p]
set_property IOSTANDARD     DIFF_SSTL12   [get_ports sys_clk_n]

# ============================================================
# 复位输入（低有效，外部按钮）
# ============================================================
set_property PACKAGE_PIN    AE8           [get_ports rstn]
set_property IOSTANDARD     LVCMOS18      [get_ports rstn]
set_property PULLUP         true          [get_ports rstn]

# ============================================================
# 振镜 X 轴 DAC SPI 接口
# ============================================================
set_property PACKAGE_PIN    AB7           [get_ports galvo_x_sclk]
set_property PACKAGE_PIN    AB6           [get_ports galvo_x_mosi]
set_property PACKAGE_PIN    AC8           [get_ports galvo_x_csn]
set_property IOSTANDARD     LVCMOS18      [get_ports galvo_x_sclk]
set_property IOSTANDARD     LVCMOS18      [get_ports galvo_x_mosi]
set_property IOSTANDARD     LVCMOS18      [get_ports galvo_x_csn]
set_property SLEW           FAST          [get_ports galvo_x_sclk]
set_property SLEW           FAST          [get_ports galvo_x_mosi]
set_property SLEW           FAST          [get_ports galvo_x_csn]

# ============================================================
# 振镜 Y 轴 DAC SPI 接口
# ============================================================
set_property PACKAGE_PIN    AD7           [get_ports galvo_y_sclk]
set_property PACKAGE_PIN    AD6           [get_ports galvo_y_mosi]
set_property PACKAGE_PIN    AE7           [get_ports galvo_y_csn]
set_property IOSTANDARD     LVCMOS18      [get_ports galvo_y_sclk]
set_property IOSTANDARD     LVCMOS18      [get_ports galvo_y_mosi]
set_property IOSTANDARD     LVCMOS18      [get_ports galvo_y_csn]
set_property SLEW           FAST          [get_ports galvo_y_sclk]
set_property SLEW           FAST          [get_ports galvo_y_mosi]
set_property SLEW           FAST          [get_ports galvo_y_csn]

# ============================================================
# 激光使能输出
# ============================================================
set_property PACKAGE_PIN    W8            [get_ports laser_en]
set_property IOSTANDARD     LVCMOS18      [get_ports laser_en]
set_property SLEW           SLOW          [get_ports laser_en]

# ============================================================
# 状态 LED
# ============================================================
set_property PACKAGE_PIN    P8            [get_ports led[0]]
set_property PACKAGE_PIN    P9            [get_ports led[1]]
set_property PACKAGE_PIN    R8            [get_ports led[2]]
set_property PACKAGE_PIN    R9            [get_ports led[3]]
set_property IOSTANDARD     LVCMOS18      [get_ports {led[*]}]
