# 工作区规则汇总

> 工作区：{{WORKSPACE_NAME}}
> 创建时间：{{DATE}}
> 最后更新：{{DATE}}（由 conductor 自动维护，请勿手动编辑"来源文件"和"生效约束"两节）

---

## 来源文件

| 来源 | 状态 | 归纳约束摘要 |
|------|------|------------|
| `.editorconfig` | ❌ 未找到 | — |
| `.prettierrc` / `prettier.config.*` | ❌ 未找到 | — |
| `.eslintrc*` / `eslint.config.*` | ❌ 未找到 | — |
| `pyproject.toml` / `setup.cfg` | ❌ 未找到 | — |
| `.clang-format` | ❌ 未找到 | — |
| `tsconfig.json` | ❌ 未找到 | — |
| `.github/copilot-instructions.md` | ❌ 未找到 | — |
| `rule/**/*.md` | ❌ 未找到 | — |
| 全局 `~/.copilot/copilot-instructions.md` | ✅ 兜底 | 参见全局规范 |

---

## 生效约束（Conductor 在所有代码生成中强制遵守）

> 本节由 conductor 在每次阶段 0 时根据"来源文件"自动刷新。

- （首次运行后自动填充）

---

## 用户习惯记录（观察积累，永不自动清空）

> 本节只追加，不覆盖。conductor 在阶段 5.1 检测到用户修正行为时写入。
> 积累的习惯会在下次阶段 0 时合并到"生效约束"。

| 日期 | 观察到的习惯 | 状态 |
|------|------------|------|
| — | — | — |

---

## 同步到工作区指令文件记录

> 记录每次将"生效约束"写入 `.github/copilot-instructions.md` 的历史。

| 日期 | 同步内容摘要 | 操作人 |
|------|------------|--------|
| — | — | — |
