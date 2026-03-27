---
name: gitignore
description: 生成或更新 .gitignore 文件，按分类追加条目。用法：/gitignore [section...] 可选分类：os vscode qt python vitis vivado matlab c claude。不带参数则追加所有常用分类。
argument-hint: [os] [vscode] [qt] [python] [vitis] [vivado] [matlab] [c] [claude]
allowed-tools: [Read, Write, Edit, Bash]
disable-model-invocation: true
---

# 生成 / 更新 .gitignore

参数：$ARGUMENTS

## 操作步骤

1. 解析参数，得到请求分类列表；若无参数，使用默认列表：`os vscode qt python vitis vivado matlab c claude`
2. 检查当前目录是否存在 `.gitignore`：
   - 存在 → 读取内容，记录已有分类（以 `# <分类名>` 识别；`claude` 分类额外识别 `# ==== Claude Code ====`）
   - 不存在 → 视为空文件
3. 对请求的每个分类，若 `.gitignore` 中**已存在**该分类节头，跳过；否则追加
4. 将需追加的分类内容写入文件末尾（已存在文件用 Edit 追加，不存在用 Write 新建）
5. 输出操作摘要：已追加哪些分类、跳过哪些分类

---

## 各分类内容

### os
```
# os
.DS_Store
Thumbs.db
desktop.ini
*~
```

### vscode
```
# vscode
.vscode/
.vs/
*.code-workspace
```

### qt
```
# qt
*.pro.user
*.pro.user.*
moc_*.cpp
moc_*.h
ui_*.h
qrc_*.cpp
*.qm
Makefile
Makefile.*
.qmake.stash
.qmake.cache
debug/
release/
build/
```

### python
```
# python
__pycache__/
*.py[cod]
*.pyo
*.pyd
*.egg
*.egg-info/
dist/
build/
.eggs/
*.whl
pip-log.txt
```

### vitis
```
# vitis
/debug
/release
.metadata/
.project
.cproject
*.launch
_ide/
RemoteSystemsTempFiles/
```

### vivado
```
# vivado
*.jou
*.log
*.str
.Xil/
*.runs/
*.cache/
*.hw/
*.ip_user_files/
*.sim/
*.gen/
*.srcs/
*.xpr
*.bit
*.bin
*.ltx
*.mmi
*.xsa
*.hdf
*.elf
```

### matlab
```
# matlab
*.asv
*.m~
octave-workspace
```

### c
```
# c
*.o
*.obj
*.a
*.lib
*.dll
*.exe
*.out
*.d
*.map
*.lst
```

### claude
```
# claude
.claude/settings*.json
.claude/cache/
.claude/backups/
.claude/debug/
.claude/plans/
# 注意：.claude/skills/ 不忽略，纳入版本管理
```

---

## 注意事项

- 识别已有分类时，仅匹配行内容为 `# <分类名>`（完全匹配，不区分大小写）；`claude` 分类额外匹配 `# ==== Claude Code ====`
- 追加时在文件末尾插入，分类之间保留一个空行
- 不修改已有分类中的任何条目
