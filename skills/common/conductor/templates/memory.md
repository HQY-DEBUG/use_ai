# Conductor 架构记忆

> 最后更新：{{DATE}}
> 项目：{{PROJECT_NAME}}

---

## 架构决策记录（ADR）

| 日期 | 决策 | 原因 | 影响范围 |
|------|------|------|---------|
| {{DATE}} | {{DECISION}} | {{REASON}} | {{SCOPE}} |

<!-- 示例：
| 2026/04/15 | 使用 PyQt5 而非 PyQt6 | 现有代码基于 PyQt5 | PC/py_code/ |
| 2026/04/15 | 缩进：4空格 | .editorconfig 规定 | 全局 |
-->

---

## 技术栈约定

<!-- 由 Conductor 阶段0 扫描后填充，后续任务自动继承 -->
- 主语言：{{LANG}}
- 框架：{{FRAMEWORK}}
- 测试框架：{{TEST_FRAMEWORK}}
- 包管理器：{{PKG_MANAGER}}

---

## 代码风格约定（来自规则文件扫描）

<!-- 来源：.editorconfig / .prettierrc / pyproject.toml 等 -->
| 约束项 | 值 | 来源文件 |
|--------|---|---------|
| 缩进字符 | {{INDENT_CHAR}} | {{SOURCE}} |
| 缩进宽度 | {{INDENT_SIZE}} | {{SOURCE}} |
| 引号风格 | {{QUOTE}} | {{SOURCE}} |
| 行尾符 | {{EOL}} | {{SOURCE}} |

---

## 命名约定（用户修正历史）

<!-- 由 Conductor 阶段5.1 规则沉淀时追加 -->
| 约束 | 触发次数 | 写入规则文件 |
|------|---------|------------|
| {{NAMING_RULE}} | {{COUNT}} | {{WRITTEN}} |

---

## 已澄清的歧义

<!-- 防止跨会话重复追问 -->
| 歧义项 | 用户答复 | 日期 |
|--------|---------|------|
| {{AMBIGUITY}} | {{ANSWER}} | {{DATE}} |

---

## 最近任务摘要（最近3次）

### {{DATE_1}}  —  {{TASK_1}}
- 完成：N 项，失败：M 项
- 关键产出：{{OUTPUT}}
- Commits：{{COMMITS}}

<!-- 保留最近3次，更早的删除 -->
