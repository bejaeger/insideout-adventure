import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalSecureStorageService {
  final FlutterSecureStorage _secureStorage = locator<FlutterSecureStorage>();
  final log = getLogger("LocalStorageService");

  String authTokenDataKey = "authTokenData";

  Future saveToDisk({required String key, required dynamic value}) async {
    log.v('key: $key value: $value');
    await _secureStorage.write(key: key, value: value);
  }

  Future saveRoleToDisk({required String key, required dynamic value}) async {
    log.v('key: $key value: $value');
    await _secureStorage.write(key: key, value: value);
  }

  Future deleteFromDisk({required String key}) async {
    log.v('key: $key');
    await _secureStorage.delete(key: key);
  }

  Future deleteRoleFromDisk({required String key}) async {
    log.v('key: $key');
    await _secureStorage.delete(key: key);
  }

  Future getFromDisk({required String key}) async {
    var value = await _secureStorage.read(key: key);
    log.v('key: $key value: $value');
    return value;
  }

  Future getRoleFromDisk({required String key}) async {
    var value = await _secureStorage.read(key: key);
    log.v('key: $key value: $value');
    return value;
  }
}
