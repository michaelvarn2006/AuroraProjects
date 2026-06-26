#include "imageprocessor.h"

ImageProcessor::ImageProcessor(ResultImageProvider *provider, QObject *parent)
    : QObject(parent), m_provider(provider)
{
    m_worker = new ProcessingWorker;
    m_worker->moveToThread(&m_thread);

    // Управление памятью воркера
    connect(&m_thread, &QThread::finished, m_worker, &QObject::deleteLater);

    // Сигналы для выполнения в фоне
    connect(this, &ImageProcessor::processRequested,
            m_worker, &ProcessingWorker::process);

    // Возврат результатов в главный поток
    connect(m_worker, &ProcessingWorker::finished,
            this, &ImageProcessor::handleFinished);

    m_thread.start();
}

ImageProcessor::~ImageProcessor()
{
    m_thread.quit();
    m_thread.wait(); // Обязательно ждем завершения потока
}

void ImageProcessor::process(const QString &filePath)
{
    if (m_busy) return; // Игнорируем повторные нажатия

    m_busy = true;
    emit busyChanged();

    emit processRequested(filePath);
}

void ImageProcessor::handleFinished(const QImage &result, qreal meanBrightness, int elapsedMs)
{
    m_provider->setImage(result);

    m_meanBrightness = meanBrightness;
    m_elapsedMs = elapsedMs;

    // Меняем суффикс, чтобы QML понял, что URL обновился
    m_version++;
    m_resultSource = QStringLiteral("image://result/processed/%1").arg(m_version);

    m_busy = false;

    emit meanBrightnessChanged();
    emit elapsedMsChanged();
    emit resultSourceChanged();
    emit busyChanged();
}
