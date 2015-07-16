#include <QApplication>
#include <QtQuick>
#include <QQmlApplicationEngine>
#include "HashHelper.h"
#include "WebRequest.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<HashHelper>("TIMA.Helper", 1, 0, "HashHelper");
    qmlRegisterType<WebRequest>("TIMA.Helper", 1, 0, "WebRequest");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
