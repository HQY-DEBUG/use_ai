---

description: "安全规范：禁止硬编码密钥/密码、系统边界输入校验、日志脱敏、依赖安全。当编写任何代码文件时使用。"
applyTo: "**/*.c,**/*.h,**/*.cpp,**/*.hpp,**/*.py,**/*.m,**/*.v,**/*.sv"
---

# 安全规范

## 密钥与凭据

- **禁止**将密钥、密码、Token、证书私钥硬编码在源代码中
- **禁止** commit `.env`、`credentials.json`、`secrets.*` 等敏感文件；须加入 `.gitignore`
- 配置项通过环境变量或独立配置文件（不纳入版本管理）传入

```c
// ❌ 错误
#define API_KEY "sk-abc123xyz"

// ✅ 正确
const char *api_key = getenv("API_KEY");
```

## 输入校验

- 所有来自**系统边界**的数据（用户输入、串口/网络报文、文件内容）必须校验后再使用
- 内部函数之间的调用信任调用方，不重复校验
- 禁止将外部输入直接拼入 shell 命令（命令注入）

```c
// ❌ 错误
snprintf(cmd, sizeof(cmd), "ls %s", user_input);
system(cmd);
```

## 日志与调试输出

- 日志中**禁止**输出密钥、完整密码、用户隐私数据
- 调试用的敏感打印在正式版本中须关闭或脱敏

## 依赖安全

- 不引入无来源、无维护的第三方库
- 记录依赖版本（`requirements.txt` / `CMakeLists.txt`），便于排查已知漏洞
