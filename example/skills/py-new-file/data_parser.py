"""
data_parser.py  --  数据帧解析模块
版本    : v1.0
日期    : 2026/05/26

修改记录:
    v1.0  创建文件，实现帧头校验、字段提取、CRC 校验
"""

import struct
import logging

log = logging.getLogger(__name__)

# ---- 协议常量 ----
FRAME_HEADER   = 0xAA55    # 帧头魔数
FRAME_MIN_LEN  = 8         # 最小帧长度（字节）：帧头2 + 类型1 + 长度1 + CRC2 + 帧尾2
FRAME_TAIL     = 0x55AA    # 帧尾魔数


class ParseError(Exception):
    """帧解析失败异常"""


def calc_crc16(data: bytes) -> int:
    """
    计算 CRC-16/MODBUS 校验值。

    Args:
        data: 待计算字节序列

    Returns:
        16 位 CRC 值
    """
    crc = 0xFFFF
    for byte in data:
        crc ^= byte
        for _ in range(8):
            if crc & 0x0001:
                crc = (crc >> 1) ^ 0xA001
            else:
                crc >>= 1
    return crc & 0xFFFF


def parse_frame(raw: bytes) -> dict:
    """
    解析一帧数据，返回字段字典。

    帧格式（小端）：
        [0:2]  帧头   0xAA55
        [2]    帧类型  uint8
        [3]    数据长度 uint8（payload 字节数）
        [4:-4] 数据域  payload
        [-4:-2] CRC16  覆盖 [0:-4]
        [-2:]  帧尾   0x55AA

    Args:
        raw: 原始字节数据

    Returns:
        解析结果字典：{'type': int, 'payload': bytes}

    Raises:
        ParseError: 帧格式不合法或 CRC 错误
    """
    if len(raw) < FRAME_MIN_LEN:
        raise ParseError(f"帧长度不足：{len(raw)} < {FRAME_MIN_LEN}")

    # 校验帧头
    header = struct.unpack_from('<H', raw, 0)[0]
    if header != FRAME_HEADER:
        raise ParseError(f"帧头错误：0x{header:04X}")

    # 读取帧类型与数据长度
    frame_type  = raw[2]
    payload_len = raw[3]

    expected_total = FRAME_MIN_LEN - 2 + payload_len  # 减去帧尾的2字节再加payload
    if len(raw) < expected_total:
        raise ParseError(f"帧长度与声明不符：实际 {len(raw)}, 期望 {expected_total}")

    # 提取 payload
    payload = raw[4 : 4 + payload_len]

    # 校验 CRC
    crc_calc  = calc_crc16(raw[:4 + payload_len])
    crc_recv  = struct.unpack_from('<H', raw, 4 + payload_len)[0]
    if crc_calc != crc_recv:
        raise ParseError(f"CRC 错误：计算 0x{crc_calc:04X}, 收到 0x{crc_recv:04X}")

    # 校验帧尾
    tail = struct.unpack_from('<H', raw, 4 + payload_len + 2)[0]
    if tail != FRAME_TAIL:
        raise ParseError(f"帧尾错误：0x{tail:04X}")

    return {'type': frame_type, 'payload': payload}


def build_frame(frame_type: int, payload: bytes) -> bytes:
    """
    构造一帧数据。

    Args:
        frame_type: 帧类型（0~255）
        payload:    数据域字节序列

    Returns:
        完整帧字节序列
    """
    if frame_type < 0 or frame_type > 0xFF:
        raise ValueError(f"frame_type 超出范围：{frame_type}")
    if len(payload) > 0xFF:
        raise ValueError(f"payload 过长：{len(payload)} > 255")

    header = struct.pack('<H', FRAME_HEADER)
    meta   = struct.pack('BB', frame_type, len(payload))
    body   = header + meta + payload
    crc    = struct.pack('<H', calc_crc16(body))
    tail   = struct.pack('<H', FRAME_TAIL)
    return body + crc + tail


if __name__ == '__main__':
    # 简单自测
    logging.basicConfig(level=logging.DEBUG)
    test_payload = b'\x01\x02\x03\x04'
    frame = build_frame(0x10, test_payload)
    log.debug("构造帧：%s", frame.hex())
    result = parse_frame(frame)
    log.debug("解析结果：type=0x%02X, payload=%s", result['type'], result['payload'].hex())
    assert result['payload'] == test_payload
    log.debug("自测通过")
