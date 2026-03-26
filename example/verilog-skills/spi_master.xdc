## ===========================================================================
## XDC 约束文件：spi_master.xdc
## 目标器件：Zynq-7000（ZC706 / ZC702，按实际修改 PACKAGE_PIN）
## 目标频率：100 MHz（SCLK 最高 50 MHz，cfg_clk_div=0 时）
## 生成日期：2026/03/26
## 生成工具：/verilog-constraint 技能
## ===========================================================================

## ---------------------------------------------------------------------------
## 时钟约束
## ---------------------------------------------------------------------------

# 系统主时钟（100 MHz，来自 PS 或外部晶振）
create_clock -period 10.000 -name clk [get_ports clk]

# SCLK 为内部生成时钟，不约束为主时钟
# 若从 SPI 从机回传 SCLK（CPOL=1 场景），可取消注释并调整：
# create_generated_clock -name spi_sclk -source [get_ports clk] \
#   -divide_by 10 [get_ports spi_sclk]

## ---------------------------------------------------------------------------
## 输入延迟约束（相对系统时钟）
## ---------------------------------------------------------------------------

# 复位信号（异步，设置为伪路径）
set_false_path -from [get_ports rst_n]

# 配置接口（传输前稳定，按寄存器输入处理）
set_input_delay -clock clk -max 2.000 [get_ports {cfg_clk_div[*] cfg_cpol cfg_cpha cfg_3wire cfg_lsb}]
set_input_delay -clock clk -min 0.500 [get_ports {cfg_clk_div[*] cfg_cpol cfg_cpha cfg_3wire cfg_lsb}]

# 用户数据输入
set_input_delay -clock clk -max 2.000 [get_ports {s_valid s_data[*]}]
set_input_delay -clock clk -min 0.500 [get_ports {s_valid s_data[*]}]

# SPI MISO（四线模式，相对 SCLK 约束；此处相对系统时钟估算）
# 实际需参考从机 datasheet 中的 Tco（时钟到输出延迟）
set_input_delay -clock clk -max 5.000 [get_ports spi_miso]
set_input_delay -clock clk -min 1.000 [get_ports spi_miso]

# 三线模式双向 IO 输入（方向为输入时）
set_input_delay -clock clk -max 5.000 [get_ports spi_io_in]
set_input_delay -clock clk -min 1.000 [get_ports spi_io_in]

## ---------------------------------------------------------------------------
## 输出延迟约束
## ---------------------------------------------------------------------------

# 用户接口输出
set_output_delay -clock clk -max 2.000 [get_ports {s_ready m_valid m_data[*]}]
set_output_delay -clock clk -min 0.500 [get_ports {s_ready m_valid m_data[*]}]

# SPI 控制/数据输出
# SCLK、CS_N、MOSI 需满足从机的 Tsu（建立时间）要求
set_output_delay -clock clk -max 3.000 [get_ports {spi_sclk spi_cs_n spi_mosi}]
set_output_delay -clock clk -min 0.500 [get_ports {spi_sclk spi_cs_n spi_mosi}]

# 三线模式双向 IO 输出
set_output_delay -clock clk -max 3.000 [get_ports {spi_io_oe spi_io_out}]
set_output_delay -clock clk -min 0.500 [get_ports {spi_io_oe spi_io_out}]

## ---------------------------------------------------------------------------
## 物理引脚绑定（示例，按实际板卡修改）
## ---------------------------------------------------------------------------

# 系统时钟（ZC706 125 MHz 差分输入，若使用单端时钟修改此处）
# set_property PACKAGE_PIN H9  [get_ports clk]
# set_property IOSTANDARD  LVCMOS33 [get_ports clk]

# SPI 接口引脚（按实际 PCB 网表修改）
# set_property PACKAGE_PIN  AB7 [get_ports spi_sclk ]
# set_property PACKAGE_PIN  AA7 [get_ports spi_cs_n ]
# set_property PACKAGE_PIN  Y7  [get_ports spi_mosi ]
# set_property PACKAGE_PIN  W7  [get_ports spi_miso ]
# set_property IOSTANDARD LVCMOS33 [get_ports {spi_sclk spi_cs_n spi_mosi spi_miso}]

## ---------------------------------------------------------------------------
## 时序例外（可选）
## ---------------------------------------------------------------------------

# 若 MISO 路径时序裕量不足，可设置多周期路径（SCLK < CLK/4 时）
# set_multicycle_path 2 -setup -from [get_ports spi_miso] -to [get_clocks clk]
# set_multicycle_path 1 -hold  -from [get_ports spi_miso] -to [get_clocks clk]

## ---------------------------------------------------------------------------
## 注意事项
## ---------------------------------------------------------------------------
# 1. MISO/spi_io_in 的输入延迟应根据从机 Tco 和 PCB 走线延迟实测调整
# 2. 若系统时钟频率高于 100 MHz，需同比调整 create_clock 的 -period 值
# 3. 三线模式 IOBUF 例化需在顶层完成，约束需针对实际 IO 引脚
