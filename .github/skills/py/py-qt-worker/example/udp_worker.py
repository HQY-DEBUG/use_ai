"""
udp_worker.py  --  UDP 数据接收线程示例（由 /py-qt-worker 生成）
版本    : v1.0
日期    : 2026/03/27

修改记录:
    v1.0  创建文件
"""

import socket
from PyQt5.QtCore import QThread, pyqtSignal

UDP_BUF_SIZE = 4096   # UDP 接收缓冲区大小


class UdpWorker(QThread):
    """
    UDP 数据接收线程。

    职责：在独立线程中监听 UDP 端口，接收到数据后通过信号传递给 GUI 线程。
    禁止在此类中直接操作 UI 控件。

    Signals:
        data_received:  接收到数据包时发出，携带原始字节
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
            self._sock.settimeout(0.5)
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
        发送 UDP 数据（可从主线程调用）。

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
