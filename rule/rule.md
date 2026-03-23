# AI 使用规则

## 目录

1. [语言要求](#1-语言要求)
2. [项目结构概览](#2-项目结构概览)
3. [Git 提交信息规范](#3-git-提交信息规范)
4. [文档规范](#4-文档规范)
5. [代码通用规范](#5-代码通用规范)
6. [C/C++ 代码规范](#6-cc-代码规范)
7. [Qt C++ 补充规范](#7-qt-c-补充规范)
8. [命名规范](#8-命名规范)
9. [Verilog / SystemVerilog 代码规范](#9-verilog--systemverilog-代码规范)
10. [Python 规范](#10-python-规范)
11. [架构要点](#11-架构要点)

---

## 1. 语言要求

所有回复、解释、思考过程、代码注释及建议，均须使用**中文**。

---

## 2. 项目结构概览

本仓库（`use_ai`）为 AI 协作配置仓库，存放振镜控制板工程的 AI 使用规范与技能脚本：

| 目录 / 文件    | 用途                            |
|-------------|--------------------------------|
| `rule/`     | AI 协作规则文档（`rule.md`）        |
| `skill/`    | Claude Code 自定义技能脚本         |
| `CLAUDE.md` | Claude Code 仓库级行为规范         |
| `README.md` | 仓库说明                         |

> 振镜控制板工程（Zynq FPGA）的实际代码位于独立的工程仓库。

---

## 3. Git 提交信息规范

### 格式

```
<类型>(<范围>): <简短中文描述>

<可选：详细说明>
```

### 类型说明

| 类型         | 用途            |
|------------|---------------|
| `feat`     | 新功能           |
| `fix`      | Bug 修复        |
| `refactor` | 重构（不影响功能）     |
| `docs`     | 文档更新          |
| `style`    | 代码格式调整        |
| `test`     | 测试相关          |
| `chore`    | 构建/工具/依赖变更    |

### 范围（本项目常用）

`PC`、`qt`、`vitis`、`dma`、`uart`、`ui`、`doc`、`verilog`、`matlab`

### 语言要求

- `<简短中文描述>` 须使用**中文**，不超过 50 字符（中文约 25 字）
- 使用祈使句（"新增"而非"新增了"）

### 注意事项

- 提交前确认 `*doc/版本记录.md` 是否需要同步更新
- 涉及 PS/PL 接口变更时，在详细说明中标注影响范围
- **禁止**在提交信息中添加 `Co-Authored-By: Claude` 等 AI 署名行

### 示例

```
feat(dma): 新增 DMA 超时重传逻辑

在 dma_data.c 中增加发送超时检测，超时后自动重发最多 3 次。
```

```
fix(qt): 修复断开连接后界面状态未重置的问题
```

```
docs(doc): 更新 XY2-100 协议接口说明
```

---

## 4. 文档规范

`*doc/` 目录下的每个 `.md` 文件，**正文第一行**为一级标题，其后紧跟版本信息块（`>` 引用格式），再接修改记录表，最后用 `---` 与正文分隔：

```markdown
# 文档标题

> 文件：`文件名.md`
>
> 版本：v1.0
>
> 日期：YYYY-MM-DD
>
> 面向当前工程：（可选，描述文档适用范围）

# 修改记录

| 版本   | 日期         | 修改内容              |
|------|------------|---------------------|
| v1.2 | YYYY-MM-DD | 调整结构：…            |
| v1.1 | YYYY-MM-DD | 补充…                |
| v1.0 | YYYY-MM-DD | 创建文档：简要说明初始内容    |

---

（正文内容）
```

### 修改历史规则

- 最新版本排在**最前面**（倒序排列）
- 仅保留最近 **3 个版本**的修改记录
- 修改内容描述使用**动词开头**的中文祈使句，如"新增…"、"补充…"、"修正…"、"调整…"
- 版本号递增：`v1.0 → v1.1 → v1.2`，重大重构可升主版本 `v1.x → v2.0`
- 文档头的 `版本` 字段与修改记录表最新版本号**必须保持一致**
- 文件名本身不含版本号，版本信息完全在文档内维护
- 每次修改文件后，必须提交一次 git commit

---

## 5. 代码通用规范

适用所有语言文件。

### 修改与废弃

- 修改已有函数或接口时，须说明此改动对其他模块的**影响范围**
- 不随意删除现有代码；废弃代码添加注释说明原因，保留 **3个版本** 后清理

```c
// [废弃] 2026-03-17 旧版超时逻辑，已由 dma_retry() 替代，待下版清理
// void dma_timeout_old() { ... }
```

### 新增代码标注

新增代码须在行尾或上方注释标注日期：

```c
// 2026-03-17 新增：增加超时重传逻辑
if (timeout_cnt > MAX_RETRY) {
    dma_retry();
}
```

### 每次修改后提交

每次实质性修改完成后须执行 `git commit`，保存当前进度。

---

## 6. C/C++ 代码规范

适用文件：`**/*.c`、`**/*.h`、`**/*.cpp`、`**/*.hpp`

> 命名规范见 [第8节](#8-命名规范)

### 缩进与括号

- 使用 **4个空格** 缩进，禁止使用 Tab
- 大括号采用 **K&R 风格**（左括号不换行）

```c
void foo() {
    if (x) {
        do_something();
    }
}
```

### 函数调用格式

- 函数调用**必须写在同一行**，禁止将参数拆分到多行

```c
// ❌ 错误
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                              (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                              gic_ins_ptr);

// ✅ 正确
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, gic_ins_ptr);
```

### 注释规范

- 函数头使用 Doxygen 风格（中文）：

```c
/**
 * @brief  函数简要说明
 * @param  param1  参数1说明
 * @param  param2  参数2说明
 * @return 返回值说明
 * @note   注意事项（可选）
 */
```

- 行内注释（行尾跟随代码）**必须**使用 `//`，禁止使用 `/* */`
- 多行独立注释块使用 `/* */`
- 注释内容使用**中文**
- 分隔式注释（区块标题）统一使用 `// ---- 内容 ----//`，禁止使用 `/* ---- 内容 ---- */`

```c
// ✅ 正确
// ---- 硬件资源 ----//
#define PL_RST_GPIO_DEV_ID       XPAR_AXI_GPIO_0_DEVICE_ID
#define PL_RST_GPIO_CHANNEL      1
#define PL_INTER_NUM             0x02  // 中断电平持续时钟周期
#define INTC_DEVICE_ID           XPAR_SCUGIC_SINGLE_DEVICE_ID

// ❌ 错误
/* ---- 硬件资源 ---- */
#define PL_RST_GPIO_DEV_ID       XPAR_AXI_GPIO_0_DEVICE_ID
#define PL_RST_GPIO_CHANNEL      1
#define PL_INTER_NUM             0x02  /* 中断电平持续时钟周期 */
#define INTC_DEVICE_ID           XPAR_SCUGIC_SINGLE_DEVICE_ID

// ✅ 正确（行尾注释）
XTime _log_start_time = 0;  // log.h 中 extern 声明，此处为唯一定义

// ❌ 错误（行尾注释）
XTime _log_start_time = 0;  /* log.h 中 extern 声明，此处为唯一定义 */
```

### 文件头模板

每个 `.c` / `.h` 文件顶部必须包含：

```c
/*
 * 文件 : xxx.c
 * 描述 : 模块简要说明
 * 版本 : v1.0
 * 日期 : YYYY-MM-DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   xxx      YY/MM/DD   创建文件
 */
```

- 修改记录仅保留最近 **3** 个版本条目，最新在最前

---

## 7. Qt C++ 补充规范

适用文件：`qt/**/*.cpp`、`qt/**/*.h`

> 本节是第6节的补充，命名通用规范见 [第8节](#8-命名规范)。

### 线程安全

- `QWidget` / `QMainWindow` 只做 UI 更新，不阻塞
- 耗时操作（网络、IO）放入 `QThread` 子类
- 跨线程通信**只用 Qt 信号槽**（`Qt::QueuedConnection`），禁止从子线程直接操作控件

### 信号槽声明

```cpp
signals:
    void dataReceived(const QByteArray &data);

private slots:
    void onDataReceived(const QByteArray &data);
```

### QObject 继承

- 继承 `QObject` 的类必须在第一行包含 `Q_OBJECT` 宏
- 构造函数接受 `QObject *parent = nullptr` 并传给基类

```cpp
class UdpWorker : public QThread {
    Q_OBJECT
public:
    explicit UdpWorker(QObject *parent = nullptr);
};
```

### 资源管理

- 优先使用 Qt 父子对象树管理生命周期，减少手动 `delete`
- `QThread` 停止时调用 `quit()` + `wait()`

### Qt 专属命名

| 类型    | 规则          | 示例               |
|-------|-------------|------------------|
| 信号名   | 动词过去式或名词    | `dataReceived`   |
| 槽名    | `on` + 信号名  | `onDataReceived` |
| UI 成员 | `m_` 前缀     | `m_btnSend`      |

---

## 8. 命名规范

适用文件：`**/*.c`、`**/*.h`、`**/*.cpp`、`**/*.hpp`、`**/*.py`、`**/*.m`、`**/*.v`、`**/*.sv`

### C/C++

| 类型      | 风格               | 示例                       |
|---------|------------------|--------------------------|
| 变量、函数   | 小写下划线            | `recv_buf`、`init_dma()`  |
| 宏定义     | 全大写下划线           | `MAX_BUF_SIZE`           |
| 全局变量    | `g_` 前缀 + 小写下划线  | `g_tx_count`             |
| 类名、结构体  | 大驼峰或小写下划线        | `UdpWorker`、`udp_worker` |
| 成员变量    | 小写下划线，可选 `m_` 前缀 | `m_socket`、`buf_len`     |

### Python

| 类型    | 风格     | 示例                      |
|-------|--------|-------------------------|
| 变量、函数 | 小写下划线  | `recv_buf`、`init_dma()` |
| 常量    | 全大写下划线 | `MAX_BUF_SIZE`          |
| 类名    | 大驼峰    | `UdpWorker`             |
| 私有成员  | 单下划线前缀 | `_internal_var`         |

### MATLAB

| 类型    | 风格     | 示例                      |
|-------|--------|-------------------------|
| 变量、函数 | 小写下划线  | `recv_buf`、`parse_csv()` |
| 常量    | 全大写下划线 | `MAX_ROWS`              |

### Verilog / SystemVerilog

| 类型      | 风格                    | 示例                     |
|---------|-----------------------|------------------------|
| 模块名、信号名 | 小写下划线                 | `axis_rx`、`data_valid` |
| 参数、宏    | 全大写下划线                | `DATA_WIDTH`           |
| 寄存器信号   | `_r` 后缀               | `cnt_r`、`state_r`      |
| 复位信号    | 低有效 `rst_n`，高有效 `rst` | `rst_n`、`rst`          |

### 通用原则

- 命名要有意义，避免单字母（除循环变量 `i`、`j`、`k`）
- 布尔变量用 `is_`、`has_`、`can_` 前缀，如 `is_valid`、`has_data`

---

## 9. Verilog / SystemVerilog 代码规范

适用文件：`**/*.v`、`**/*.sv`、`**/*.vh`、`**/*.svh`

> 命名规范见 [第8节](#8-命名规范)

### 缩进

- 使用 **2个空格** 缩进，禁止使用 Tab

### begin/end 换行规范

- `begin` 必须**另起一行**，不得与 `always`、`if`、`else`、`for` 写在同一行

```verilog
always @(posedge clk or posedge rst)
  begin
    if (rst)
      begin
        q <= 1'b0;
      end
  end
```

### 单bit信号常量规范

- 所有单bit信号的比较与赋值必须显式写出位宽，使用 `1'b0` / `1'b1`，禁止直接使用 `0` / `1`

```verilog
if (rstn == 1'b0)
q <= 1'b1;
```

### 赋值规范

- 时序逻辑使用非阻塞赋值 `<=`，组合逻辑使用阻塞赋值 `=`
- 端口声明每行一个信号，对齐排列

### 端口对齐风格

```verilog
module foo #(
  parameter DATA_WIDTH = 16
) (
  input  wire                  clk             ,  // 系统时钟
  input  wire                  rstn            ,  // 低有效复位
  input  wire [DATA_WIDTH-1:0] s_axis_tdata    ,  // AXI-Stream 数据输入
  output wire [DATA_WIDTH-1:0] m_axis_tdata       // AXI-Stream 数据输出
);
```

### 文件头模板

每个 `.v` 文件顶部须包含：

```verilog
/**************************************************************************/
// Function   : 模块功能简述
// Version    : v1.0
// Date       : YYYY/MM/DD
// Description: 详细说明（多行）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        YYYY/MM/DD  创建文件
/**************************************************************************/
```

- 修改记录仅保留最近 **3** 个版本，最新在最前

### 注释规范

- 模块头部注释使用中文说明功能和端口
- 行内注释使用 `//`，内容使用**中文**

---

## 10. Python 规范

适用文件：`**/*.py`

> 命名规范见 [第8节](#8-命名规范)

### 环境要求

- **不使用虚拟环境**，直接使用系统全局 Python
- 禁止使用 `venv`、`virtualenv`、`conda env`、`pipenv` 等工具
- 安装依赖：`pip install <package>`
- 运行脚本：`python script.py`
- 依赖记录使用项目根目录 `requirements.txt`，安装时直接装到系统环境：

```bash
pip install -r requirements.txt
```

### 文件头模板

每个 `.py` 文件顶部须包含：

```python
"""
文件名.py  --  模块简要说明
版本    : vX.Y
日期    : YYYY-MM-DD

修改记录:
    vX.Y  新增/修复/调整 说明
"""
```

### 函数注释（docstring）

```python
def func_name(param1, param2):
    """
    函数简要说明。

    Args:
        param1: 参数1说明
        param2: 参数2说明

    Returns:
        返回值说明
    """
```

### 类注释

```python
class MyClass:
    """
    类的用途说明。

    Attributes:
        attr1: 属性1说明
    """
```

### 行内注释

- 注释使用**中文**
- 新增代码标注日期：`# YYYY-MM-DD 新增：说明`
- 私有成员用单下划线前缀：`_internal_var`

### PyQt5 线程约定

- **GUI 线程**（`MainWindow`）只做 UI 更新，不阻塞
- **工作线程**（`QThread` 子类）独立维护 socket 等资源
- 跨线程通信**只用 Qt 信号槽**，禁止从子线程直接操作控件
- 高吞吐场景：批量操作用 `deque`，日志用定时器批量刷入，状态标签限频 `setText()`

---

## 11. 架构要点

### Vitis PS 端（`vitis/xy2_100/src/`）

- 主循环采用 **init + poll 模式**：`xxx_init(&intc)` → 主循环 `xxx_poll()`
- 跨 PS/PL 接口的寄存器地址在 `xparameters.h` 中，新增外设须先确认地址映射
- 错误通过 `log` 模块上报，不在中断中做复杂处理

**Log 四级分层：**

| 级别                          | 默认状态 | 用途       |
|-----------------------------|------|----------|
| `prinfo` / `prwarn` / `prerror` | 常开   | 关键信息与错误  |
| `prbrief`                   | 默认开  | 简要流程日志   |
| `prdebug` / `prlist` / `prhigh` | 默认关  | 调试与详细输出  |

**协议命令类型（`CmdType = 0xAABBCCDD`）：**

| 字节 | 含义                             |
|----|--------------------------------|
| AA | 执行类型：`0x5A` 立即执行，`0xA5` 列表执行   |
| BB | 大类命令                           |
| CC | 子命令                            |
| DD | 应答类型：`0x55` 统一应答，`0xAA` 特定应答   |

**DDR 布局：**

```
代码区 → PROG(32MB) → CORR(8MB) → JUMP(4KB) → DMA_X/Y/Z(各10MB) → LIST(16MB)
```

### Verilog PL 端（`source/verilog/`）

- 时序逻辑用非阻塞赋值 `<=`，组合逻辑用阻塞赋值 `=`
- 复位信号统一命名：低有效 `rst_n`，高有效 `rst`
