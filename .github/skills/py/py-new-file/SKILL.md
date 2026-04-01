---
name: py-new-file
description: 新建符合项目规范的 Python 文件，自动生成文件头、模块 docstring 和函数框架。用法：/py-new-file <文件名（不含.py）> [模块描述]
argument-hint: <文件名> [模块描述]
allowed-tools: [Read, Write, Bash]
---

# 新建 Python 文件

参数：$ARGUMENTS

## 操作步骤

1. 解析参数：**文件名**（小写下划线，不含 `.py`）和**模块描述**
2. 根据文件名特征判断模板类型：
   - 含 `main`、`app`、`run` → **主程序模板**（含 `if __name__ == '__main__'`）
   - 含 `qt`、`widget`、`window`、`dialog`、`ui` → **PyQt5 主窗口模板**
   - 否则 → **通用模块模板**
3. 生成文件 `<文件名>.py`，替换占位符：
   - `FILE_NAME` → 文件名（含 `.py`）
   - `MODULE_DESC` → 模块描述
   - `TODAY` → 今天日期（`YYYY/MM/DD`）

---

## 通用模块模板

```python
"""
FILE_NAME  --  MODULE_DESC
版本    : v1.0
日期    : TODAY

修改记录:
    v1.0  创建文件
"""

# v1.0 TODAY 新增：模块初始化


def init():
    """
    模块初始化。

    Returns:
        bool: 初始化成功返回 True，失败返回 False
    """
    return True


def poll():
    """
    模块轮询处理（主循环调用）。
    """
    pass
```

---

## 主程序模板（含 `main`/`app`/`run`）

```python
"""
FILE_NAME  --  MODULE_DESC
版本    : v1.0
日期    : TODAY

修改记录:
    v1.0  创建文件
"""

import sys
import logging

# v1.0 TODAY 新增：日志配置
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
log = logging.getLogger(__name__)


def main():
    """
    程序入口。
    """
    log.info("程序启动")
    # TODO: 添加主逻辑


if __name__ == "__main__":
    sys.exit(main())
```

---

## PyQt5 主窗口模板（含 `qt`/`widget`/`window`/`ui`）

```python
"""
FILE_NAME  --  MODULE_DESC
版本    : v1.0
日期    : TODAY

修改记录:
    v1.0  创建文件
"""

import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget
from PyQt5.QtCore import Qt


class MainWindow(QMainWindow):
    """
    主窗口。

    Attributes:
        _is_connected: 设备连接状态标志
    """

    def __init__(self, parent=None):
        super().__init__(parent)
        self._is_connected = False
        self._init_ui()

    def _init_ui(self):
        """初始化 UI 布局。"""
        self.setWindowTitle("MODULE_DESC")
        self.resize(800, 600)
        # TODO: 添加控件布局

    # ---- 槽函数 ----

    def on_connect_clicked(self):
        """连接按钮点击槽。"""
        pass

    def on_data_received(self, data: bytes):
        """
        数据接收槽（由工作线程信号触发）。

        Args:
            data: 接收到的原始字节数据
        """
        pass

    def closeEvent(self, event):
        """窗口关闭时清理资源。"""
        # TODO: 停止工作线程
        event.accept()


def main():
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
```

---

## 生成后提示

- 告知生成文件路径和所用模板类型
- 提醒文件放入 `PC/py_code/` 目录
- 提示执行 `git commit`

## 参考示例

完整示例见 [example/data_parser.py](example/data_parser.py)
