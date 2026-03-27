/*
 * 文件 : waveform_widget.cpp
 * 描述 : 波形显示组件实现
 * 版本 : v1.0
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   dev      26/03/23   创建文件
 */

#include "waveform_widget.h"
#include <QPainter>
#include <QMouseEvent>

/**
 * @brief 构造函数，初始化默认参数
 * @param parent 父组件
 */
WaveformWidget::WaveformWidget(QWidget *parent)
    : QWidget(parent)
    , m_yMin(-1.0)
    , m_yMax(1.0)
    , m_waveColor(Qt::green)
    , m_cursorX(-1)
    , m_hasData(false)
{
    setMinimumSize(300, 200);
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    setMouseTracking(true);                 // 无需按键即可追踪鼠标
    setStyleSheet("background-color: #0d1117;");
}

WaveformWidget::~WaveformWidget() {}

/**
 * @brief 设置纵轴显示范围
 * @param min 最小值
 * @param max 最大值
 */
void WaveformWidget::setYRange(double min, double max)
{
    m_yMin = min;
    m_yMax = max;
    update();
}

/**
 * @brief 设置波形颜色
 * @param color 颜色
 */
void WaveformWidget::setColor(const QColor &color)
{
    m_waveColor = color;
    update();
}

/**
 * @brief 接收新采样数据并刷新显示（通过信号槽从工作线程调用）
 * @param samples 采样点数组
 */
void WaveformWidget::updateSamples(const QVector<double> &samples)
{
    m_samples = samples;
    m_hasData = !samples.isEmpty();
    update();
}

/**
 * @brief 清空波形显示
 */
void WaveformWidget::clearDisplay()
{
    m_samples.clear();
    m_hasData = false;
    update();
}

void WaveformWidget::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event)
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);

    painter.fillRect(rect(), QColor("#0d1117"));
    drawGrid(painter);
    if (m_hasData)
        drawWaveform(painter);
    if (m_cursorX >= 0)
        drawCursor(painter);
}

void WaveformWidget::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    update();
}

void WaveformWidget::mouseMoveEvent(QMouseEvent *event)
{
    m_cursorX = event->x();

    // 将像素坐标转换为数值，发出游标信号
    if (m_hasData && !m_samples.isEmpty()) {
        double ratio = static_cast<double>(m_cursorX) / width();
        int    idx   = static_cast<int>(ratio * (m_samples.size() - 1));
        idx = qBound(0, idx, m_samples.size() - 1);

        double timeMs = ratio * 1000.0;             // 假设 X 轴为 1000ms
        emit cursorMoved(timeMs, m_samples[idx]);
    }
    update();
}

void WaveformWidget::drawGrid(QPainter &painter)
{
    QPen gridPen(QColor("#2a2a3a"), 1, Qt::DotLine);
    painter.setPen(gridPen);

    // 水平网格线（5 条）
    for (int i = 1; i < 5; ++i) {
        int y = height() * i / 5;
        painter.drawLine(0, y, width(), y);
    }
    // 垂直网格线（5 条）
    for (int i = 1; i < 5; ++i) {
        int x = width() * i / 5;
        painter.drawLine(x, 0, x, height());
    }
}

void WaveformWidget::drawWaveform(QPainter &painter)
{
    if (m_samples.size() < 2) return;

    QPen wavePen(m_waveColor, 1.5);
    painter.setPen(wavePen);

    double yRange = m_yMax - m_yMin;
    if (qFuzzyIsNull(yRange)) return;

    QVector<QPointF> points;
    points.reserve(m_samples.size());

    for (int i = 0; i < m_samples.size(); ++i) {
        double x = static_cast<double>(i) / (m_samples.size() - 1) * width();
        double y = (1.0 - (m_samples[i] - m_yMin) / yRange) * height();
        points.append(QPointF(x, y));
    }
    painter.drawPolyline(points.data(), points.size());
}

void WaveformWidget::drawCursor(QPainter &painter)
{
    QPen cursorPen(QColor("#ffffff"), 1, Qt::DashLine);
    painter.setPen(cursorPen);
    painter.drawLine(m_cursorX, 0, m_cursorX, height());
}
