#ifndef WEBREQUEST_H
#define WEBREQUEST_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>

class WebRequest : public QObject
{
  Q_OBJECT
public:
  explicit WebRequest (QObject *parent = 0);
  Q_INVOKABLE void sendRequest(const QString &url, const QByteArray &parameter);
signals:
  void accepted(const QString &message);
  void error(const int &errorNumber, const QString &errorMessage);
private slots:
  void replyFinished(QNetworkReply*);
  void ignoreSSL(QNetworkReply *reply, QList<QSslError> error);
private:
  QNetworkAccessManager *manager;
};

#endif // WEBREQUEST_H
