---
name: c-struct
description: 生成符合项目规范的 C 结构体定义，含 Doxygen 注释和字段对齐。用法：/c-struct <结构体名> <字段列表>
argument-hint: <结构体名> <字段（类型:名称:说明 ...）>
allowed-tools: [Write, Read]
---

# 生成 C 结构体定义

参数：$ARGUMENTS

## 字段规格格式

每个字段使用空格分隔，单条格式：

```
<类型>:<字段名>:<说明>
```

示例：
```
/c-struct UdpPacket uint16_t:src_port:源端口 uint16_t:dst_port:目标端口 uint32_t:seq_num:序列号 uint8_t*:payload:数据载荷指针
```

## 操作步骤

1. 解析参数：提取结构体名和字段列表
2. 确定输出位置：
   - 若当前目录存在与结构体名相关的 `.h` 文件，提示追加到该文件
   - 否则直接输出代码块
3. 按下方格式生成结构体代码：
   - Doxygen `@brief` 注释块
   - 字段类型列、字段名列、分号、注释列纵向对齐
   - `typedef struct` 风格

## 输出格式

```c
/**
 * @brief  结构体说明
 */
typedef struct {
    uint16_t  src_port ;  // 源端口
    uint16_t  dst_port ;  // 目标端口
    uint32_t  seq_num  ;  // 序列号
    uint8_t  *payload  ;  // 数据载荷指针
} UdpPacket;
```

## 注意事项

- 字段类型、名称、注释三列纵向对齐
- 指针 `*` 紧贴字段名（`uint8_t *payload`），不紧贴类型
- 若字段涉及位域（`uint8_t flag : 1`），在说明中标注位宽
- 不自动创建新文件，仅输出代码块供用户粘贴
