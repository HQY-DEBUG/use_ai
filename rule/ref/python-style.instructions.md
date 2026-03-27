---

description: "Python 代码风格规范：文件头、docstring、PyQt5 线程约定。当编写或修改 PC/ 目录下 Python 文件时使用。"
applyTo: "**/*.py"
---

# Python 代码风格规范

## 文件头模板

每个 `.py` 文件顶部须包含版本说明：

```python
"""
文件名.py  --  模块简要说明
版本    : vX.Y
日期    : YYYY/MM/DD

修改记录:
    vX.Y  新增/修复/调整 说明
"""
```

## 函数注释（docstring）

```python
def func_name(param1, param2):
    """
    函数简要说明。

    Args:
        param1: 参数1说明
        param2: 参数2说明

    Returns:
        返回值说明
    """
```

## 类注释

```python
class MyClass:
    """
    类的用途说明。

    Attributes:
        attr1: 属性1说明
    """
```

## 行内注释

- 注释使用**中文**
- 新增代码标注版本与日期：`# vX.Y YYYY/MM/DD 新增：说明`
- 私有成员用单下划线前缀：`_internal_var`

## PyQt5 线程约定

- **GUI 线程**（`MainWindow`）只做 UI 更新，不阻塞
- **UDP/工作线程**（`QThread` 子类）独立维护 socket 等资源
- 跨线程通信**只用 Qt 信号槽**，禁止从子线程直接操作控件
- 高吞吐场景：批量操作用 `deque`，日志用定时器批量刷入，状态标签限频 `setText()`
