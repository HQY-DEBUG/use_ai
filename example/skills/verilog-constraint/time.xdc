# galvo_top 时序约束
# 目标器件：Zynq UltraScale+ XCZU3EG-SFVC784
# 生成时间：2026/05/26
# 说明：时序数值须结合实际布局布线报告调整裕量

# ============================================================
# 主时钟定义（200 MHz 差分输入）
# ============================================================
create_clock -period 5.000 -name sys_clk -waveform {0.000 2.500} \
    [get_ports sys_clk_p]

# ============================================================
# 内部生成时钟（由 MMCM/PLL 派生）
# ============================================================
# 100 MHz 系统工作时钟
create_generated_clock -name clk_100m \
    -source [get_pins u_mmcm/CLKIN1] \
    -master_clock sys_clk \
    -multiply_by 1 -divide_by 2 \
    [get_pins u_mmcm/CLKOUT0]

# 200 MHz 高速采样时钟
create_generated_clock -name clk_200m \
    -source [get_pins u_mmcm/CLKIN1] \
    -master_clock sys_clk \
    -multiply_by 1 -divide_by 1 \
    [get_pins u_mmcm/CLKOUT1]

# 50 MHz DAC SPI 时钟
create_generated_clock -name clk_spi \
    -source [get_pins u_mmcm/CLKIN1] \
    -master_clock sys_clk \
    -multiply_by 1 -divide_by 4 \
    [get_pins u_mmcm/CLKOUT2]

# ============================================================
# 输入延迟约束（外部 ADC 采样数据）
# ============================================================
# 假设 ADC 建立时间 1.0 ns，保持时间 0.5 ns，PCB 走线延迟 0.5 ns
set_input_delay -clock clk_200m -max 2.0 [get_ports adc_data[*]]
set_input_delay -clock clk_200m -min 0.5 [get_ports adc_data[*]]

# ============================================================
# 输出延迟约束（DAC SPI 信号）
# ============================================================
# DAC 建立时间 3.0 ns，保持时间 0.5 ns
set_output_delay -clock clk_spi -max 3.0 [get_ports {galvo_x_mosi galvo_y_mosi}]
set_output_delay -clock clk_spi -min -0.5 [get_ports {galvo_x_mosi galvo_y_mosi}]

# ============================================================
# 跨时钟域约束
# ============================================================
# 100M → 200M 快慢同步路径：使用两级触发器已处理，标记为假路径豁免
set_false_path -from [get_clocks clk_100m] -to [get_clocks clk_200m]
set_false_path -from [get_clocks clk_200m] -to [get_clocks clk_100m]

# ============================================================
# 复位路径（异步复位，豁免时序分析）
# ============================================================
set_false_path -from [get_ports rstn]

# ============================================================
# 最大延迟约束（CDC 握手路径，限制在半周期内）
# ============================================================
set_max_delay -datapath_only 4.0 \
    -from [get_cells -hierarchical -filter {NAME =~ *src_toggle_r*}] \
    -to   [get_cells -hierarchical -filter {NAME =~ *sync_r1*}]
