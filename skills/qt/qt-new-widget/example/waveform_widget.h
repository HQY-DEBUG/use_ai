/*
 * 文件 : waveform_widget.h
 * 描述 : 波形显示组件，绘制实时采样数据曲线
 * 版本 : v1.0
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   dev      26/03/23   创建文件
 */

#ifndef WAVEFORM_WIDGET_H
#define WAVEFORM_WIDGET_H

#include <QWidget>
#include <QVector>
#include <QPen>

/**
 * @brief 波形显示组件
 *
 * 职责：将外部传入的采样点数组绘制为折线波形。
 * 数据通过 updateSamples() 槽写入，不阻塞 UI 线程。
 */
class WaveformWidget : public QWidget {
    Q_OBJECT

public:
    explicit WaveformWidget(QWidget *parent = nullptr);
    ~WaveformWidget();

    void setYRange(double min, double max);     // 设置纵轴显示范围
    void setColor(const QColor &color);         // 设置波形颜色

signals:
    void cursorMoved(double timeMs, double value); // 用户移动游标

public slots:
    void updateSamples(const QVector<double> &samples); // 接收新数据
    void clearDisplay();                                 // 清空波形

protected:
    void paintEvent(QPaintEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;

private:
    void drawGrid(QPainter &painter);
    void drawWaveform(QPainter &painter);
    void drawCursor(QPainter &painter);

    // ---- 成员变量 ----//
    QVector<double> m_samples;      // 采样点数据
    double          m_yMin;         // 纵轴最小值
    double          m_yMax;         // 纵轴最大值
    QColor          m_waveColor;    // 波形颜色
    int             m_cursorX;      // 游标 X 像素坐标（-1 表示隐藏）
    bool            m_hasData;      // 是否有有效数据
};

#endif // WAVEFORM_WIDGET_H
