import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    var isAuthorized = FirebaseAuth.instance.currentUser != null;
    if (isAuthorized) {
      resolver.next(true);
    } else {
      router.pushNamed('/login');
    }
  }
}
