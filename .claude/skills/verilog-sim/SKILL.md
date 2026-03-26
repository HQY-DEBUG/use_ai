---
name: verilog-sim
description: 使用 iverilog 编译并运行 Verilog 仿真，解析输出结果，报告通过/失败。用法：/verilog-sim <tb文件路径> [dut文件路径...]
argument-hint: <tb文件> [dut文件1 dut文件2 ...]
allowed-tools: [Read, Glob, Grep, Bash]
disable-model-invocation: true
---

# Verilog 仿真运行

仿真目标：$ARGUMENTS

## 操作步骤

1. 从参数解析 TB 文件和 DUT 文件列表（第一个参数为 TB 文件，其余为 DUT 文件）
2. 若未指定 DUT，自动搜索当前目录下与 TB 文件名对应的 `.v` 文件（去掉 `_tb` 后缀）
   - 例如：`uart_tx_tb.v` → 自动查找 `uart_tx.v`
3. 检查 iverilog 是否已安装：
   ```bash
   which iverilog
   ```
   若未安装，输出提示后终止
4. 使用 iverilog 编译：
   ```bash
   iverilog -o sim_out.vvp <tb文件> <dut文件...>
   ```
5. 运行仿真：
   ```bash
   vvp sim_out.vvp
   ```
6. 解析仿真输出：
   - 提取所有 `$display` 输出
   - 检测 `$error` / `$fatal` / `FAILED` / `ERROR` 关键字
   - 检测仿真是否正常结束（`$finish`）还是超时/异常
7. 清理临时文件：
   ```bash
   rm -f sim_out.vvp
   ```
8. 输出仿真报告

## 注意事项

- 若 iverilog 未安装，输出提示：`iverilog 未安装，请先执行 sudo apt install iverilog 或 pacman -S iverilog`
- 不修改任何源文件
- 不执行 git 提交

## 输出格式

```
== Verilog 仿真报告：<tb文件名> ==

编译：✅ 成功 / ❌ 失败
  <编译错误信息（若有）>

仿真：✅ 正常结束 / ❌ 异常终止

仿真输出：
  <$display 输出逐行列出>

结果统计：
  PASS：N 项
  FAIL：M 项
  ERROR：K 项

结论：✅ 全部通过 / ❌ 存在失败项，需检查
```
