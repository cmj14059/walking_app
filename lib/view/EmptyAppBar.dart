import 'package:flutter/material.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
