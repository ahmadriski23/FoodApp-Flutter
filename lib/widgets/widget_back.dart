import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:new_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class WidgetButtonBack extends StatelessWidget {
  const WidgetButtonBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  width: 1.5, color: isDark ? Colors.white : Colors.black)),
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
          ),
        ),
      ),
    );
  }
}
