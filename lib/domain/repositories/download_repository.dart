import 'package:asrdb/data/drift/app_database.dart';

abstract class IDownloadRepository {
  Future<List<Download>> getAllDownloads();

  Future<int> insertDownload(DownloadsCompanion download);

  Future<void> deleteDownloads(Download download);

  Future<int> deleteDownloadById(int downloadId);

  Future<bool> updateSyncStatus(int downloadId, bool isSyncSuccess);
}
