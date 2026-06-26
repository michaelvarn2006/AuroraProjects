#include "processingworker.h"
#include <QElapsedTimer>
#include <QDebug>

void ProcessingWorker::process(const QString &filePath)
{
    QElapsedTimer timer;
    timer.start();

    QImage image;
    // Загрузка из локального пути
    if (!image.load(filePath)) {
        qWarning() << "Failed to load image:" << filePath;
        emit finished(QImage(), 0.0, timer.elapsed());
        return;
    }

    // Перевод в градации серого
    QImage gray = image.convertToFormat(QImage::Format_Grayscale8);

    // Подсчет средней яркости
    qint64 sum = 0;
    for (int y = 0; y < gray.height(); ++y) {
        const uchar *line = gray.constScanLine(y);
        for (int x = 0; x < gray.width(); ++x) {
            sum += line[x];
        }
    }

    qreal meanBrightness = qreal(sum) / (qreal(gray.width()) * gray.height());

    emit finished(gray, meanBrightness, timer.elapsed());
}
