import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/inner_screen/feeds_screen.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/text_widgets.dart';

class EmptyScreen extends StatelessWidget {
  final String imagePath, title, subtitle, buttontext;
  const EmptyScreen(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttontext});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final themeState = Utils(context).getTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Yahhh!',
                style: GoogleFonts.loveYaLikeASister(
                    textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
              ),
              SizedBox(
                height: 20,
              ),
              TextWidget(text: title, color: Colors.deepPurple, textSize: 13),
              SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: subtitle, color: Colors.deepPurple, textSize: 13),
              SizedBox(
                height: size.height * 0.15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: color,
                          )),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: color,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      )),
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: FeedsScreen.routeName);
                  },
                  child: Text(
                    buttontext,
                    style: TextStyle(
                        color: themeState ? Colors.grey : Colors.grey.shade800),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
