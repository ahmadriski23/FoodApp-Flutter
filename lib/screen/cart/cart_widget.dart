import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/models/cart_model.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/heart_button.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../../provider/products_provider.dart';

class CartWidget extends StatefulWidget {
  final int q;
  CartWidget({Key? key, required this.q}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    int usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    int totalPrice = usedPrice * int.parse(_quantityTextController.text);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FancyShimmerImage(
                          imageUrl: getCurrentProduct.imageUrl,
                          boxFit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: getCurrentProduct.title,
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: size.width * 0.3,
                            child: Row(
                              children: [
                                _quantityController(
                                    fct: () {
                                      if (_quantityTextController.text == '1') {
                                        return;
                                      } else {
                                        cartProvider.reduceQuantityByOne(
                                            cartModel.productId);
                                        setState(() {
                                          _quantityTextController.text =
                                              (int.parse(_quantityTextController
                                                          .text) -
                                                      1)
                                                  .toString();
                                        });
                                      }
                                    },
                                    icon: CupertinoIcons.minus,
                                    color: kSecondColor),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: _quantityTextController,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    enabled: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        if (v.isEmpty) {
                                          _quantityTextController.text = '1';
                                        } else {
                                          return;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                _quantityController(
                                    fct: () {
                                      cartProvider.increaseQuantityByOne(
                                          cartModel.productId);
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) +
                                                    1)
                                                .toString();
                                      });
                                    },
                                    icon: CupertinoIcons.plus,
                                    color: kSecondColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await cartProvider.removeOneItem(
                                      cartId: cartModel.id,
                                      productId: cartModel.productId,
                                      quantity: cartModel.quantity,
                                    );
                                  },
                                  child: Icon(
                                    CupertinoIcons.cart_badge_minus,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                HeartButton(
                                  productId: getCurrentProduct.id,
                                  isInWishlist: _isInWishlist,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                            text:
                                'Rp${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(0)}',
                            color: color,
                            textSize: 16,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController(
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
