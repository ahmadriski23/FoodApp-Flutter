import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:uuid/uuid.dart';

import '../constants/color.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/logo_ks.jpg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            content: Text(
              subtitle,
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    color: Colors.cyan,
                    text: 'Batal',
                    textSize: 14,
                  )),
              TextButton(
                  onPressed: () {
                    fct();
                  },
                  child: TextWidget(
                    color: Colors.red,
                    text: 'OK',
                    textSize: 14,
                  ))
            ],
          );
        });
  }

  static Future<void> errorDialog(
      {required String subtitle, required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/logo_ks.jpg',
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text('Peringatan'),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Ok',
                  textSize: 15,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final cartId = Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Dimasukkan ke keranjang",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kSecondColor,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static Future<void> addToWishlist({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Dimasukkan ke wishlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kSecondColor,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
}
