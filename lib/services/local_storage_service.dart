import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  final FlutterSecureStorage _secureStorage = locator<FlutterSecureStorage>();

  final log = getLogger("LocalStorageService");

  String authTokenDataKey = "authTokenData";

  Future saveToDisk({required String key, required dynamic value}) async {
    log.i('key: $key value: $value');
    await _secureStorage.write(key: key, value: value);
  }

  Future deleteFromDisk({required String key}) async {
    log.i('key: $key');
    await _secureStorage.delete(key: key);
  }

  Future getFromDisk({required String key}) async {
    var value = await _secureStorage.read(key: key);
    log.i('key: $key value: $value');
    return value;
  }
}
