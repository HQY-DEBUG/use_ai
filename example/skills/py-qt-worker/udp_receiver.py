"""
udp_receiver.py  --  UDP 数据接收工作线程（PyQt5 QThread）
版本    : v1.0
日期    : 2026/05/26

修改记录:
    v1.0  创建文件，实现 UDP 接收、数据信号发射、优雅停止
"""

import socket
import logging
from PyQt5.QtCore import QThread, pyqtSignal

log = logging.getLogger(__name__)

# ---- 配置常量 ----
UDP_RECV_BUF_SIZE = 4096    # 单次最大接收字节数
UDP_SOCKET_TIMEOUT = 0.5    # socket 超时（秒），用于检测停止标志


class UdpReceiver(QThread):
    """
    UDP 数据接收工作线程。

    在独立线程中持续接收 UDP 数据包，通过信号将数据传递到 GUI 线程。
    调用 stop() 后线程将在当前接收超时周期结束时退出。

    Attributes:
        _host:    绑定地址
        _port:    监听端口
        _running: 运行标志
        _sock:    UDP socket
    """

    # ---- 信号定义 ----
    data_received  = pyqtSignal(bytes)   # 收到数据包时发射，携带原始字节
    error_occurred = pyqtSignal(str)     # 发生错误时发射，携带错误描述

    def __init__(self, host: str = '0.0.0.0', port: int = 8888, parent=None):
        """
        初始化接收线程。

        Args:
            host:   绑定 IP 地址（默认监听所有接口）
            port:   监听端口号
            parent: Qt 父对象
        """
        super().__init__(parent)
        self._host    = host
        self._port    = port
        self._running = False
        self._sock    = None

    def run(self):
        """线程入口：创建 socket，循环接收数据，直至 stop() 被调用。"""
        try:
            self._sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            self._sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self._sock.settimeout(UDP_SOCKET_TIMEOUT)
            self._sock.bind((self._host, self._port))
        except OSError as e:
            log.error("UDP socket 创建失败：%s", e)
            self.error_occurred.emit(f"socket 创建失败：{e}")
            return

        self._running = True
        log.debug("UDP 接收线程启动，监听 %s:%d", self._host, self._port)

        while self._running:
            try:
                data, addr = self._sock.recvfrom(UDP_RECV_BUF_SIZE)
                log.debug("收到 %d 字节，来自 %s:%d", len(data), addr[0], addr[1])
                self.data_received.emit(data)
            except socket.timeout:
                # 超时属于正常，用于检查 _running 标志
                continue
            except OSError as e:
                if self._running:
                    log.error("接收异常：%s", e)
                    self.error_occurred.emit(f"接收异常：{e}")
                break

        self._cleanup()
        log.debug("UDP 接收线程退出")

    def stop(self):
        """请求停止接收线程（线程安全）。"""
        self._running = False

    def _cleanup(self):
        """释放 socket 资源。"""
        if self._sock is not None:
            try:
                self._sock.close()
            except OSError:
                pass
            self._sock = None
