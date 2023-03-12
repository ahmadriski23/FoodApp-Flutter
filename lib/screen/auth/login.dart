import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/contss.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/fetch_screen.dart';
import 'package:new_app/screen/auth/forget_pass.dart';
import 'package:new_app/screen/auth/register.dart';
import 'package:new_app/screen/bottom_bar1.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/widgets/auth_button.dart';
import 'package:new_app/widgets/google_button.dart';
import 'package:new_app/widgets/text_widgets.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
        print('Successfully logged in');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_pin,
                      color: kSecondColor,
                      size: 150,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: 'Welcome to Kami Saiyo',
                color: kBlackColor,
                textSize: 25,
                isTitle: true,
              ),
              SizedBox(
                height: 8,
              ),
              TextWidget(
                text: 'Sign in to continue',
                color: kBlackColor,
                textSize: 15,
                isTitle: true,
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        controller: _emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Harap masukkan email dengan benar';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.black26),
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          hintText: 'Masukkan Email',
                          labelText: 'Email',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: kSecondColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                            borderSide:
                                BorderSide(color: kSecondColor, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Password
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          _submitFormOnLogin();
                        },
                        controller: _passTextController,
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Harap masukkan password dengan benar';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          color: Colors.black26,
                        ),
                        decoration: InputDecoration(
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: kSecondColor, width: 2),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: _obscureText ? Colors.blue : Colors.grey,
                              )),
                          hintText: 'Masukkan Password',
                          labelText: 'Password',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: kSecondColor, width: 2),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ForgetPasswordScreen.routeName);
                    },
                    child: Text(
                      'Lupa Password?',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
    
              AuthButton(
                fct: _submitFormOnLogin,
                buttonText: 'Log In',
              ),
              SizedBox(
                height: 20,
              ),
              GoogleButton(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                      color: kSecondColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TextWidget(text: 'OR', color: Colors.black, textSize: 16),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                      color: kSecondColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FetchScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                      child: TextWidget(
                          text: 'Lanjutkan dengan akun guest',
                          color: kBlackColor,
                          textSize: 16)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tidak punya akun?',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: RegisterScreen.routeName);
                      },
                      child: Text('Daftar',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 16,
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
