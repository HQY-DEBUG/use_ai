---
name: qt-new-class
description: 新建 Qt C++ 类文件，自动生成符合项目规范的文件头、Q_OBJECT、信号槽声明和线程安全框架。用法：/qt-new-class <类名> [用途描述]
argument-hint: <类名（大驼峰）> [用途描述]
allowed-tools: [Read, Write, Bash]
disable-model-invocation: true
---

# 新建 Qt C++ 类

参数：$ARGUMENTS

## 操作步骤

1. 从参数解析**类名**（大驼峰，如 `UdpWorker`）和**用途描述**
2. 派生文件名：类名转小写下划线，如 `UdpWorker` → `udp_worker`
3. 根据用途判断基类：
   - 含 `worker`、`线程`、`thread`、`网络`、`IO` → 继承 `QThread`
   - 含 `widget`、`界面`、`窗口`、`dialog` → 继承 `QWidget`
   - 否则 → 继承 `QObject`
4. 替换占位符后生成 `.h` 和 `.cpp`：
   - `CLASS_NAME` → 类名（大驼峰）
   - `FILE_NAME` → 文件名（小写下划线）
   - `GUARD_NAME` → 全大写下划线（include guard）
   - `BASE_CLASS` → 基类名
   - `CLASS_DESC` → 用途描述
   - `TODAY` → 今天日期（YYYY-MM-DD）
   - `TODAY_SHORT` → 今天日期（YY/MM/DD）

## 头文件模板（.h）

```cpp
/*
 * 文件 : FILE_NAME.h
 * 描述 : CLASS_DESC
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#ifndef GUARD_NAME_H
#define GUARD_NAME_H

#include <BASE_CLASS_INCLUDE>

// ---- 信号槽声明 ----//

class CLASS_NAME : public BASE_CLASS {
    Q_OBJECT
public:
    explicit CLASS_NAME(QObject *parent = nullptr);
    ~CLASS_NAME();

signals:
    void dataReceived(const QByteArray &data);  // 数据接收完成（示例，按需修改）

public slots:
    void onStart();   // 启动槽（示例，按需修改）
    void onStop();    // 停止槽

private slots:
    void onDataReceived(const QByteArray &data);  // 内部数据处理槽

protected:
    void run() override;  // QThread 子类重写 run()（非 QThread 时删除）

private:
    // ---- 私有成员变量 ----//
    bool m_is_running;   // 运行标志
};

#endif /* GUARD_NAME_H */
```

## 源文件模板（.cpp）

```cpp
/*
 * 文件 : FILE_NAME.cpp
 * 描述 : CLASS_DESC
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#include "FILE_NAME.h"

// ---- 构造 / 析构 ----//

CLASS_NAME::CLASS_NAME(QObject *parent)
    : BASE_CLASS(parent), m_is_running(false) {
}

CLASS_NAME::~CLASS_NAME() {
    onStop();
}

// ---- 公共槽 ----//

void CLASS_NAME::onStart() {
    m_is_running = true;
    start();  // 启动线程（QThread 子类）
}

void CLASS_NAME::onStop() {
    m_is_running = false;
    quit();   // 请求退出事件循环
    wait();   // 等待线程结束
}

// ---- 线程主函数 ----//

void CLASS_NAME::run() {
    while (m_is_running) {
        // 在此处理耗时任务，禁止直接操作 UI 控件
        // 跨线程通信使用 emit 发送信号
    }
}

// ---- 私有槽 ----//

void CLASS_NAME::onDataReceived(const QByteArray &data) {
    emit dataReceived(data);
}
```

5. 生成文件后：
   - 告知用户文件路径和基类选择依据
   - 提示：非 `QThread` 子类删除 `run()` 相关代码
   - 提示：连接信号槽时使用 `Qt::QueuedConnection` 确保线程安全
   - 提醒执行 `git commit`
