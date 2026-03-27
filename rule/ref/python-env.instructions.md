---

description: "Python 环境配置规范：不使用虚拟环境，直接使用系统全局 Python。当涉及 PC/ 目录下 Python 代码运行、依赖安装、pip 操作时使用。"
applyTo: "**/*.py"
---

# Python 环境规范

## 不使用虚拟环境

本项目 Python 代码直接使用系统全局 Python 环境，**不创建、不激活任何虚拟环境**。

- 不使用 `venv`、`virtualenv`、`conda env`、`pipenv` 等工具创建隔离环境
- 安装依赖使用系统级 pip：`pip install <package>`
- 运行脚本直接使用系统 Python：`python script.py`

## 依赖管理

如需记录依赖，使用项目根目录的 `requirements.txt`，但安装时直接安装到系统环境：

```sh
pip install -r requirements.txt
```
