import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final PageRouteInfo<dynamic> route;

  const ProfileAvatar({
    Key? key,
    required this.photoUrl,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        AutoRouter.of(context).push(route);
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
              photoUrl != null && photoUrl!.isNotEmpty ? 0.0 : 0.2),
          shape: BoxShape.circle,
          border: photoUrl != null && photoUrl!.isNotEmpty
              ? null
              : Border.all(
                  color: Colors.white,
                  width: 1,
                ),
        ),
        child: ClipOval(
          child: photoUrl != null && photoUrl!.isNotEmpty
              ? Image.network(
                  photoUrl!,
                  width: 34,
                  height: 34,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 34,
                      height: 34,
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(
                        'assets/img/user.png',
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                )
              : Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(7),
                  child: Image.asset(
                    'assets/img/user.png',
                    fit: BoxFit.contain,
                  ),
                ),
        ),
      ),
    );
  }
}
