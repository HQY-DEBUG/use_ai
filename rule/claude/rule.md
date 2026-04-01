# AI 使用规则（通用版）

> 版本：v1.4　日期：2026/04/01
>
> 本文件为通用 AI 协作规范，适用于各类软件工程项目。
> 各项目可在此基础上扩展项目特有规则，见 [第14节](#14-项目扩展说明)。

## 修改记录

| 版本   | 日期         | 修改内容                                          |
|------|------------|------------------------------------------------|
| v1.4 | 2026/04/01 | 同步 .github/instructions 最新内容，补充各语言详细规范        |
| v1.3 | 2026/03/27 | 新增第15节仓库目录规范                                   |
| v1.2 | 2026/03/27 | 调整命名规范至第8节，置于所有语言规范之前                         |

---

## 目录

1. [语言要求](#1-语言要求)
2. [AI 行为约束](#2-ai-行为约束)
3. [安全规范](#3-安全规范)
4. [Git 提交信息规范](#4-git-提交信息规范)
5. [代码通用标注规范](#5-代码通用标注规范)
6. [错误处理规范](#6-错误处理规范)
7. [命名规范](#7-命名规范)
8. [C/C++ 代码规范](#8-cc-代码规范)
9. [Qt C++ 补充规范](#9-qt-c-补充规范)
10. [Verilog / SystemVerilog 代码规范](#10-verilog--systemverilog-代码规范)
11. [Python 规范](#11-python-规范)
12. [MATLAB 规范](#12-matlab-规范)
13. [文档规范](#13-文档规范)
14. [项目扩展说明](#14-项目扩展说明)
15. [仓库目录规范](#15-仓库目录规范)

---

## 1. 语言要求

所有回复、解释、思考过程、代码注释及建议，均须使用**中文**。

---

## 2. AI 行为约束

### 操作前提

- 修改任何文件前**必须先读取**该文件，理解现有内容后再动手
- 对未读过的代码，不得直接提出修改建议

### 最小修改原则

- 只做被明确要求的事，**不添加**未被要求的功能、配置或优化
- 不因"顺手"而重构周边代码、补充注释、修改格式
- 三行相似代码优于一个过早的抽象

### 破坏性操作

以下操作执行前须明确告知用户并等待确认：

- 删除文件、目录或 git 分支
- `git reset --hard`、`git push --force`、`git rebase`
- 清空数据库表、覆盖未备份的文件
- 修改 CI/CD 流水线或共享基础设施

### 不过度设计

- 不引入仅为"将来可能用到"的配置项、抽象层或兼容性代码
- 不添加对内部代码不必要的防御性校验（仅在系统边界校验外部输入）
- 不添加多余的错误回退逻辑（对不可能发生的场景）

### 任务完成后

- 每次实质性修改完成后执行 `git commit`
- 不在回复末尾重复总结刚才做了什么（用户可自行查看 diff）

---

## 3. 安全规范

### 密钥与凭据

- **禁止**将密钥、密码、Token、证书私钥硬编码在源代码中
- **禁止** commit `.env`、`credentials.json`、`secrets.*` 等敏感文件；须加入 `.gitignore`
- 配置项通过环境变量或独立配置文件（不纳入版本管理）传入

```c
// ❌ 错误
#define API_KEY "sk-abc123xyz"

// ✅ 正确
const char *api_key = getenv("API_KEY");
```

### 输入校验

- 所有来自**系统边界**的数据（用户输入、串口/网络报文、文件内容）必须校验后再使用
- 内部函数之间的调用信任调用方，不重复校验
- 禁止将外部输入直接拼入 shell 命令（命令注入）

### 日志与调试输出

- 日志中**禁止**输出密钥、完整密码、用户隐私数据
- 调试用的敏感打印在正式版本中须关闭或脱敏

### 依赖安全

- 不引入无来源、无维护的第三方库
- 记录依赖版本（`requirements.txt` / `CMakeLists.txt`），便于排查已知漏洞

---

## 4. Git 提交信息规范

### 格式

```
<类型>(<范围>): <简短中文描述>

<可选：详细说明>
```

### 类型

| 类型         | 用途              |
|------------|-----------------|
| `feat`     | 新功能             |
| `fix`      | Bug 修复          |
| `refactor` | 重构（不影响功能）       |
| `docs`     | 文档更新            |
| `style`    | 代码格式调整          |
| `test`     | 测试相关            |
| `chore`    | 构建 / 工具 / 依赖变更  |

### 语言与格式要求

- `<简短中文描述>` 使用**中文祈使句**，不超过 50 字符（中文约 25 字）
- ✅ "新增超时逻辑" / ❌ "新增了超时逻辑"（禁用完成时态）
- **禁止**在提交信息中添加任何 AI 署名行（如 `Co-Authored-By: Claude`、`Co-authored-by: Copilot` 等）
- 涉及接口变更时，在详细说明中标注影响范围

### 示例

```
// ✅ 正确
feat(core): 新增超时重传逻辑

在发送模块增加超时检测，超时后自动重发最多 3 次。
```

```
// ✅ 正确
fix(ui): 修复断开连接后界面状态未重置的问题
```

```
// ❌ 错误：含 AI 署名
feat(core): 新增超时逻辑

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## 5. 代码通用标注规范

所有标注统一格式：`<注释符> [动作] vX.Y YYYY/MM/DD 说明`

- 版本号：`vX.Y`（与当前文件头版本一致）
- 日期：`YYYY/MM/DD`
- 动作：`新增` / `修改` / `[废弃]`

### 新增代码标注

```c
// v1.2 2026/03/17 新增：增加超时重传逻辑
if (timeout_cnt > MAX_RETRY) {
    retry();
}
```

Verilog：
```verilog
// v1.2 2026/03/17 新增：增加超时计数器清零逻辑
if (timeout_r == 1'b1)
  begin
    cnt_r <= 16'd0;
  end
```

### 修改代码标注

```c
// v1.2 2026/03/17 修改：超时阈值从固定值改为可配置参数
if (timeout_cnt > g_max_retry) {
    retry();
}
```

### 废弃代码标注

注释掉废弃代码，注明废弃版本、原因、计划清理版本，保留 **3 个版本**后删除：

```c
// [废弃] v1.2 2026/03/17 旧版超时逻辑，已由 retry() 替代，v1.5 后清理
// void timeout_old(int cnt) { ... }
```

### 接口变更标注

修改已有函数或接口时，在 git commit 详细说明或函数头注释中标注影响范围：

```c
/**
 * @brief  发送数据
 * @note   v1.2 接口变更：新增 retry_cnt 参数，影响 dma_ctrl.c / uart_tx.c 调用处
 */
int send_data(uint8_t *buf, int len, int retry_cnt);
```

---

## 6. 错误处理规范

### 通用原则

- **不静默吞掉错误**：捕获后必须记录日志或向上传递，禁止空的 `catch` / 空的错误分支
- 错误处理只针对**真实可能发生**的场景，不为不可能路径添加防御
- 系统边界（用户输入、外部 API、文件 IO）做完整校验，内部函数信任调用方

### C/C++

- 返回值约定：`0` 成功，负数错误码（`-1` 通用错误，`-2` 超时等）
- 错误通过日志模块记录，不直接 `printf`
- 禁止忽略函数返回值（尤其是 `malloc`、`fopen`、硬件寄存器操作）

```c
ret = module_init();
if (ret != 0) {
    log_error("module_init 失败，ret=%d", ret);
    return ret;
}
```

### Python

- 使用具体异常类型，禁止裸 `except:` 或 `except Exception:`（除非顶层兜底）
- 资源（文件、socket）使用 `with` 语句管理，确保释放

```python
try:
    with open(path, 'r') as f:
        data = f.read()
except FileNotFoundError:
    log.error(f"文件不存在：{path}")
    return None
```

### Verilog

- 组合逻辑的 `case` 语句须包含 `default` 分支，避免综合出锁存器
- 异步复位信号在释放时注意亚稳态，必要时加同步器

---

## 7. 命名规范

### C/C++

| 类型       | 风格              | 示例                         |
|----------|-----------------|----------------------------|
| 变量、函数    | 小写下划线           | `recv_buf`、`init_dma()`    |
| 宏定义      | 全大写下划线          | `MAX_BUF_SIZE`             |
| 全局变量     | `g_` 前缀 + 小写下划线 | `g_tx_count`               |
| 类名、结构体   | 大驼峰或小写下划线       | `UdpWorker`、`udp_worker`   |
| 成员变量     | 小写下划线，可选 `m_` 前缀 | `m_socket`、`buf_len`       |

### Python

| 类型    | 风格       | 示例               |
|-------|----------|------------------|
| 变量、函数 | 小写下划线    | `recv_buf`、`init_dma()` |
| 常量    | 全大写下划线   | `MAX_BUF_SIZE`   |
| 类名    | 大驼峰      | `UdpWorker`      |
| 私有成员  | 单下划线前缀   | `_internal_var`  |

### MATLAB

| 类型    | 风格     | 示例                   |
|-------|--------|----------------------|
| 变量、函数 | 小写下划线  | `recv_buf`、`parse_csv()` |
| 常量    | 全大写下划线 | `MAX_ROWS`           |

### Verilog / SystemVerilog

| 类型          | 风格                              | 示例                            |
|-------------|----------------------------------|-------------------------------|
| 模块名、信号名     | 小写下划线                           | `axis_rx`、`data_valid`        |
| 参数、宏        | 全大写下划线                          | `DATA_WIDTH`                  |
| 延时信号        | `_r` 后缀；多级延时用 `_r1`、`_r2` 递增    | `cnt_r`、`data_r1`、`data_r2`  |
| 复位信号        | 低有效 `rstn`，高有效 `rst`             | `rstn`、`rst`                  |
| 输入/输出冲突消歧   | 优先不加后缀；冲突时输入加 `_i`、输出加 `_o`     | `data_i`、`data_o`             |

> 注意：总线接口信号（AXI/AXIS 等）不使用 `_i`/`_o` 后缀；非必要不加后缀。

### 通用原则

- 命名要有意义，避免单字母（除循环变量 `i`、`j`、`k`）
- 布尔变量用 `is_`、`has_`、`can_` 等前缀，如 `is_valid`、`has_data`（仅适用于 C/C++/Python/Qt，Verilog 不使用）

---

## 8. C/C++ 代码规范

### 缩进与括号

- 使用 **4个空格** 缩进，禁止使用 Tab
- 大括号采用 **K&R 风格**：左括号不换行

```c
// ✅ 正确
void foo() {
    if (x) {
        do_something();
    }
}

// ❌ 错误（左括号换行）
void foo()
{
    if (x)
    {
        do_something();
    }
}
```

### 函数调用格式

函数调用**必须写在同一行**，禁止将参数拆分到多行：

```c
// ✅ 正确
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, gic_ins_ptr);

// ❌ 错误
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                              (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                              gic_ins_ptr);
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

- 所有注释（行内、多行独立注释块）统一使用 `//`，**禁止**使用 `/* */`（文件头除外）
- 注释内容使用**中文**
- 区块标题使用 `// ---- 内容 ----//`，**禁止**使用 `/* ---- 内容 ---- */`

```c
// ✅ 正确
// ---- 硬件资源 ----//
#define PL_RST_GPIO_DEV_ID  XPAR_AXI_GPIO_0_DEVICE_ID
```

### 注释对齐规范

同一连续代码块（结构体字段、成组宏、初始化表项）的行尾注释**纵向对齐**：

```c
// ✅ 正确（对齐）
#define PL_RST_GPIO_DEV_ID   XPAR_AXI_GPIO_0_DEVICE_ID  // GPIO 设备 ID
#define PL_RST_GPIO_CHANNEL  1                            // 通道号
#define PL_INTER_NUM         0x02                         // 中断持续时钟周期
```

### 文件头模板

```c
/*
 * 文件 : xxx.c
 * 描述 : 模块简要说明
 * 版本 : v1.0
 * 日期 : YYYY/MM/DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      YY/MM/DD   创建文件
 */
```

- 修改记录仅保留最近 **3** 个版本，最新在最前

---

## 9. Qt C++ 补充规范

> 本节是第8节 C/C++ 规范的补充，适用于 Qt 代码。

### 线程安全

- `QWidget` / `QMainWindow` 只做 UI 更新，不阻塞
- 耗时操作（网络、IO）放入 `QThread` 子类
- 跨线程通信**只用 Qt 信号槽**（`Qt::QueuedConnection`），**禁止**从子线程直接操作控件

```cpp
// ❌ 错误：从子线程直接操作 UI
m_label->setText("done");

// ✅ 正确：通过信号槽传递到 GUI 线程
emit statusUpdated("done");
```

### 信号槽声明

```cpp
signals:
    void dataReceived(const QByteArray &data);   // 信号：动词过去式
    void errorOccurred(const QString &msg);

private slots:
    void onDataReceived(const QByteArray &data); // 槽：on + 信号名
    void onErrorOccurred(const QString &msg);
```

### QObject 继承

- 继承 `QObject` 的类第一行必须包含 `Q_OBJECT` 宏
- 构造函数接受 `QObject *parent = nullptr` 并传给基类

### 资源管理

- 优先使用 Qt 父子对象树管理生命周期，减少手动 `delete`
- `QThread` 停止时调用 `quit()` + `wait()`，**禁止**直接 `terminate()`

### 命名补充

| 类型    | 规则          | 示例               |
|-------|-------------|------------------|
| 信号名   | 动词过去式或名词    | `dataReceived`   |
| 槽名    | `on` + 信号名  | `onDataReceived` |
| UI 成员 | `m_` 前缀     | `m_btnSend`      |

---

## 10. Verilog / SystemVerilog 代码规范

### 缩进

- 使用 **2个空格** 缩进，禁止使用 Tab

### begin/end 换行规范

`begin` 必须**另起一行**，不得与 `always`、`if`、`else`、`for` 写在同一行：

```verilog
// ✅ 正确
always @(posedge clk or negedge rstn)
  begin
    if (rstn == 1'b0)
      begin
        q <= 1'b0;
      end
    else
      begin
        q <= d;
      end
  end

// ❌ 错误（begin 未另起一行）
always @(posedge clk or negedge rstn) begin
    if (rstn == 1'b0) begin
        q <= 1'b0;
    end
end
```

### 单bit信号常量规范

所有单bit信号的比较与赋值必须显式写出位宽，使用 `1'b0` / `1'b1`，**禁止**直接使用 `0` / `1`：

```verilog
// ✅ 正确
if (rstn == 1'b0)
if (valid == 1'b1)
q <= 1'b0;

// ❌ 错误
if (rstn == 0)
if (valid == 1)
q <= 0;
```

### 赋值与信号定义规范

- 时序逻辑使用非阻塞赋值 `<=`，组合逻辑使用阻塞赋值 `=`
- 端口声明每行一个信号，对齐排列
- 寄存器/信号定义按类型、位宽、名称、分号四列对齐，末尾加 `//` 中文注释：

```verilog
reg     [3:0]   cnt     ;   // 计数器
reg             flag    ;   // 标志位
wire    [7:0]   data    ;   // 数据总线
wire            valid   ;   // 有效信号
```

### case 语句必须有 default

组合逻辑的 `case` 必须包含 `default` 分支，避免综合出锁存器：

```verilog
// ✅ 正确
always @(*)
  begin
    case (state_r)
      2'd0:    next = 2'd1;
      2'd1:    next = 2'd2;
      default: next = 2'd0;
    endcase
  end
```

### 端口对齐风格

方向 / 类型 / 位宽 / 名称 / 逗号各列对齐，末尾用 `//` 中文注释：

```verilog
module foo #(
  parameter DATA_WIDTH = 16
) (
  input  wire                  clk          ,  // 系统时钟
  input  wire                  rstn         ,  // 低有效复位
  input  wire [DATA_WIDTH-1:0] s_axis_tdata ,  // AXI-Stream 数据输入
  input  wire                  s_axis_tvalid,  // 数据有效
  output wire                  s_axis_tready,  // 接收就绪
  output wire [DATA_WIDTH-1:0] m_axis_tdata ,  // AXI-Stream 数据输出
  output wire                  m_axis_tvalid   // 输出有效
);
```

### 文件头模板

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
- 行内注释使用 `//`，内容使用**中文**

---

## 11. Python 规范

### 环境要求

- 不使用 `venv`、`virtualenv`、`conda env`、`pipenv` 等工具创建隔离环境
- 直接使用系统全局 Python 环境：`python script.py`
- 安装依赖：`pip install <package>` 或 `pip install -r requirements.txt`

### 文件头模板

```python
"""
文件名.py  --  模块简要说明
版本    : vX.Y
日期    : YYYY/MM/DD

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

### PyQt5 线程约定

- **GUI 线程**（`MainWindow`）只做 UI 更新，不阻塞
- **工作线程**（`QThread` 子类）独立维护 socket 等资源
- 跨线程通信**只用 Qt 信号槽**，禁止从子线程直接操作控件
- 高吞吐场景：批量操作用 `deque`，日志用定时器批量刷入，状态标签限频 `setText()`

---

## 12. MATLAB 规范

### 文件头模板

```matlab
% =========================================================================
% 文件    : xxx.m
% 描述    : 模块简要说明
% 版本    : v1.0
% 日期    : YYYY/MM/DD
%
% 修改记录（最新版本在最前）:
%  ver     date        modification
% ------  ----------  -----------------------------------------------------
%  v1.0   YYYY/MM/DD  创建文件
% =========================================================================
```

- 修改记录仅保留最近 **3** 个版本，最新在最前

### 函数注释

```matlab
function result = calc_fft(signal, fs)
% calc_fft  计算信号的 FFT 频谱
%
% 输入：
%   signal  - 时域信号向量
%   fs      - 采样率（Hz）
%
% 输出：
%   result  - 频谱结构体，含 freq（频率轴）和 amp（幅值）
```

### 其他约定

- 注释使用**中文**，区块标题用 `%% 内容`（产生代码折叠节）
- 避免使用 `clear all` / `close all`
- 矩阵运算优先于循环；必须用循环时加注释说明原因
- 图形输出须设置标题、坐标轴标签和单位

---

## 13. 文档规范

### 文档头模板

每个 `.md` 文件**正文第一行**为一级标题，紧跟版本信息块（`>` 引用格式），再接修改记录表，用 `---` 与正文分隔：

```markdown
# 文档标题

> 版本：v1.0　日期：YYYY/MM/DD

# 修改记录

| 版本   | 日期         | 修改内容           |
|------|------------|------------------|
| v1.1 | YYYY/MM/DD | 补充…             |
| v1.0 | YYYY/MM/DD | 创建文档            |

---

（正文内容）
```

### 修改记录规则

- 最新版本排在**最前面**（倒序），仅保留最近 **3 个版本**（超出则删除最旧行）
- 版本号递增：`v1.0 → v1.1 → v1.2`；重大重构升主版本 `v1.x → v2.0`
- 描述使用**动词开头**的中文祈使句：✅ "新增…" / ❌ "新增了…"
- 文档头 `版本` 字段与修改记录表最新版本号**必须一致**
- 日期格式统一为 `YYYY/MM/DD`，禁止使用 `YYYY-MM-DD`

---

## 14. 项目扩展说明

本文件为通用规范。各项目在 `CLAUDE.md` / `copilot-instructions.md` 中扩展项目特有规则，包括：

- 项目特定的 Git 范围（`<范围>` 取值）
- 项目架构要点（DDR 布局、协议命令格式等）
- 项目专有命名约定

---

## 15. 仓库目录规范

### 标准目录树

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

### 各目录说明

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

### 使用规则

- 新建文件时，根据文件类型放入对应目录，**禁止**随意放置在根目录
- `doc/<库名>/` 目录名须与所描述的库或模块名称一致，不使用 `lib`/`other` 等通用名称
- `PL/source/` 下可按功能再分子目录，但须保留 `constraints/`、`ip/`、`sim/`、`verilog/` 四个标准子目录
- `PL/bit/` 只存放编译产物，不存放任何源代码
- `vitis/` 目录结构由 Vitis IDE 自动生成，不手动调整顶层结构
