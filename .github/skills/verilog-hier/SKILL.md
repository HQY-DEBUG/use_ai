---
name: verilog-hier
description: 分析多个 Verilog 文件的模块层次结构，输出调用树和依赖关系。用法：/verilog-hier <顶层模块名> <目录或文件列表>
argument-hint: <顶层模块名> <目录或文件...>
allowed-tools: [Read, Glob]
---

# 分析 Verilog 模块层次结构

参数：$ARGUMENTS

## 操作步骤

1. 解析参数：提取顶层模块名和扫描路径
2. 用 Glob 收集路径下所有 `.v` / `.sv` 文件
3. 逐文件读取，建立映射表：
   - `模块名 → 文件路径`（从 `module <name>` 提取）
   - `模块名 → 例化的子模块列表`（从 `<子模块名> <实例名> (` 提取）
4. 从顶层模块递归展开，构建层次树
5. 检测并标注：
   - 未找到定义的模块（标注 `[未找到]`）
   - 被多次例化的模块（标注例化次数）
   - 循环依赖（标注 `[循环依赖!]`）
6. 输出层次树和统计摘要

## 输出格式

```
模块层次树（顶层：<顶层模块名>）
────────────────────────────────
<顶层模块名>  [top.v]
├── module_a  [src/module_a.v]  ×2
│   ├── sub_x  [src/sub_x.v]
│   └── sub_y  [src/sub_y.v]
└── module_b  [src/module_b.v]
    └── sub_x  [src/sub_x.v]  （已列出）

统计：共 N 个唯一模块，M 个例化，L 个未找到定义
未找到定义的模块：fifo_gen_0, blk_mem_gen_0（IP 核，忽略）
```

## 注意事项

- Xilinx IP 核（`blk_mem_gen_*`、`fifo_generator_*` 等）无源文件属正常情况，统一标注为 IP 核
- 只分析直接例化，不解析 `` `include ``
- 不修改任何文件
