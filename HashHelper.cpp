#include "HashHelper.h"

QString HashHelper::hash(const QByteArray &h)
{
  return QCryptographicHash::hash(h, QCryptographicHash::Sha512).toHex();
}

