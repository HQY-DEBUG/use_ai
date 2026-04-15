# 会话摘要（上下文压缩快照）

> 压缩时间：{{DATE}} {{TIME}}
> 原始对话轮次：{{TURNS}}
> 压缩原因：对话 Token 量超过上下文上限 70%

---

## 当前任务状态

**需求摘要**：{{TASK_SUMMARY}}

**执行阶段**：{{CURRENT_PHASE}}（阶段0 / 1 / 2 / 3 / 4 / 5）

**plan.md 路径**：`.conductor/plan.md`（如存在）

---

## 已完成步骤

| 步骤 | 标题 | 状态 | Commit |
|------|------|------|--------|
| {{STEP_ID}} | {{STEP_TITLE}} | ✅ 已完成 | {{COMMIT_HASH}} |

---

## 待执行步骤

| 步骤 | 标题 | 依赖 |
|------|------|------|
| {{STEP_ID}} | {{STEP_TITLE}} | {{DEPENDS_ON}} |

---

## 关键架构决策（本次会话）

| 决策 | 原因 |
|------|------|
| {{DECISION}} | {{REASON}} |

---

## 生效约束快照

<!-- 从 workspace-rules.md 提取的关键约束 -->
{{CONSTRAINT_SNAPSHOT}}

---

## 待续跑指令

> 下次对话开始时，conductor 读取本文件后输出：
> "⚠️ 检测到上次会话未完成，从步骤 {{NEXT_STEP}} 续跑（共 {{TOTAL}} 步）"

恢复命令：继续执行 `.conductor/plan.md` 中状态为"待执行"的步骤。
