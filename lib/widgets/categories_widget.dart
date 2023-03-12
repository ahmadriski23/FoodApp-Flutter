import 'package:flutter/material.dart';
import 'package:new_app/inner_screen/category_screen.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {Key? key,
      required this.catText,
      required this.imgPath,
      required this.passedColor})
      : super(key: key);
  final String catText, imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    // Size size = MediaQuery.of(context).size;
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: catText);
      },
      child: Container(
        // height: _screenWidth * 0.6,
        decoration: BoxDecoration(
            color: passedColor,
            // .withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 15,
                  offset: Offset(5, 5)),
              BoxShadow(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  blurRadius: 15,
                  offset: Offset(-5, -5))
            ]
            // border: Border.all(
            //   color: passedColor.withOpacity(
            //     0.7,
            //   ),
            //   width: 2,
            // ),
            ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                height: _screenWidth * 0.3,
                width: _screenWidth * 0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: AssetImage(imgPath))),
              ),
              TextWidget(
                text: catText,
                color: color,
                textSize: 14,
                isTitle: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
