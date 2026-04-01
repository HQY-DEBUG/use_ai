/*
 * 文件 : StatusPanel.h
 * 描述 : 状态显示面板 QWidget 组件头文件
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef STATUSPANEL_H
#define STATUSPANEL_H

#include <QWidget>
#include <QString>
#include <QColor>

/**
 * @brief  连接状态枚举
 */
enum class ConnStatus {
    Disconnected,  // 未连接（灰色）
    Connected,     // 已连接（绿色）
    Error          // 错误（红色）
};

/**
 * @brief  状态显示面板
 *
 * 纯 UI 组件，只负责显示，不含耗时逻辑。
 * 通过 updateDisplay() 槽接收外部数据并刷新界面。
 */
class StatusPanel : public QWidget
{
    Q_OBJECT

public:
    explicit StatusPanel(QWidget *parent = nullptr);
    ~StatusPanel() override = default;

public slots:
    void updateDisplay(const QString &text, ConnStatus status);  // 更新文本与状态颜色
    void clearDisplay();                                          // 清空显示

protected:
    void paintEvent(QPaintEvent *event)    override;
    void resizeEvent(QResizeEvent *event)  override;
    void mousePressEvent(QMouseEvent *event) override;

private:
    QString    m_text        ;  // 当前显示文本
    ConnStatus m_status      ;  // 当前连接状态
    QColor     m_status_color;  // 状态指示颜色
    bool       m_is_hovered  ;  // 鼠标悬停标志

    QColor statusToColor(ConnStatus status) const;
};

#endif // STATUSPANEL_H
