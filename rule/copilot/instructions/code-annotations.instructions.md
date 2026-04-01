---

description: "代码通用标注规范：新增/修改/废弃代码的注释格式（版本号 + 日期 + 说明）。适用于所有代码文件。"
applyTo: "**/*.c,**/*.h,**/*.cpp,**/*.hpp,**/*.py,**/*.m,**/*.v,**/*.sv"
---

# 代码通用标注规范

## 格式规则

所有标注统一格式：`<注释符> [动作] vX.Y YYYY/MM/DD 说明`

- 版本号：`vX.Y`（与当前文件头版本一致）
- 日期：`YYYY/MM/DD`
- 动作：`新增` / `修改` / `[废弃]`

## 新增代码标注

在新增代码行上方标注：

```c
// v1.2 2026/03/17 新增：增加超时重传逻辑
if (timeout_cnt > MAX_RETRY) {
    retry();
}
```

Python：
```python
# v1.2 2026/03/17 新增：增加超时重传逻辑
if timeout_cnt > MAX_RETRY:
    retry()
```

Verilog：
```verilog
// v1.2 2026/03/17 新增：增加超时计数器清零逻辑
if (timeout_r == 1'b1)
  begin
    cnt_r <= 16'd0;
  end
```

MATLAB：
```matlab
% v1.2 2026/03/17 新增：增加频谱归一化处理
amp = abs(fft_result) / length(signal);
```

## 修改代码标注

在修改行上方标注，说明修改内容和原因：

```c
// v1.2 2026/03/17 修改：超时阈值从固定值改为可配置参数
if (timeout_cnt > g_max_retry) {
    retry();
}
```

## 废弃代码标注

注释掉废弃代码，注明废弃版本、原因、计划清理版本，保留 **3 个版本**后删除：

```c
// [废弃] v1.2 2026/03/17 旧版超时逻辑，已由 retry() 替代，v1.5 后清理
// void timeout_old(int cnt) { ... }
```

## 影响范围说明

修改已有函数或接口时，在 git commit 详细说明或函数头注释中标注影响范围：

```c
/**
 * @brief  发送数据
 * @note   v1.2 接口变更：新增 retry_cnt 参数，影响 dma_ctrl.c / uart_tx.c 调用处
 */
int send_data(uint8_t *buf, int len, int retry_cnt);
```
