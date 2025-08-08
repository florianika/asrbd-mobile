import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/domain/repositories/download_repository.dart';

class DownloadRepository implements IDownloadRepository {
  final DatabaseService _dao;

  DownloadRepository(this._dao);

  @override
  Future<void> deleteDownloads(Download download) async {
    await _dao.downloadDao.deleteDownloads(download);
  }

  @override
  Future<List<Download>> getAllDownloads() async {
    return await _dao.downloadDao.getAllDownloads();
  }

  @override
  Future<Download> insertDownload() async {
    return await _dao.downloadDao.insertDownload();
  }
}
