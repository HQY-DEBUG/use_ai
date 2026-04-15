# GitHub Copilot 自定义指令

> **分层说明**：通用行为约束、编码规范、Git 规范、Conductor 工作流均由全局 `~/.copilot/copilot-instructions.md` 和 `~/.copilot/instructions/` 提供。本文件只覆盖项目特有配置。

---

## 仓库目录规范（项目特有）

本仓库（`use_ai`）为 AI 协作配置仓库，文件放置规则：

```
use_ai/
├── .github/
│   ├── copilot-instructions.md   # 项目级 Copilot 配置（本文件）
│   ├── instructions/             # VS Code Copilot 文件级规范（applyTo）
│   └── skills/                   # 项目级 skill（同时同步至 ~/.copilot/skills/）
├── rule/                         # 规范文档存档（不被 Copilot 直接加载）
│   ├── claude/                   # Claude 规范
│   └── copilot/                  # Copilot 规范
├── skills/                       # skill 归档（按语言分类，与 .github/skills/ 内容一致）
├── doc/                          # 外部工具参考文档
└── example/                      # skill 输出示例
```

- `skills/` 内容与 `.github/skills/` 保持同步
- 新增通用 skill 后，同步复制到 `~/.copilot/skills/` 使其全局生效
- 修改 `.github/instructions/` 后同步更新 `~/.copilot/instructions/`

