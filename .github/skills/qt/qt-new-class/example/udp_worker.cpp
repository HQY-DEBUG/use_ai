/*
 * 文件 : udp_worker.cpp
 * 描述 : UDP 数据收发工作线程实现
 * 版本 : v1.0
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/23   创建文件
 */

#include "udp_worker.h"
#include <QDebug>

// ---- 构造 / 析构 ----//

UdpWorker::UdpWorker(QObject *parent)
    : QThread(parent),
      m_socket(nullptr),
      m_remote_addr(QHostAddress::LocalHost),
      m_remote_port(0),
      m_is_running(false) {
}

UdpWorker::~UdpWorker() {
    onStop();
}

// ---- 配置接口 ----//

void UdpWorker::set_remote(const QString &ip, quint16 port) {
    m_remote_addr = QHostAddress(ip);
    m_remote_port = port;
}

// ---- 公共槽 ----//

void UdpWorker::onStart() {
    if (isRunning()) {
        return;
    }
    m_is_running = true;
    start();  // 启动 QThread，进入 run()
}

void UdpWorker::onStop() {
    m_is_running = false;
    quit();   // 请求退出事件循环
    wait();   // 等待线程安全结束
}

void UdpWorker::onSend(const QByteArray &data) {
    if (m_socket == nullptr || m_remote_port == 0) {
        emit errorOccurred("发送失败：Socket 未初始化或端口未配置");
        return;
    }
    // 2026-03-23 新增：在工作线程内发送，避免阻塞 GUI 线程
    qint64 sent = m_socket->writeDatagram(data, m_remote_addr, m_remote_port);
    if (sent < 0) {
        emit errorOccurred("UDP 发送错误：" + m_socket->errorString());
    }
}

// ---- 线程主函数 ----//

void UdpWorker::run() {
    // Socket 必须在线程内创建，属于该线程
    m_socket = new QUdpSocket();
    if (!m_socket->bind(QHostAddress::AnyIPv4, 0)) {
        emit errorOccurred("Socket 绑定失败：" + m_socket->errorString());
        delete m_socket;
        m_socket = nullptr;
        return;
    }

    // 跨线程信号槽：使用 Qt::DirectConnection（同线程内直接调用）
    connect(m_socket, &QUdpSocket::readyRead, this, &UdpWorker::onReadyRead, Qt::DirectConnection);

    exec();  // 启动事件循环，等待 quit() 信号

    // ---- 清理资源 ----//
    m_socket->close();
    delete m_socket;
    m_socket = nullptr;
}

// ---- 私有槽 ----//

void UdpWorker::onReadyRead() {
    while (m_socket->hasPendingDatagrams()) {
        QByteArray buf;
        buf.resize(static_cast<int>(m_socket->pendingDatagramSize()));
        m_socket->readDatagram(buf.data(), buf.size());
        // 通过信号将数据传回 GUI 线程，禁止在此直接操作控件
        emit dataReceived(buf);
    }
}
