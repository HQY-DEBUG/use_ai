---

description: "仓库目录规范：标准目录树及各目录用途。新建文件或建议路径时使用，确保文件放入正确位置。"
applyTo: "**/*"
---

# 仓库目录规范

## 标准目录树

```
项目根目录/
├── doc/                  # 说明与参考文档
│   ├── code/             # 代码相关说明文件
│   ├── ref/              # 项目相关参考资料
│   ├── <库名>/           # 某库或模块的专项说明（目录名与库/模块同名）
│   └── <其他>/           # 其他参考文件，按需分类
│
├── PC/                   # 上位机代码
│   ├── py_code/          # Python 上位机代码
│   └── qt/               # Qt 上位机代码
│
├── PL/                   # FPGA PL 端相关文件
│   ├── *.tcl             # 工程 TCL 脚本
│   ├── xilinx.py         # Xilinx 工具 Python 脚本
│   ├── bit/              # 编译产物（.bit / .xsa / .ltx）
│   └── source/           # 源代码（可含多级子目录）
│       ├── constraints/  # 约束文件（.xdc）
│       ├── ip/           # IP 核文件
│       ├── sim/          # 仿真文件
│       └── verilog/      # Verilog / SystemVerilog 源文件
│
├── vitis/                # Vitis 工程文件（PS 端）
└── matlab/               # MATLAB 相关代码与脚本
```

## 各目录说明

| 目录 | 存放内容 | 说明 |
|------|---------|------|
| `doc/code/` | 代码相关说明文档 | 接口说明、模块设计文档等 |
| `doc/ref/` | 项目参考资料 | 数据手册、标准文档等 |
| `doc/<库名>/` | 某库的专项说明 | 目录名与所描述的库或模块同名 |
| `PC/py_code/` | Python 上位机代码 | 独立于 Qt 的纯 Python 工具/脚本 |
| `PC/qt/` | Qt 上位机工程 | `.pro`、`.cpp`、`.h`、`.ui` 等 |
| `PL/bit/` | PL 编译产物 | 只存放 `.bit`/`.xsa`/`.ltx`，不存放源码 |
| `PL/source/constraints/` | 约束文件 | `.xdc` 时序/管脚约束 |
| `PL/source/ip/` | IP 核文件 | Vivado IP 相关文件 |
| `PL/source/sim/` | 仿真文件 | testbench、激励文件等 |
| `PL/source/verilog/` | Verilog 源文件 | `.v`/`.sv`/`.vh` 等 |
| `vitis/` | Vitis 工程 | PS 端 C/C++ 工程，由 IDE 管理结构 |
| `matlab/` | MATLAB 代码 | `.m` 脚本与函数文件 |

## 使用规则

- 新建文件时，根据文件类型放入对应目录，**禁止**随意放置在根目录
- `doc/<库名>/` 目录名须与所描述的库或模块名称一致，不使用 `lib`/`other` 等通用名称
- `PL/source/` 下可按功能再分子目录，但须保留 `constraints/`、`ip/`、`sim/`、`verilog/` 四个标准子目录
- `PL/bit/` 只存放编译产物，不存放任何源代码
- `vitis/` 目录结构由 Vitis IDE 自动生成，不手动调整顶层结构
