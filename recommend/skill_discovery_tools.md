# AI 技能搜索与发现工具汇总（2026）

> 版本：v1.0　日期：2026/04/14

> 注：GitHub Copilot 官方没有内置 "Skill Finder/Find Skill" 技能。以下为 2026 年最新可靠的替代工具，均有 GitHub 仓库，可直接安装。

---

## 一、官方推荐（首选）

### 1. Suggest Awesome Copilot Skills

| 项目 | 内容 |
|------|------|
| 仓库 | [github/awesome-copilot](https://github.com/github/awesome-copilot/tree/main/skills/suggest-awesome-github-copilot-skills) |
| 安装 | `/add https://github.com/github/awesome-copilot.git#skills/suggest-awesome-github-copilot-skills` |
| 核心功能 | 自动分析项目上下文，从 244+ 个官方技能中推荐最适合的；可检测本地技能是否需要更新 |
| 调用示例 | `@suggest-awesome-github-copilot-skills 帮我推荐适合FPGA开发的技能` |

---

## 二、社区平台

### 2. Skills Hub（最大社区技能目录）

| 项目 | 内容 |
|------|------|
| 仓库 | [samueltauil/skills-hub](https://github.com/samueltauil/skills-hub) |
| 在线浏览 | https://skillshub.space |
| 安装方式 | `gh extension install samueltauil/skills-hub` |
| 核心功能 | 收录 11 个分类共 200+ 个经安全扫描的社区技能，支持关键词搜索、一键安装 |

常用命令：
```bash
gh skills-hub search fpga      # 搜索技能
gh skills-hub install verilog-helper  # 安装技能
```

---

## 三、高质量技能仓库

### 3. Awesome Copilot（官方最大技能集合）

| 项目 | 内容 |
|------|------|
| 仓库 | [github/awesome-copilot](https://github.com/github/awesome-copilot) |
| 安装 | `/add https://github.com/github/awesome-copilot.git` |
| 内容 | 244 个官方验证技能，覆盖编程、文档、DevOps 等全场景 |

### 4. Thomas' Copilot Agent Skills（更新频繁）

| 项目 | 内容 |
|------|------|
| 仓库 | [thomast1906/github-copilot-agent-skills](https://github.com/thomast1906/github-copilot-agent-skills) |
| 安装 | `/add https://github.com/thomast1906/github-copilot-agent-skills.git` |
| 亮点 | 云服务、架构设计相关技能丰富，2026/04/01 刚更新 |

### 5. Pythonborg Claude-Skills（跨平台）

| 项目 | 内容 |
|------|------|
| 仓库 | [pythonborg/Claude-Skills](https://github.com/pythonborg/Claude-Skills) |
| 安装 | `/add https://github.com/pythonborg/Claude-Skills.git` |
| 亮点 | 204 个技能，同时兼容 Claude Code 和 GitHub Copilot，含 FPGA / 嵌入式分类 |

---

## 四、其他技能正确仓库

| 原技能名 | 正确仓库 | 安装命令 |
|----------|----------|----------|
| Auto Loop（原 Ralph Loop） | [glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done) | `/add https://github.com/glittercowboy/get-shit-done.git` |
| Long Term Memory | [anthropics/skills/memory](https://github.com/anthropics/skills/tree/main/memory) | `/add https://github.com/anthropics/skills.git#memory` |
| Browser Agent | [browser-use/copilot-browser](https://github.com/browser-use/copilot-browser) | `/add https://github.com/browser-use/copilot-browser.git` |

---

## 五、使用技巧

| 操作 | 命令 |
|------|------|
| 查看已安装技能 | `/skills` |
| 搜索本地技能 | 输入 `/` 后输入关键词，自动匹配 |
| 更新所有技能 | `/update skills` |
| 手动安装单个技能 | `/add https://github.com/用户名/仓库名.git#技能文件夹路径` |
