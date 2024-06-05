// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AdminChatRoute.name: (routeData) {
      final args = routeData.argsAs<AdminChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AdminChatScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    ArticlesRoute.name: (routeData) {
      final args = routeData.argsAs<ArticlesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArticlesScreen(
          key: args.key,
          type: args.type,
        ),
      );
    },
    AuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthScreen(),
      );
    },
    CompanyAppartamentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CompanyAppartamentsRouteArgs>(
          orElse: () =>
              CompanyAppartamentsRouteArgs(id: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CompanyAppartamentsScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    CompanyHomeMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CompanyHomeMainScreen(),
      );
    },
    CompanyProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CompanyProfileScreen(),
      );
    },
    ContactsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ContactsScreen(),
      );
    },
    DevelopmentRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DevelopmentScreen(),
      );
    },
    EmployProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmployProfileScreen(),
      );
    },
    EmployeHomeMainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmployeHomeMainScreen(),
      );
    },
    EnterResetCodeRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EnterResetCodeRouteArgs>(
          orElse: () =>
              EnterResetCodeRouteArgs(email: pathParams.getString('email')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EnterResetCodeScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    ExecutorsProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ExecutorsProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ExecutorsProfileScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    FinancesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FinancesScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    InquiresRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InquiresScreen(),
      );
    },
    MettersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MettersScreen(),
      );
    },
    NewsRoute.name: (routeData) {
      final args = routeData.argsAs<NewsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NewsScreen(
          key: args.key,
          id: args.id,
          type: args.type,
        ),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsScreen(),
      );
    },
    ObjectSingleRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ObjectSingleRouteArgs>(
          orElse: () => ObjectSingleRouteArgs(id: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ObjectSingleScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    SendResetEmailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SendResetEmailScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SplashScreen(),
      );
    },
    StaffProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<StaffProfileRouteArgs>(
          orElse: () => StaffProfileRouteArgs(id: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StaffProfileScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    TenantProfileRoute.name: (routeData) {
      final args = routeData.argsAs<TenantProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TenantProfileScreen(
          key: args.key,
          id: args.id,
          apartmentsId: args.apartmentsId,
        ),
      );
    },
    UsersChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UsersChatScreen(),
      );
    },
  };
}

/// generated route for
/// [AdminChatScreen]
class AdminChatRoute extends PageRouteInfo<AdminChatRouteArgs> {
  AdminChatRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          AdminChatRoute.name,
          args: AdminChatRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'AdminChatRoute';

  static const PageInfo<AdminChatRouteArgs> page =
      PageInfo<AdminChatRouteArgs>(name);
}

class AdminChatRouteArgs {
  const AdminChatRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'AdminChatRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ArticlesScreen]
class ArticlesRoute extends PageRouteInfo<ArticlesRouteArgs> {
  ArticlesRoute({
    Key? key,
    required String type,
    List<PageRouteInfo>? children,
  }) : super(
          ArticlesRoute.name,
          args: ArticlesRouteArgs(
            key: key,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'ArticlesRoute';

  static const PageInfo<ArticlesRouteArgs> page =
      PageInfo<ArticlesRouteArgs>(name);
}

class ArticlesRouteArgs {
  const ArticlesRouteArgs({
    this.key,
    required this.type,
  });

  final Key? key;

  final String type;

  @override
  String toString() {
    return 'ArticlesRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CompanyAppartamentsScreen]
class CompanyAppartamentsRoute
    extends PageRouteInfo<CompanyAppartamentsRouteArgs> {
  CompanyAppartamentsRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          CompanyAppartamentsRoute.name,
          args: CompanyAppartamentsRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'CompanyAppartamentsRoute';

  static const PageInfo<CompanyAppartamentsRouteArgs> page =
      PageInfo<CompanyAppartamentsRouteArgs>(name);
}

class CompanyAppartamentsRouteArgs {
  const CompanyAppartamentsRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'CompanyAppartamentsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [CompanyHomeMainScreen]
class CompanyHomeMainRoute extends PageRouteInfo<void> {
  const CompanyHomeMainRoute({List<PageRouteInfo>? children})
      : super(
          CompanyHomeMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'CompanyHomeMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CompanyProfileScreen]
class CompanyProfileRoute extends PageRouteInfo<void> {
  const CompanyProfileRoute({List<PageRouteInfo>? children})
      : super(
          CompanyProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'CompanyProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ContactsScreen]
class ContactsRoute extends PageRouteInfo<void> {
  const ContactsRoute({List<PageRouteInfo>? children})
      : super(
          ContactsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DevelopmentScreen]
class DevelopmentRoute extends PageRouteInfo<void> {
  const DevelopmentRoute({List<PageRouteInfo>? children})
      : super(
          DevelopmentRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmployProfileScreen]
class EmployProfileRoute extends PageRouteInfo<void> {
  const EmployProfileRoute({List<PageRouteInfo>? children})
      : super(
          EmployProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmployProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmployeHomeMainScreen]
class EmployeHomeMainRoute extends PageRouteInfo<void> {
  const EmployeHomeMainRoute({List<PageRouteInfo>? children})
      : super(
          EmployeHomeMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmployeHomeMainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EnterResetCodeScreen]
class EnterResetCodeRoute extends PageRouteInfo<EnterResetCodeRouteArgs> {
  EnterResetCodeRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          EnterResetCodeRoute.name,
          args: EnterResetCodeRouteArgs(
            key: key,
            email: email,
          ),
          rawPathParams: {'email': email},
          initialChildren: children,
        );

  static const String name = 'EnterResetCodeRoute';

  static const PageInfo<EnterResetCodeRouteArgs> page =
      PageInfo<EnterResetCodeRouteArgs>(name);
}

class EnterResetCodeRouteArgs {
  const EnterResetCodeRouteArgs({
    this.key,
    required this.email,
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'EnterResetCodeRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [ExecutorsProfileScreen]
class ExecutorsProfileRoute extends PageRouteInfo<ExecutorsProfileRouteArgs> {
  ExecutorsProfileRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          ExecutorsProfileRoute.name,
          args: ExecutorsProfileRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'ExecutorsProfileRoute';

  static const PageInfo<ExecutorsProfileRouteArgs> page =
      PageInfo<ExecutorsProfileRouteArgs>(name);
}

class ExecutorsProfileRouteArgs {
  const ExecutorsProfileRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'ExecutorsProfileRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [FinancesScreen]
class FinancesRoute extends PageRouteInfo<void> {
  const FinancesRoute({List<PageRouteInfo>? children})
      : super(
          FinancesRoute.name,
          initialChildren: children,
        );

  static const String name = 'FinancesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InquiresScreen]
class InquiresRoute extends PageRouteInfo<void> {
  const InquiresRoute({List<PageRouteInfo>? children})
      : super(
          InquiresRoute.name,
          initialChildren: children,
        );

  static const String name = 'InquiresRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MettersScreen]
class MettersRoute extends PageRouteInfo<void> {
  const MettersRoute({List<PageRouteInfo>? children})
      : super(
          MettersRoute.name,
          initialChildren: children,
        );

  static const String name = 'MettersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewsScreen]
class NewsRoute extends PageRouteInfo<NewsRouteArgs> {
  NewsRoute({
    Key? key,
    required int id,
    String? type,
    List<PageRouteInfo>? children,
  }) : super(
          NewsRoute.name,
          args: NewsRouteArgs(
            key: key,
            id: id,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'NewsRoute';

  static const PageInfo<NewsRouteArgs> page = PageInfo<NewsRouteArgs>(name);
}

class NewsRouteArgs {
  const NewsRouteArgs({
    this.key,
    required this.id,
    this.type,
  });

  final Key? key;

  final int id;

  final String? type;

  @override
  String toString() {
    return 'NewsRouteArgs{key: $key, id: $id, type: $type}';
  }
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ObjectSingleScreen]
class ObjectSingleRoute extends PageRouteInfo<ObjectSingleRouteArgs> {
  ObjectSingleRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          ObjectSingleRoute.name,
          args: ObjectSingleRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ObjectSingleRoute';

  static const PageInfo<ObjectSingleRouteArgs> page =
      PageInfo<ObjectSingleRouteArgs>(name);
}

class ObjectSingleRouteArgs {
  const ObjectSingleRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'ObjectSingleRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SendResetEmailScreen]
class SendResetEmailRoute extends PageRouteInfo<void> {
  const SendResetEmailRoute({List<PageRouteInfo>? children})
      : super(
          SendResetEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'SendResetEmailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StaffProfileScreen]
class StaffProfileRoute extends PageRouteInfo<StaffProfileRouteArgs> {
  StaffProfileRoute({
    Key? key,
    required int id,
    List<PageRouteInfo>? children,
  }) : super(
          StaffProfileRoute.name,
          args: StaffProfileRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'StaffProfileRoute';

  static const PageInfo<StaffProfileRouteArgs> page =
      PageInfo<StaffProfileRouteArgs>(name);
}

class StaffProfileRouteArgs {
  const StaffProfileRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'StaffProfileRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [TenantProfileScreen]
class TenantProfileRoute extends PageRouteInfo<TenantProfileRouteArgs> {
  TenantProfileRoute({
    Key? key,
    required int id,
    required int apartmentsId,
    List<PageRouteInfo>? children,
  }) : super(
          TenantProfileRoute.name,
          args: TenantProfileRouteArgs(
            key: key,
            id: id,
            apartmentsId: apartmentsId,
          ),
          initialChildren: children,
        );

  static const String name = 'TenantProfileRoute';

  static const PageInfo<TenantProfileRouteArgs> page =
      PageInfo<TenantProfileRouteArgs>(name);
}

class TenantProfileRouteArgs {
  const TenantProfileRouteArgs({
    this.key,
    required this.id,
    required this.apartmentsId,
  });

  final Key? key;

  final int id;

  final int apartmentsId;

  @override
  String toString() {
    return 'TenantProfileRouteArgs{key: $key, id: $id, apartmentsId: $apartmentsId}';
  }
}

/// generated route for
/// [UsersChatScreen]
class UsersChatRoute extends PageRouteInfo<void> {
  const UsersChatRoute({List<PageRouteInfo>? children})
      : super(
          UsersChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'UsersChatRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
