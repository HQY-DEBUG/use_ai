# top 管脚约束
# 目标器件：通用 FPGA 开发板示例（Artix-7 / Basys3）
# 生成时间：2026/05/26
# 说明：所有 IO 电平须与硬件原理图核对后使用

# ============================================================
# 时钟输入
# ============================================================
set_property PACKAGE_PIN    E3            [get_ports clk]
set_property IOSTANDARD     LVCMOS33      [get_ports clk]
create_clock -period 10.000              [get_ports clk]

# ============================================================
# 复位输入（低有效，外部按钮）
# ============================================================
set_property PACKAGE_PIN    C12           [get_ports rstn]
set_property IOSTANDARD     LVCMOS33      [get_ports rstn]

# ============================================================
# LED 输出
# ============================================================
set_property PACKAGE_PIN    H17           [get_ports {led[0]}]
set_property PACKAGE_PIN    K15           [get_ports {led[1]}]
set_property PACKAGE_PIN    J13           [get_ports {led[2]}]
set_property PACKAGE_PIN    N14           [get_ports {led[3]}]
set_property IOSTANDARD     LVCMOS33      [get_ports {led[*]}]

# ============================================================
# 按键输入
# ============================================================
set_property PACKAGE_PIN    J15           [get_ports {btn[0]}]
set_property PACKAGE_PIN    L16           [get_ports {btn[1]}]
set_property IOSTANDARD     LVCMOS33      [get_ports {btn[*]}]

# ============================================================
# UART
# ============================================================
set_property PACKAGE_PIN    D10           [get_ports uart_tx]
set_property PACKAGE_PIN    A9            [get_ports uart_rx]
set_property IOSTANDARD     LVCMOS33      [get_ports uart_tx]
set_property IOSTANDARD     LVCMOS33      [get_ports uart_rx]
