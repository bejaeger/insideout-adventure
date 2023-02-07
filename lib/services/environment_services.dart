import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Returns values from the environment read from the .env file

class EnvironmentService {
  final log = getLogger('EnvironmentService');

  Future initialise() async {
    log.i('Load environment');

    await dotenv.load(fileName: ".env");

    log.v('Environement loaded');
  }

  String getValue(String key, {bool verbose = false}) {
    final value = dotenv.env[key] ?? NoKey;
    if (verbose) log.v('key:$key value:$value');
    return value;
  }
}
