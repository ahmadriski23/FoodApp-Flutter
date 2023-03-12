import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/loading_manager.dart';
import 'package:new_app/provider/dark_theme_provider.dart';
import 'package:new_app/screen/auth/forget_pass.dart';
import 'package:new_app/screen/auth/login.dart';
import 'package:new_app/screen/orders/orders_screen.dart';
import 'package:new_app/screen/viewed_recently/viewed_recently.dart';
import 'package:new_app/screen/wishlist/wishlist_screen.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Hi,  ',
                        style: GoogleFonts.fugazOne(
                          textStyle: TextStyle(
                            fontSize: 22,
                            color: kSecondColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: _name == null ? 'user' : _name,
                              style: GoogleFonts.fugazOne(
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('My name is pressed');
                                })
                        ]),
                  ),
                  TextWidget(
                      text: _email == null ? 'Email' : _email!,
                      color: color,
                      textSize: 15),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _listTiles(
                    title: 'Alamat',
                    subtitle: address,
                    color: color,
                    icon: IconlyLight.profile,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                  ),
                  _listTiles(
                      title: 'Pesanan',
                      color: color,
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      }),
                  _listTiles(
                    title: 'Wishlist Saya',
                    color: color,
                    icon: IconlyLight.heart,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: WishlistScreen.routeName);
                    },
                  ),
                  _listTiles(
                      title: 'Dilihat',
                      color: color,
                      icon: IconlyLight.show,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ViewedRecentlyScreen.routeName);
                      }),
                  _listTiles(
                      title: 'Lupa Password?',
                      color: color,
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      }),
                  SwitchListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Tema',
                              style: GoogleFonts.kreon(
                                  textStyle: TextStyle(
                                fontSize: 18,
                              )),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              themeState.getDarkTheme ? 'Gelap' : 'Terang',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                fontSize: 12,
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    secondary: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                    ),
                    value: themeState.getDarkTheme,
                    onChanged: (bool value) {
                      setState(
                        () {
                          themeState.setDarkTheme = value;
                        },
                      );
                    },
                  ),
                  _listTiles(
                    title: user == null ? 'Masuk' : 'Keluar',
                    color: color,
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        return;
                      }
                      GlobalMethods.warningDialog(
                          title: 'Keluar',
                          subtitle: 'Anda yakin ingin keluar?',
                          fct: () async {
                            await authInstance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          context: context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Perbarui'),
            content: TextField(
              // onChanged: (value) {
              //   print(
              //       '_addressTextController.text ${_addressTextController.text}');
              // },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Alamat Kamu"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String? _uid = user?.uid;
                  if (user == null) {
                    Navigator.pop(context);
                    GlobalMethods.errorDialog(
                        subtitle: 'Maaf, kamu belum login', context: context);

                    return;
                  }
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'shipping-address': _addressTextController.text,
                    });

                    Navigator.pop(context);
                    setState(() {
                      address = _addressTextController.text;
                    });
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        subtitle: err.toString(), context: context);
                  }
                },
                child: const Text('Perbarui'),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
        //isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 16,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
