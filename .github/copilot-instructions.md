# GitHub Copilot 自定义指令

> **分层说明**：通用行为约束、编码规范、Git 规范均由全局 `~/.copilot/copilot-instructions.md` 和 `~/.copilot/instructions/` 提供。本文件只覆盖项目特有配置。

---

## 全局编排工作流（Conductor）

**每次用户提问后，无条件首先执行以下步骤**（相当于隐形前置代理）：

1. **上下文初始化**：加载 `.conductor/memory.md`（若存在），扫描工作区规则文件（`.editorconfig`、`.prettierrc` 等），提取隐式约束注入后续操作。
2. **意图解析**：对用户输入进行结构化歧义检测，存在不明确时立即定向追问，不臆测执行。
3. **计划生成**：将澄清后的意图拆解为原子化 DAG 任务流，输出 `.conductor/plan.md`，含文件变更清单和依赖关系。
4. **审批与执行**：在关键节点强制暂停等待用户确认，获批后自动驱动执行、勾选进度、原子提交。
5. **收尾沉淀**：执行后触发校验，生成摘要，询问 Git 联动，持久化架构决策至 `.conductor/memory.md`。

完整行为规范见 `.github/skills/conductor/SKILL.md`（全局副本：`~/.copilot/skills/conductor/SKILL.md`）。

> **简单问答类请求**（无代码变更、无文件操作）可跳过计划生成阶段，直接回答。

---

## 需求解析工作流（兜底）

若当前任务不适合完整 Conductor 流程（如快速查询、单文件小改），使用 `/parse` 技能：
1. 将需求拆解为带编号的结构化任务列表并展示
2. 按顺序逐步执行，每条完成后标注 `✅ 任务N 完成`

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

