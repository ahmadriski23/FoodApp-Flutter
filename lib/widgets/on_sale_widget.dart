import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/models/products_model.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/heart_button.dart';
import 'package:new_app/widgets/price_widget.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class OnSaleWidget extends StatefulWidget {
  OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final productModel = Provider.of<ProductModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            if (productModel.stock == true) {
              Navigator.pushNamed(context, ProductDetails.routeName,
                  arguments: productModel.id);
            }
            /* GlobalMethods.navigateTo(
              ctx: context, routeName: ProductDetails.routeName
            ); */
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FancyShimmerImage(
                        imageUrl: productModel.imageUrl,
                        height: size.width * 0.30,
                        width: size.width * 0.30,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                TextWidget(
                  text: productModel.title,
                  color: color,
                  textSize: 14,
                  isTitle: true,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: '1',
                        isOnSale: true,
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _isInCart
                                  ? null
                                  : () async {
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
                                        productId: productModel.id,
                                        quantity: 1,
                                        context: context,
                                      );
                                      await cartProvider.fetchCart();
                                      // cartProvider.addProductsToCart(
                                      //   productId: productModel.id,
                                      //   quantity: 1,
                                      // );
                                    },
                              child: Icon(
                                _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                color: _isInCart ? Colors.green : color,
                              ),
                            ),
                            SizedBox(width: 5),
                            HeartButton(
                              productId: productModel.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
