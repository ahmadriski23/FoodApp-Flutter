import 'package:flutter/material.dart';
import 'package:new_app/widgets/categories_widget.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';
import '../services/utils.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);
  // List<Color> gridColors = [
  //   Colors.white,
  //   Colors.lightBlueAccent,
  //   Colors.green,
  //   Colors.blueGrey,
  //   Colors.lightGreen,
  //   Colors.pinkAccent,
  // ];

  List<Map<String, dynamic>> catInfo = [
    {'imgPath': 'assets/images/ricecartoon.png', 'catText': 'Nasi & Lauk Pauk'},
    {'imgPath': 'assets/images/laukcartoon.png', 'catText': 'Lauk Pauk'},
    {'imgPath': 'assets/images/minumancartoon.png', 'catText': 'Minuman'},
    {'imgPath': 'assets/images/kerupukkartun.png', 'catText': 'Kerupuk'},
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: GestureDetector(
          child: TextWidget(
            text: 'Menu',
            color: color,
            textSize: 16,
            isTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            children: List.generate(4, (index) {
              return CategoriesWidget(
                passedColor: Theme.of(context).splashColor,
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
              );
            }),
          ),
        ),
      ),
    );
  }
}
