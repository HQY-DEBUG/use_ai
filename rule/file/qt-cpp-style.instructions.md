---

description: "Qt C++ 特定规范：信号槽声明、线程安全、QObject 继承约定、资源管理。当编写或修改 qt/ 目录下 .cpp/.h 文件时使用。"
applyTo: "qt/**/*.cpp,qt/**/*.h"
---

# Qt C++ 代码规范

> 本规则是 `c-cpp-style` 的补充，适用于 Qt 代码。

## 线程安全

- `QWidget` / `QMainWindow` 只做 UI 更新，不阻塞
- 耗时操作（网络、IO）放入 `QThread` 子类
- 跨线程通信**只用 Qt 信号槽**（`Qt::QueuedConnection`），**禁止**从子线程直接操作控件

```cpp
// ❌ 错误：从子线程直接操作 UI
m_label->setText("done");

// ✅ 正确：通过信号槽传递到 GUI 线程
emit statusUpdated("done");
```

## 信号槽声明

```cpp
signals:
    void dataReceived(const QByteArray &data);   // 信号：动词过去式
    void errorOccurred(const QString &msg);

private slots:
    void onDataReceived(const QByteArray &data); // 槽：on + 信号名
    void onErrorOccurred(const QString &msg);
```

## QObject 继承

- 继承 `QObject` 的类第一行必须包含 `Q_OBJECT` 宏
- 构造函数接受 `QObject *parent = nullptr`（不是 `QWidget *`）并传给基类

```cpp
// ✅ 正确
class Worker : public QThread {
    Q_OBJECT
public:
    explicit Worker(QObject *parent = nullptr);
};

// ❌ 错误（缺 Q_OBJECT；parent 类型错误）
class Worker : public QThread {
public:
    explicit Worker(QWidget *parent = nullptr);
};
```

## 资源管理

- 优先使用 Qt 父子对象树管理生命周期，减少手动 `delete`
- `QThread` 停止时调用 `quit()` + `wait()`，**禁止**直接 `terminate()`

```cpp
// ✅ 正确
m_worker->quit();
m_worker->wait();

// ❌ 错误（强制终止，可能导致资源泄漏）
m_worker->terminate();
```

## 命名补充

| 类型    | 规则          | 示例               |
|-------|-------------|------------------|
| 信号名   | 动词过去式或名词    | `dataReceived`   |
| 槽名    | `on` + 信号名  | `onDataReceived` |
| UI 成员 | `m_` 前缀     | `m_btnSend`      |
