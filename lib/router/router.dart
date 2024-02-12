import 'package:auto_route/auto_route.dart';
import 'package:flutter_application/client/pages/home/home.dart';
import 'package:flutter_application/client/pages/finances/finances.dart';
import 'package:flutter_application/client/pages/profile/profile.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/'),
        AutoRoute(page: FinancesRoute.page, path: '/finance'),
        AutoRoute(page: ProfileRoute.page, path: '/profile')
      ];
}
