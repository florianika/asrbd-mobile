import 'package:asrdb/data/drift/app_database.dart';

abstract class IDownloadRepository {
  Future<List<Download>> getAllDownloads();

  Future<int> insertDownload();

  Future<void> deleteDownloads(Download download);
}
