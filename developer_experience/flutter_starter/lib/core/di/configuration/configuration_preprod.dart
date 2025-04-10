import 'package:injectable/injectable.dart';

import '/injection.dart';
import 'configuration.dart';

@preprod
@Order(-1)
@Singleton(as: Configuration)
class ConfigurationDev implements Configuration {
  @override
  String get apiBaseUrl => "";
}