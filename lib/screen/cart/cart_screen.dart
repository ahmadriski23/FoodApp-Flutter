import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/orders_provider.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/screen/cart/cart_widget.dart';
import 'package:new_app/widgets/empty_screen.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../orders/orders_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemList.isEmpty
        ? EmptyScreen(
            title: 'Tidak ada menu di keranjangmu',
            subtitle: 'Tambahkan menu dan buat perutmu kenyang',
            buttontext: 'Belanja sekarang',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                  text: 'Keranjang (${cartItemList.length})',
                  color: color,
                  textSize: 15,
                  isTitle: true),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        title: 'Hapus Keranjang',
                        subtitle: 'Anda yakin ingin menghapus?',
                        fct: () async {
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                        context: context);
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemList[index],
                            child: CartWidget(
                              q: cartItemList[index].quantity,
                            ));
                      }),
                ),
              ],
            ));
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    int total = 0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrentProduct = productProvider.findProdById(value.productId);
      total += (getCurrentProduct.isOnSale
              ? getCurrentProduct.salePrice
              : getCurrentProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: kSecondColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.black, width: 1.5),
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Color.fromARGB(255, 255, 255, 255),
                  //     Color.fromARGB(255, 188, 207, 249),
                  //   ],
                  // ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    User? user = authInstance.currentUser;
                    final orderId = const Uuid().v4();
                    final productProviders =
                        Provider.of<ProductsProvider>(ctx, listen: false);

                    cartProvider.getCartItems.forEach((key, value) async {
                      final getCurrentProduct =
                          productProviders.findProdById(value.productId);
                      try {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(orderId)
                            .set({
                          'orderId': orderId,
                          'userId': user!.uid,
                          'productId': value.productId,
                          'price': (getCurrentProduct.isOnSale
                                  ? getCurrentProduct.salePrice
                                  : getCurrentProduct.price) *
                              value.quantity,
                          'totalPrice': total,
                          'quantity': value.quantity,
                          'imageUrl': getCurrentProduct.imageUrl,
                          'userName': user.displayName,
                          'orderDate': Timestamp.now(),
                        });
                        await cartProvider.clearOnlineCart();
                        cartProvider.clearCart();
                        ordersProvider.fetchOrders();
                        await Fluttertoast.showToast(
                          backgroundColor: kSecondColor,
                          textColor: Colors.black,
                          msg: "Terima kasih telah mengorder",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                        await GlobalMethods.navigateTo(
                            ctx: ctx, routeName: OrdersScreen.routeName);
                        await Fluttertoast.showToast(
                          backgroundColor: kSecondColor,
                          textColor: Colors.black,
                          msg: "Silahkan cek detail pesanan anda",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP_RIGHT,
                        );
                      } catch (error) {
                        GlobalMethods.errorDialog(
                            subtitle: error.toString(), context: ctx);
                      } finally {}
                    });
                  },
                  child: Center(
                    child: TextWidget(
                        text: 'Pesan Sekarang',
                        color: kBlackColor,
                        textSize: 14),
                  ),
                ),
              ),
            ),
            Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total: Rp.${total.toStringAsFixed(0)}',
                color: color,
                textSize: 14,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
