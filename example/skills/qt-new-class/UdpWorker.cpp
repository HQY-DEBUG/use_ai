/*
 * 文件 : UdpWorker.cpp
 * 描述 : UDP 通信工作线程实现
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#include "UdpWorker.h"
#include <QDebug>

UdpWorker::UdpWorker(QObject *parent)
    : QThread(parent)
    , m_socket(nullptr)
    , m_remote_addr(QHostAddress::LocalHost)
    , m_remote_port(0)
    , m_local_port(8888)
    , m_running(false)
{
}

UdpWorker::~UdpWorker() {
    stop();
    wait();
}

void UdpWorker::setLocalPort(quint16 port) {
    m_local_port = port;
}

void UdpWorker::setRemoteTarget(const QHostAddress &addr, quint16 port) {
    m_remote_addr = addr;
    m_remote_port = port;
}

void UdpWorker::stop() {
    m_running = false;
    // 唤醒事件循环使线程尽快退出
    if (m_socket != nullptr) {
        m_socket->close();
    }
}

void UdpWorker::run() {
    // 在工作线程内创建 socket，确保所有信号槽在同一线程执行
    m_socket = new QUdpSocket();

    if (!m_socket->bind(QHostAddress::AnyIPv4, m_local_port, QUdpSocket::ShareAddress)) {
        emit errorOccurred(QString("绑定端口 %1 失败：%2").arg(m_local_port).arg(m_socket->errorString()));
        delete m_socket;
        m_socket = nullptr;
        return;
    }

    // 连接可读信号到槽（同线程，直接连接）
    connect(m_socket, &QUdpSocket::readyRead, this, &UdpWorker::onReadyRead, Qt::DirectConnection);

    m_running = true;
    emit started_sig();
    qDebug() << "[UdpWorker] 线程启动，监听端口" << m_local_port;

    // 启动本线程的事件循环
    exec();

    // 事件循环退出后清理
    m_socket->close();
    delete m_socket;
    m_socket = nullptr;

    emit stopped_sig();
    qDebug() << "[UdpWorker] 线程已退出";
}

void UdpWorker::onReadyRead() {
    while (m_socket->hasPendingDatagrams()) {
        QByteArray  buf;
        QHostAddress sender;
        quint16      sender_port = 0;

        buf.resize(static_cast<int>(m_socket->pendingDatagramSize()));
        m_socket->readDatagram(buf.data(), buf.size(), &sender, &sender_port);

        emit dataReceived(buf, sender, sender_port);
    }
}

void UdpWorker::onSendData(const QByteArray &data) {
    if (m_socket == nullptr || m_remote_port == 0) {
        emit errorOccurred("发送失败：目标地址未配置");
        return;
    }
    qint64 sent = m_socket->writeDatagram(data, m_remote_addr, m_remote_port);
    if (sent != data.size()) {
        emit errorOccurred(QString("发送不完整：期望 %1 字节，实际 %2 字节").arg(data.size()).arg(sent));
    }
}
