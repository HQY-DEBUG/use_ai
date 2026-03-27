---
name: verilog-tb-assert
description: 为已有 Testbench 添加自动校验断言和结果统计逻辑。用法：/verilog-tb-assert <tb文件路径>
argument-hint: <tb文件路径>
allowed-tools: [Read, Edit]
disable-model-invocation: true
---

# Testbench 自动校验增强

目标：$ARGUMENTS

## 操作步骤

1. 读取目标 TB 文件，分析以下内容：
   - 现有的 `output wire` 信号（观测点）
   - 现有的激励结构（`initial` 块）
   - 是否已有 `$error` / `$assert` 语句
2. 在文件末尾（`endmodule` 之前）插入以下内容：
   - **测试计数器**：`pass_cnt`、`fail_cnt`
   - **断言任务（task）**：`check_equal`、`check_range`
   - **结果汇总**：在 `$finish` 前输出统计
3. 若文件中已有自检逻辑，仅补充缺失部分，不重复添加

## 插入内容模板

在 `endmodule` 前插入：

```verilog
// ---- 自动校验框架 ----//
integer pass_cnt ;
integer fail_cnt ;

// 初始化计数器
initial
begin
    pass_cnt = 0 ;
    fail_cnt = 0 ;
end

// 精确比较任务
task check_equal ;
    input [63:0] actual   ;
    input [63:0] expected ;
    input [127:0] test_name ;  // 测试项名称（ASCII）
    begin
        if (actual === expected)
          begin
            pass_cnt = pass_cnt + 1 ;
            $display("[PASS] %s: 实际值=0x%0h，预期值=0x%0h", test_name, actual, expected) ;
          end
        else
          begin
            fail_cnt = fail_cnt + 1 ;
            $display("[FAIL] %s: 实际值=0x%0h，预期值=0x%0h，时刻=%0t ns", test_name, actual, expected, $time) ;
          end
    end
endtask

// 范围检查任务
task check_range ;
    input [63:0] actual  ;
    input [63:0] lo      ;  // 下限（含）
    input [63:0] hi      ;  // 上限（含）
    input [127:0] test_name ;
    begin
        if (actual >= lo && actual <= hi)
          begin
            pass_cnt = pass_cnt + 1 ;
            $display("[PASS] %s: 实际值=0x%0h 在范围 [0x%0h, 0x%0h]", test_name, actual, lo, hi) ;
          end
        else
          begin
            fail_cnt = fail_cnt + 1 ;
            $display("[FAIL] %s: 实际值=0x%0h 超出范围 [0x%0h, 0x%0h]，时刻=%0t ns", test_name, actual, lo, hi, $time) ;
          end
    end
endtask

// 结果汇总（在 $finish 前调用）
task report_result ;
    begin
        $display("") ;
        $display("======== 仿真结果汇总 ========") ;
        $display("  通过：%0d 项", pass_cnt) ;
        $display("  失败：%0d 项", fail_cnt) ;
        if (fail_cnt == 0)
          $display("  结论：✅ 全部通过") ;
        else
          $display("  结论：❌ 存在失败项，请检查") ;
        $display("==============================") ;
    end
endtask
```

## 使用说明

插入后，用户在激励主体中按如下方式调用：

```verilog
// 示例：检查输出信号
@(posedge clk) ;
check_equal(dout, 8'hA5, "数据输出校验") ;

// 示例：检查计数值范围
check_range(cnt_out, 10, 20, "计数范围校验") ;

// 仿真结束前调用汇总
report_result() ;
$finish ;
```

## 注意事项

- `===`（case equality）用于精确比较，包含 X/Z 状态检测
- 不修改 DUT 源文件
- 不执行 git 提交
