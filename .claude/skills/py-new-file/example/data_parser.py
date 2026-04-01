"""
data_parser.py  --  协议数据解析模块示例（由 /py-new-file 生成）
版本    : v1.0
日期    : 2026/03/27

修改记录:
    v1.0  创建文件
"""

import struct
import logging

log = logging.getLogger(__name__)

# ---- 常量定义 ----

FRAME_HEADER = 0xAA          # 帧头
FRAME_MIN_LEN = 6            # 最小帧长度（字节）


def init():
    """
    模块初始化。

    Returns:
        bool: 初始化成功返回 True
    """
    log.info("data_parser 初始化完成")
    return True


def parse_frame(data: bytes) -> dict | None:
    """
    解析一帧数据。

    Args:
        data: 原始字节数据（含帧头帧尾）

    Returns:
        解析结果字典，解析失败返回 None
        {
            'cmd':  int,   命令字
            'len':  int,   数据长度
            'payload': bytes  有效载荷
        }
    """
    if len(data) < FRAME_MIN_LEN:
        log.warning("帧长度不足：%d < %d", len(data), FRAME_MIN_LEN)
        return None

    if data[0] != FRAME_HEADER:
        log.warning("帧头错误：0x%02X", data[0])
        return None

    try:
        cmd, length = struct.unpack_from(">HH", data, 1)
        payload = data[5:5 + length]
    except struct.error as e:
        log.error("解析异常：%s", e)
        return None

    return {"cmd": cmd, "len": length, "payload": payload}


def poll():
    """
    模块轮询处理（主循环调用）。
    """
    pass
