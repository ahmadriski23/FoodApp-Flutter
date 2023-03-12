import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/provider/viewed_products.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/heart_button.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:new_app/widgets/widget_back.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';
  ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProviders = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProviders.findProdById(productId);

    int usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    int totalPrice = usedPrice * int.parse(_quantityTextController.text);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: WidgetButtonBack(),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrentProduct.imageUrl,
                boxFit: BoxFit.scaleDown,
                width: size.width,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextWidget(
                              text: getCurrentProduct.title,
                              color: color,
                              textSize: 16,
                              isTitle: true,
                            ),
                          ),
                          HeartButton(
                            productId: getCurrentProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Rp.',
                            color: Colors.green,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: usedPrice.toStringAsFixed(0),
                            color: Colors.green,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: '/Pcs',
                            color: color,
                            textSize: 10,
                            isTitle: false,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Visibility(
                            visible: getCurrentProduct.isOnSale ? true : false,
                            child: Row(
                              children: [
                                Text(
                                  'Rp.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: color,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  getCurrentProduct.price.toStringAsFixed(0),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: color,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  kSecondColor,
                                ]),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextWidget(
                                text: 'Gratis Ongkir',
                                color: kBlackColor,
                                textSize: 16,
                                isTitle: true,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _quantityControl(
                            fct: () {
                              if (_quantityTextController.text == '1') {
                                return;
                              } else {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) -
                                              1)
                                          .toString();
                                });
                              }
                            },
                            icon: CupertinoIcons.minus,
                            color: kSecondColor),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _quantityTextController,
                            key: ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: kBlueColor,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9]'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {}
                              });
                            },
                          ),
                        ),
                        _quantityControl(
                            fct: () {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text) +
                                            1)
                                        .toString();
                              });
                            },
                            icon: CupertinoIcons.plus,
                            color: kSecondColor),
                      ],
                    ),
                    Spacer(),
                    Container(
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Total',
                                  color: color,
                                  textSize: 16,
                                  isTitle: true,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '${totalPrice.toStringAsFixed(0)}/',
                                        color: color,
                                        textSize: 16,
                                        isTitle: true,
                                      ),
                                      TextWidget(
                                        text:
                                            '${_quantityTextController.text}Pcs',
                                        color: color,
                                        textSize: 12,
                                        isTitle: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                              child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
                              color: kSecondColor,
                              // gradient: LinearGradient(colors: [
                              //   Color.fromARGB(255, 252, 228, 17),
                              //   Color.fromARGB(255, 255, 242, 124),
                              //   Color.fromARGB(255, 255, 255, 255),
                              // ]),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: InkWell(
                              onTap: _isInCart
                                  ? null
                                  : () async {
                                      // if (_isInCart) {
                                      //   return ;
                                      // }
                                      final User? user =
                                          authInstance.currentUser;
                                      if (user == null) {
                                        GlobalMethods.errorDialog(
                                            subtitle:
                                                'Maaf, silahkan login terlebih dahulu',
                                            context: context);
                                        return;
                                      }
                                      await GlobalMethods.addToCart(
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(
                                            _quantityTextController.text),
                                        context: context,
                                      );
                                      await cartProvider.fetchCart();
                                      // cartProvider.addProductsToCart(
                                      //     productId: getCurrentProduct.id,
                                      //     quantity: int.parse(
                                      //       _quantityTextController.text,
                                      //     ));
                                    },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextWidget(
                                    text: _isInCart
                                        ? 'Dalam Keranjang'
                                        : 'Masukkan Keranjang',
                                    color: kBlackColor,
                                    isTitle: true,
                                    textSize: 12),
                              ),
                            ),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 1, color: Colors.black),
        ),
        child: InkWell(
          onTap: () {
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
