---

description: "错误处理规范：不静默吞错误、C返回码约定、Python异常规范、Verilog default分支。当编写 C/Python/Verilog 代码时使用。"
applyTo: "**/*.c,**/*.h,**/*.cpp,**/*.hpp,**/*.py,**/*.v,**/*.sv"
---

# 错误处理规范

## 通用原则

- **不静默吞掉错误**：捕获后必须记录日志或向上传递，禁止空的 `catch` / 空的错误分支
- 错误处理只针对**真实可能发生**的场景，不为不可能路径添加防御
- 系统边界（用户输入、外部 API、文件 IO）做完整校验，内部函数信任调用方

## C/C++

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

## Python

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

## Verilog

- 组合逻辑的 `case` 语句须包含 `default` 分支，避免综合出锁存器
- 异步复位信号在释放时注意亚稳态，必要时加同步器
