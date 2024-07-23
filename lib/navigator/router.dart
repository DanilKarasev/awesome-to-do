import 'package:auto_route/auto_route.dart';
import 'package:awesome_to_do/navigator/guards/auth_guard.dart';

import '../presentation/pages/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          page: HomeRoute.page,
          guards: [AuthGuard()],
          children: [],
        ),
      ];
}
