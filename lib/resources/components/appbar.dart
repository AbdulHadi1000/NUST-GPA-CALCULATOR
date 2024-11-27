import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/resources/app_colors.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String appbarTitle;
  final bool showaActioButton;
  const Appbar(
      {super.key, required this.appbarTitle, required this.showaActioButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: AppColors.whitecolor,
      ),
      title: Text(
        appbarTitle,
        style: TextStyle(color: AppColors.whitecolor),
      ),
      backgroundColor: AppColors.appbarcolor,
      actions: showaActioButton
          ? [
              PopupMenuButton(
                iconSize: 30,
                iconColor: AppColors.whitecolor,
                popUpAnimationStyle: AnimationStyle(
                    duration: const Duration(seconds: 1),
                    reverseDuration: const Duration(seconds: 1),
                    curve: Curves.ease),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "About",
                              style: TextStyle(
                                  color: AppColors.blackcolor, fontSize: 30),
                            ),
                            content: Text(
                              "Developed by Abdul Hadi-42-EE",
                              style: TextStyle(
                                  color: AppColors.blackcolor, fontSize: 25),
                            ),
                          ),
                        );
                      },
                      value: "about",
                      child: Text(
                        "About",
                        style: TextStyle(
                            color: AppColors.blackcolor, fontSize: 15),
                      ),
                    )
                  ];
                },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
