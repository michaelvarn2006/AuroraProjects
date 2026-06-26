#include "notesmodel.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

NotesModel::NotesModel(QObject *parent) : QAbstractListModel(parent)
{
    loadNotes();
}

int NotesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_notes.count();
}

QVariant NotesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_notes.count() || index.row() < 0)
        return QVariant();

    const Note &note = m_notes[index.row()];
    if (role == TextRole) return note.text;
    if (role == CreatedAtRole) return QVariant(note.createdAt);

    return QVariant();
}

QHash<int, QByteArray> NotesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TextRole] = "text";
    roles[CreatedAtRole] = "createdAt";
    return roles;
}

void NotesModel::addNote(const QString &text)
{
    const QString trimmed = text.trimmed();
    if (trimmed.isEmpty()) return;

    beginInsertRows(QModelIndex(), 0, 0);
    m_notes.prepend({trimmed, QDateTime::currentDateTime()});
    endInsertRows();

    emit countChanged();
    saveNotes();
}

void NotesModel::removeNote(int row)
{
    if (row < 0 || row >= m_notes.count()) return;

    beginRemoveRows(QModelIndex(), row, row);
    m_notes.removeAt(row);
    endRemoveRows();

    emit countChanged();
    saveNotes();
}

QString NotesModel::getFilePath() const
{
    const QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dataDir);
    return dataDir + QStringLiteral("/notes.json");
}

void NotesModel::loadNotes()
{
    QFile file(getFilePath());
    if (!file.open(QIODevice::ReadOnly)) return;

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    QJsonArray arr = doc.array();

    beginResetModel();
    m_notes.clear();
    for (int i = 0; i < arr.size(); ++i) {
        QJsonObject obj = arr[i].toObject();
        Note note;
        note.text = obj["text"].toString();
        note.createdAt = QDateTime::fromString(obj["createdAt"].toString(), Qt::ISODate);
        m_notes.append(note);
    }
    endResetModel();
    emit countChanged();
}

void NotesModel::saveNotes() const
{
    QJsonArray arr;
    for (const Note &note : m_notes) {
        QJsonObject obj;
        obj.insert(QStringLiteral("text"), note.text);
        obj.insert(QStringLiteral("createdAt"), note.createdAt.toString(Qt::ISODate));
        arr.append(obj);
    }

    QFile file(getFilePath());
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(arr).toJson());
    }
}
