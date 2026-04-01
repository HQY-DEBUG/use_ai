---
name: qt-new-widget
description: 生成 QWidget UI 组件类的 .h/.cpp 模板（纯 UI，不含耗时逻辑）。用法：/qt-new-widget <类名（大驼峰）> [描述]
argument-hint: <类名（大驼峰）> [描述]
allowed-tools: [Read, Write]
disable-model-invocation: true
---

# Qt QWidget UI 组件生成

目标：$ARGUMENTS

## 操作步骤

1. 解析类名（大驼峰，如 `WaveformWidget`）和描述
2. 生成 `<类名小写>.h` 和 `<类名小写>.cpp`（类名转小写下划线命名文件）
3. UI 组件职责：**只负责绘制和用户交互**，不做耗时计算，不直接访问硬件
4. 数据通过**信号槽**与外部交互（数据输入用 public slot，事件输出用 signal）
5. **不修改其他文件，不执行 git 提交**

## 生成模板

### 头文件 `<文件名>.h`

```cpp
/*
 * 文件 : <文件名>.h
 * 描述 : <描述>（UI 显示组件）
 * 版本 : v1.0
 * 日期 : YYYY-MM-DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   xxx      YY/MM/DD   创建文件
 */

#ifndef <类名大写>_H
#define <类名大写>_H

#include <QWidget>
#include <QPainter>
// 按需添加其他头文件

/**
 * @brief <描述>
 *
 * 职责：纯 UI 显示，不阻塞主线程。
 * 数据输入通过 updateData() 槽接收，
 * 用户操作通过信号向外通知。
 */
class <类名> : public QWidget {
    Q_OBJECT

public:
    explicit <类名>(QWidget *parent = nullptr);
    ~<类名>();

signals:
    // 用户操作事件（命名：动词过去式）
    void itemSelected(int index);   // 示例：用户选中某项
    void valueChanged(double val);  // 示例：用户调整数值

public slots:
    // 数据输入槽（命名：on + 信号名 或 update + 内容）
    void onDataReceived(const QByteArray &data);
    void updateDisplay(const QVector<double> &values);

protected:
    void paintEvent(QPaintEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;

private:
    void initUi();
    void drawBackground(QPainter &painter);
    void drawContent(QPainter &painter);

    // ---- 成员变量（m_ 前缀） ----//
    QVector<double>  m_data;         // 显示数据
    int              m_selectedIdx;  // 当前选中项
    bool             m_isUpdating;   // 是否正在更新
};

#endif // <类名大写>_H
```

### 源文件 `<文件名>.cpp`

```cpp
/*
 * 文件 : <文件名>.cpp
 * 描述 : <描述>（UI 显示组件实现）
 * 版本 : v1.0
 * 日期 : YYYY-MM-DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   xxx      YY/MM/DD   创建文件
 */

#include "<文件名>.h"
#include <QPainter>
#include <QMouseEvent>

/**
 * @brief 构造函数，初始化 UI 布局和默认状态
 * @param parent 父组件指针
 */
<类名>::<类名>(QWidget *parent)
    : QWidget(parent)
    , m_selectedIdx(-1)
    , m_isUpdating(false)
{
    initUi();
}

<类名>::~<类名>() {}

/**
 * @brief 初始化组件尺寸策略和背景色
 */
void <类名>::initUi()
{
    setMinimumSize(200, 150);
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    setStyleSheet("background-color: #1e1e1e;");
}

/**
 * @brief 接收外部数据并触发重绘（线程安全：通过信号槽调用）
 * @param data 原始字节数据
 */
void <类名>::onDataReceived(const QByteArray &data)
{
    // TODO：解析 data 填充 m_data
    Q_UNUSED(data)
    update();                           // 触发 paintEvent
}

/**
 * @brief 更新显示数值并重绘
 * @param values 数值列表
 */
void <类名>::updateDisplay(const QVector<double> &values)
{
    m_data = values;
    update();
}

void <类名>::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event)
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    drawBackground(painter);
    drawContent(painter);
}

void <类名>::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    update();
}

void <类名>::mousePressEvent(QMouseEvent *event)
{
    // TODO：根据点击坐标计算选中项，emit itemSelected(index)
    Q_UNUSED(event)
    QWidget::mousePressEvent(event);
}

void <类名>::drawBackground(QPainter &painter)
{
    painter.fillRect(rect(), QColor("#1e1e1e"));
}

void <类名>::drawContent(QPainter &painter)
{
    if (m_data.isEmpty()) return;
    // TODO：绘制 m_data 内容
    Q_UNUSED(painter)
}
```

## 注意事项

- `paintEvent` 内**禁止**耗时操作（网络、文件 IO、大量计算）
- 跨线程更新数据必须通过信号槽（`Qt::QueuedConnection`），不可直接调用槽函数
- `update()` 只是标记重绘请求，Qt 会在事件循环中合并多次调用
