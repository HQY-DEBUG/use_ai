/*
 * 文件 : UdpWorker.h
 * 描述 : UDP 通信工作线程（Qt QThread 子类）头文件
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef UDPWORKER_H
#define UDPWORKER_H

#include <QThread>
#include <QUdpSocket>
#include <QByteArray>
#include <QString>
#include <QHostAddress>

/**
 * @brief  UDP 通信工作线程
 *
 * 在独立线程中处理 UDP 数据收发，通过信号槽与 GUI 线程通信。
 * 禁止在槽函数中直接操作 UI 控件。
 */
class UdpWorker : public QThread
{
    Q_OBJECT

public:
    explicit UdpWorker(QObject *parent = nullptr);
    ~UdpWorker() override;

    // ---- 配置接口（启动前调用）----
    void setLocalPort(quint16 port);
    void setRemoteTarget(const QHostAddress &addr, quint16 port);

    // ---- 控制接口 ----
    void stop();

signals:
    void dataReceived(const QByteArray &data, const QHostAddress &sender, quint16 port);  // 收到 UDP 数据包
    void errorOccurred(const QString &msg);                                                // 发生错误
    void started_sig();                                                                    // 线程已启动并绑定成功
    void stopped_sig();                                                                    // 线程已停止

public slots:
    void onSendData(const QByteArray &data);  // 发送数据（从 GUI 线程通过信号槽调用）

protected:
    void run() override;

private:
    QUdpSocket   *m_socket      ;  // UDP socket（在工作线程内创建）
    QHostAddress  m_remote_addr ;  // 目标 IP
    quint16       m_remote_port ;  // 目标端口
    quint16       m_local_port  ;  // 本地监听端口
    volatile bool m_running     ;  // 运行标志（线程安全读写）

private slots:
    void onReadyRead();  // socket 可读事件
};

#endif // UDPWORKER_H
