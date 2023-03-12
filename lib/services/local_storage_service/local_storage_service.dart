import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:afkcredits/app/app.logger.dart';

class LocalStorageService {
  final log = getLogger("LocalStorageService");

  Future<void> saveJsonData(
      {required Map<String, dynamic> data, required String fileName}) async {
    final jsonString = jsonEncode(data);
    final file = await getLocalJsonFile(fileName: fileName);
    await file.writeAsString(jsonString);
  }

  Future<Map<String, dynamic>> loadJsonData({required String fileName}) async {
    final file = await getLocalJsonFile(fileName: fileName);
    final jsonString = await file.readAsString();
    return jsonDecode(jsonString);
  }

  Future<void> deleteJsonData({required String fileName}) async {
    final file = await getLocalJsonFile(fileName: fileName);
    await file.delete();
  }

  Future<File> getLocalJsonFile({required String fileName}) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }
}
