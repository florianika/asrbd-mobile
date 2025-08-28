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

  Future<int> insertDownload() async {
    // This will insert a row and return its auto-incremented id
    final id = await into(downloads).insert(
      DownloadsCompanion.insert(),
    );
    return id;
  }

  Future<void> deleteDownloads(Download download) async {
    await delete(downloads).delete(download);
  }
}
