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
    AuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthScreen(),
      );
    },
    ClientNoteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClientNoteScreen(),
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
  };
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
/// [ClientNoteScreen]
class ClientNoteRoute extends PageRouteInfo<void> {
  const ClientNoteRoute({List<PageRouteInfo>? children})
      : super(
          ClientNoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientNoteRoute';

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
