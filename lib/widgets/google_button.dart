import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/fetch_screen.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/widgets/text_widgets.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({super.key});

  bool _isLoading = false;
  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );

          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '${error}', context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(50),
      ),
      width: double.infinity,
      height: 50,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/google.png',
                  width: 40.0,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              TextWidget(
                  text: 'Masuk dengan Google',
                  color: Colors.black,
                  textSize: 16)
            ],
          ),
        ),
      ),
    );
  }
}
