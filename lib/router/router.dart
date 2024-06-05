import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/auth/auth.dart';
import 'package:flutter_application/auth/reset/view/enter_reset_code_screen.dart';
import 'package:flutter_application/auth/reset/view/reset_password_screen.dart';
import 'package:flutter_application/client/classes/AuthGuard.dart';
import 'package:flutter_application/client/pages/contacts/contacts.dart';
import 'package:flutter_application/client/pages/home/home.dart';
import 'package:flutter_application/client/pages/finances/finances.dart';
import 'package:flutter_application/client/pages/inquires/inquires.dart';
import 'package:flutter_application/client/pages/metters/metters.dart';
import 'package:flutter_application/client/pages/news/view/news_screen.dart';
import 'package:flutter_application/client/pages/profile/profile.dart';
import 'package:flutter_application/company/pages/appartaments/company_appartaments.dart';
import 'package:flutter_application/splash_screen.dart';
import 'package:flutter_application/widget/pages/chat/admin_chat.dart';
import 'package:flutter_application/company/pages/home/view/company_main_screen.dart';
import 'package:flutter_application/company/pages/articles/view/view.dart';
import 'package:flutter_application/company/pages/notifications/notifications.dart';
import 'package:flutter_application/company/pages/objects/view/object_single_screen.dart';
import 'package:flutter_application/company/pages/staff/view/staff_profile_screen.dart';
import 'package:flutter_application/company/pages/users/view/company_profile_screen.dart';
import 'package:flutter_application/company/pages/users_chat/view/view.dart';
import 'package:flutter_application/employee/pages/executors/view/executors_profile_screen.dart';
import 'package:flutter_application/employee/pages/home/view/view.dart';
import 'package:flutter_application/employee/pages/profile/view/employee_profile_screen.dart';
import 'package:flutter_application/employee/pages/tenant/tenant_profile.dart';
import 'package:flutter_application/widget/pages/development/development.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          path: '/clients/home',
        ),
        AutoRoute(
          page: DevelopmentRoute.page,
          path: '/development',
        ),
        AutoRoute(
            page: FinancesRoute.page,
            path: '/clients/finance',
            guards: [AuthGuard()]),
        AutoRoute(
            page: InquiresRoute.page,
            path: '/clients/inquires',
            guards: [AuthGuard()]),
        AutoRoute(
          page: AuthRoute.page,
          path: '/login',
          // initial: true,
        ),
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: SendResetEmailRoute.page,
          path: '/login/reset',
        ),
        AutoRoute(
          page: EnterResetCodeRoute.page,
          path: '/login/confirm/:email',
        ),
        AutoRoute(
            page: ProfileRoute.page,
            path: '/clients/profile',
            guards: [AuthGuard()]),
        AutoRoute(
            page: MettersRoute.page,
            path: '/clients/profile',
            guards: [AuthGuard()]),
        AutoRoute(
            page: ContactsRoute.page,
            path: '/clients/contacts',
            guards: [AuthGuard()]),
        AutoRoute(
            page: CompanyProfileRoute.page,
            path: '/company/profile',
            guards: [AuthGuard()]),
        AutoRoute(
          page: CompanyHomeMainRoute.page,
          path: '/company/home',
        ),
        AutoRoute(
          page: StaffProfileRoute.page,
          path: '/company/staff/:id',
        ),
        AutoRoute(
          page: ObjectSingleRoute.page,
          path: '/company/object/:id',
        ),
        AutoRoute(
          page: NewsRoute.page,
          path: '/news/:id',
        ),
        AutoRoute(
          page: NotificationsRoute.page,
          path: '/notifications',
        ),
        AutoRoute(
          page: AdminChatRoute.page,
          path: '/messages:id',
        ),
        AutoRoute(
          page: UsersChatRoute.page,
          path: '/admin-list-chat',
        ),
        AutoRoute(
          page: CompanyAppartamentsRoute.page,
          path: '/company/apartments/apartment_info/:id',
        ),
        AutoRoute(
            page: EmployProfileRoute.page,
            path: '/employee/profile',
            guards: [AuthGuard()]),
        AutoRoute(
            page: ExecutorsProfileRoute.page,
            path: '/employee/executors/:id',
            guards: [AuthGuard()]),
        AutoRoute(
            page: TenantProfileRoute.page,
            path: '/employee/tenants/:id',
            guards: [AuthGuard()]),
        AutoRoute(
          page: EmployeHomeMainRoute.page,
          path: '/employee/home',
        ),
      ];
}
