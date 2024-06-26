import 'package:flutter_application/router/router.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AppRouter>(AppRouter());
}
