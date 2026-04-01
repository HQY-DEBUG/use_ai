/*
 * 文件 : StatusPanel.cpp
 * 描述 : 状态显示面板 QWidget 组件实现
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#include "StatusPanel.h"
#include <QPainter>
#include <QPaintEvent>
#include <QResizeEvent>
#include <QMouseEvent>
#include <QFont>

StatusPanel::StatusPanel(QWidget *parent)
    : QWidget(parent)
    , m_text("未连接")
    , m_status(ConnStatus::Disconnected)
    , m_status_color(Qt::gray)
    , m_is_hovered(false)
{
    setMinimumSize(200, 60);
    setMouseTracking(true);
}

void StatusPanel::updateDisplay(const QString &text, ConnStatus status) {
    m_text         = text;
    m_status       = status;
    m_status_color = statusToColor(status);
    update();  // 触发重绘
}

void StatusPanel::clearDisplay() {
    m_text         = "";
    m_status       = ConnStatus::Disconnected;
    m_status_color = statusToColor(ConnStatus::Disconnected);
    update();
}

void StatusPanel::paintEvent(QPaintEvent *event) {
    Q_UNUSED(event)

    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);

    // 绘制背景
    QColor bg_color = m_is_hovered ? QColor(240, 240, 240) : QColor(255, 255, 255);
    painter.fillRect(rect(), bg_color);

    // 绘制边框
    painter.setPen(QPen(Qt::lightGray, 1));
    painter.drawRoundedRect(rect().adjusted(0, 0, -1, -1), 4, 4);

    // 绘制状态指示圆点（左侧）
    const int dot_r    = 8;
    const int dot_cx   = 20;
    const int dot_cy   = height() / 2;
    painter.setBrush(m_status_color);
    painter.setPen(Qt::NoPen);
    painter.drawEllipse(dot_cx - dot_r, dot_cy - dot_r, dot_r * 2, dot_r * 2);

    // 绘制文本
    QFont font = painter.font();
    font.setPixelSize(14);
    painter.setFont(font);
    painter.setPen(Qt::black);
    painter.drawText(QRect(dot_cx * 2, 0, width() - dot_cx * 2 - 8, height()),
                     Qt::AlignVCenter | Qt::AlignLeft, m_text);
}

void StatusPanel::resizeEvent(QResizeEvent *event) {
    QWidget::resizeEvent(event);
    update();
}

void StatusPanel::mousePressEvent(QMouseEvent *event) {
    Q_UNUSED(event)
    // 预留点击事件处理（如：点击展开详情）
}

QColor StatusPanel::statusToColor(ConnStatus status) const {
    switch (status) {
        case ConnStatus::Connected:    return QColor(0, 180, 0);    // 绿色
        case ConnStatus::Error:        return QColor(220, 50, 50);  // 红色
        case ConnStatus::Disconnected: // fall-through
        default:                       return Qt::gray;
    }
}
