import 'package:asrdb/data/drift/tables/downloads.dart';
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'downloads_dao.g.dart';

@DriftAccessor(tables: [Downloads])
class DownloadsDao extends DatabaseAccessor<AppDatabase>
    with _$DownloadsDaoMixin {
  DownloadsDao(AppDatabase db) : super(db);

  Future<List<Download>> getAllDownloads() {
    return select(downloads).get();
  }

  Future<int> insertDownload(DownloadsCompanion download) async {
    // This will insert a row and return its auto-incremented id
    final id = await into(downloads).insert(download);
    return id;
  }

  Future<void> deleteDownloads(Download download) async {
    await delete(downloads).delete(download);
  }

  Future<int> deleteDownloadById(int downloadId) async {
    return (delete(downloads)..where((t) => t.id.equals(downloadId))).go();
  }

  Future<bool> updateSyncStatus(int downloadId, bool syncSuccess) async {
    final updated = await (update(downloads)
          ..where((t) => t.id.equals(downloadId)))
        .write(DownloadsCompanion(
      lastSyncDate: Value(DateTime.now()),
      syncSuccess: Value(syncSuccess),
    ));

    return updated > 0; // Returns true if a row was updated
  }
}
