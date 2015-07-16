#include "WebRequest.h"


WebRequest::WebRequest (QObject *parent) :
  QObject(parent),
  manager(new QNetworkAccessManager(this))
{
}


void WebRequest::sendRequest(const QString &url, const QByteArray &parameter)
{
  QNetworkRequest request = QNetworkRequest(QUrl(url));
  connect(this->manager, &QNetworkAccessManager::sslErrors, this, &WebRequest::ignoreSSL);
  connect(this->manager, &QNetworkAccessManager::finished, this, &WebRequest::replyFinished);
  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
  request.setHeader(QNetworkRequest::ContentLengthHeader, parameter.length());
  manager->post(request, parameter);
}

void WebRequest::replyFinished(QNetworkReply* reply)
{
  if (reply->error())
  {
    this->error(reply->error(), reply->errorString());
    return;
  }
  QByteArray arr = reply->readAll();
  if (arr.isEmpty())
    return;
  this->accepted(arr);
}

void WebRequest::ignoreSSL(QNetworkReply *reply, QList<QSslError> error)
{
  reply->ignoreSslErrors(error);
}
