import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/repositories/download_repository.dart';

class DownloadUsecases {
  final DownloadRepository _downloadRepository;

  DownloadUsecases(this._downloadRepository);

  Future<Download> insertDownload() async {
    return await _downloadRepository.insertDownload();
  }
}
