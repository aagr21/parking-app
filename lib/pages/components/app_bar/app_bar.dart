import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      leading: const IgnorePointer(),
      toolbarHeight: 60.0,
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 1, 136, 82),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
