import 'package:envify/envify.dart';

part 'env.g.dart';

@Envify()
abstract class Env {
  static const appId = _Env.appId;
  static const apiKey = _Env.apiKey;
  static const projectId = _Env.projectId;
  static const databaseUrl = _Env.databaseUrl;
  static const databaseName = _Env.databaseName;
  static const messagingSenderId = _Env.messagingSenderId;
}
