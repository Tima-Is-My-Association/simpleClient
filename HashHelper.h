#ifndef HASHHELPER_H
#define HASHHELPER_H

#include <QObject>
#include <QCryptographicHash>

class HashHelper : public QObject
{
  Q_OBJECT
public:
  Q_INVOKABLE QString hash(const QByteArray &h);
};

#endif // HASHHELPER_H
