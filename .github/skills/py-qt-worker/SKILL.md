---
name: py-qt-worker
description: 生成 PyQt5 QThread 工作线程模板（网络/串口/耗时任务）。用法：/py-qt-worker <类名> [描述]
argument-hint: <类名（大驼峰）> [描述，如 UDP接收线程]
allowed-tools: [Read, Write, Bash]
---

# 生成 PyQt5 工作线程模板

参数：$ARGUMENTS

## 参数格式

```
/py-qt-worker <类名> [描述]
```

示例：
```
/py-qt-worker UdpWorker UDP数据接收线程
/py-qt-worker SerialWorker 串口收发线程
/py-qt-worker DmaMonitor DMA状态监控线程
```

## 操作步骤

1. 解析参数：类名（大驼峰）和描述
2. 派生文件名：类名转小写下划线，如 `UdpWorker` → `udp_worker.py`
3. 根据描述关键词推断通信类型：
   - 含 `udp`、`网络`、`socket` → 生成 UDP socket 示例代码
   - 含 `serial`、`串口`、`uart` → 生成串口示例代码
   - 否则 → 生成通用耗时任务框架
4. 生成文件 `<文件名>.py`

---

## 通用工作线程模板

```python
"""
FILE_NAME.py  --  CLASS_DESC
版本    : v1.0
日期    : TODAY

修改记录:
    v1.0  创建文件
"""

from PyQt5.QtCore import QThread, pyqtSignal


class CLASS_NAME(QThread):
    """
    CLASS_DESC。

    职责：在独立线程中执行耗时操作，通过信号槽向 GUI 线程传递结果。
    禁止在此类中直接操作 UI 控件。

    Signals:
        data_received:  接收到数据时发出
        error_occurred: 发生错误时发出
        status_changed: 状态变化时发出
    """

    data_received  = pyqtSignal(bytes)   # 数据接收完成
    error_occurred = pyqtSignal(str)     # 错误描述
    status_changed = pyqtSignal(str)     # 状态变化描述

    def __init__(self, parent=None):
        super().__init__(parent)
        self._is_running = False
        # TODO: 添加资源成员变量（socket、串口句柄等）

    def run(self):
        """
        线程主函数，由 start() 自动调用。
        循环执行直到 stop() 被调用。
        """
        self._is_running = True
        self.status_changed.emit("已启动")

        while self._is_running:
            try:
                self._do_work()
            except Exception as e:
                self.error_occurred.emit(f"运行异常：{e}")
                break

        self._cleanup()
        self.status_changed.emit("已停止")

    def stop(self):
        """
        请求停止线程（线程安全）。
        调用后等待线程退出：worker.stop(); worker.wait()
        """
        self._is_running = False

    def _do_work(self):
        """
        单次工作单元（子类可重写）。
        耗时不超过 100ms，确保能响应 stop() 请求。
        """
        # TODO: 实现具体工作逻辑
        self.msleep(10)  # 防止 CPU 空转

    def _cleanup(self):
        """线程退出前释放资源（关闭 socket/串口等）。"""
        pass
```

---

## UDP 专项模板（检测到 udp/网络/socket 关键词时使用）

```python
"""
FILE_NAME.py  --  CLASS_DESC
版本    : v1.0
日期    : TODAY

修改记录:
    v1.0  创建文件
"""

import socket
from PyQt5.QtCore import QThread, pyqtSignal

UDP_BUF_SIZE = 4096   # UDP 接收缓冲区大小


class CLASS_NAME(QThread):
    """
    CLASS_DESC（UDP 接收线程）。

    Signals:
        data_received:  接收到 UDP 数据包时发出，携带原始字节
        error_occurred: 发生网络错误时发出
    """

    data_received  = pyqtSignal(bytes)
    error_occurred = pyqtSignal(str)

    def __init__(self, host: str = "0.0.0.0", port: int = 8888, parent=None):
        """
        初始化 UDP 接收线程。

        Args:
            host: 监听地址，默认所有网卡
            port: 监听端口
        """
        super().__init__(parent)
        self._host = host
        self._port = port
        self._is_running = False
        self._sock = None

    def run(self):
        """线程主函数：创建 socket 并循环接收数据。"""
        try:
            self._sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            self._sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self._sock.settimeout(0.5)   # 超时允许检查 _is_running
            self._sock.bind((self._host, self._port))
        except OSError as e:
            self.error_occurred.emit(f"socket 创建失败：{e}")
            return

        self._is_running = True
        while self._is_running:
            try:
                data, _ = self._sock.recvfrom(UDP_BUF_SIZE)
                if data:
                    self.data_received.emit(data)
            except socket.timeout:
                continue
            except OSError as e:
                if self._is_running:
                    self.error_occurred.emit(f"接收异常：{e}")
                break

        self._cleanup()

    def send(self, data: bytes, host: str, port: int):
        """
        发送 UDP 数据（线程安全：可从外部调用）。

        Args:
            data: 待发送字节数据
            host: 目标 IP
            port: 目标端口
        """
        if self._sock is None:
            return
        try:
            self._sock.sendto(data, (host, port))
        except OSError as e:
            self.error_occurred.emit(f"发送失败：{e}")

    def stop(self):
        """请求停止接收线程。"""
        self._is_running = False

    def _cleanup(self):
        """关闭 socket。"""
        if self._sock:
            self._sock.close()
            self._sock = None
```

---

## 使用示例（在 MainWindow 中连接）

```python
# 在 MainWindow.__init__ 中：
self._worker = CLASS_NAME(host="0.0.0.0", port=8888)
self._worker.data_received.connect(self.on_data_received)
self._worker.error_occurred.connect(lambda msg: self.statusBar().showMessage(msg))
self._worker.start()

# 在 MainWindow.closeEvent 中：
self._worker.stop()
self._worker.wait()
```

## 注意事项

- `run()` 内**禁止**直接调用 `setText()`、`append()` 等 UI 操作
- 所有跨线程数据传递通过 `pyqtSignal` 发出，Qt 自动处理线程安全
- `stop()` 只设置标志，需配合 `wait()` 确保线程完全退出
- `_sock.settimeout(0.5)` 保证 `stop()` 后最多 0.5s 退出循环
