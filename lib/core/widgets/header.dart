import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/features/auth/services/firebase_auth_service.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showLogoutButton;
  const Header({
    super.key,
    this.title,
    this.subtitle,
    this.showLogoutButton = false,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth!,
      height: SizeConfig.screenHeight! * 0.26,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF73B777), Color(0xFF9AD59E)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),

      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Tree Trunk Icon
          Positioned(
            top: -30,
            right: -160,
            child: Image.asset('assets/images/header_tree.png'),
          ),

          // Close Button
          if (context.canPop())
            Positioned(
              top: SizeConfig.defaultSize! * 3,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: SizeConfig.defaultSize! * 3.0,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),

          if (showLogoutButton)
            Positioned(
              top: SizeConfig.defaultSize! * 3,
              right: SizeConfig.defaultSize!,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: SizeConfig.defaultSize! * 3.0,
                ),
                onPressed: () async {
                  await FirebaseAuthService().signOut();
                  if (context.mounted) {
                    context.pushReplacementNamed(AppRoute.splash.name);
                  }
                },
              ),
            ),

          // Title Text
          Positioned(
            left: SizeConfig.defaultSize! * 2.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: SizeConfig.defaultSize! * 2.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                // Subtitle Text
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: SizeConfig.defaultSize! * 2.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
