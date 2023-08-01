import 'package:flutter/material.dart';
import 'package:gogo_pharma/utils/color_palette.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key? key, this.backgroundColor}) : super(key: key);
 final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? ColorPalette.primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}