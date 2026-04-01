/*
 * 文件 : udp_worker.h
 * 描述 : UDP 数据收发工作线程
 * 版本 : v1.0
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/23   创建文件
 */

#ifndef UDP_WORKER_H
#define UDP_WORKER_H

#include <QThread>
#include <QUdpSocket>
#include <QByteArray>
#include <QHostAddress>

class UdpWorker : public QThread {
    Q_OBJECT
public:
    explicit UdpWorker(QObject *parent = nullptr);
    ~UdpWorker();

    // ---- 配置接口 ----//
    void set_remote(const QString &ip, quint16 port);

signals:
    void dataReceived(const QByteArray &data);  // 收到数据
    void errorOccurred(const QString &msg);     // 发生错误

public slots:
    void onStart();   // 启动工作线程
    void onStop();    // 停止工作线程
    void onSend(const QByteArray &data);  // 发送数据（跨线程调用）

protected:
    void run() override;  // 线程主函数

private slots:
    void onReadyRead();  // Socket 可读回调

private:
    // ---- 私有成员变量 ----//
    QUdpSocket   *m_socket;        // UDP Socket
    QHostAddress  m_remote_addr;   // 目标 IP 地址
    quint16       m_remote_port;   // 目标端口
    bool          m_is_running;    // 运行标志
};

#endif /* UDP_WORKER_H */
