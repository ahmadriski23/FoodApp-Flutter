import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/models/products_model.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/heart_button.dart';
import 'package:new_app/widgets/price_widget.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class FeedsWidget extends StatefulWidget {
  FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
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
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
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
                ctx: context, routeName: ProductDetails.routeName); */
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: productModel.imageUrl,
                  height: size.width * 0.21,
                  width: size.width * 0.2,
                  boxFit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: productModel.title,
                        color: color,
                        textSize: 14,
                        isTitle: true,
                      ),
                      HeartButton(
                        productId: productModel.id,
                        isInWishlist: _isInWishlist,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: PriceWidget(
                          salePrice: productModel.salePrice,
                          price: productModel.price,
                          textPrice: _quantityTextController.text,
                          isOnSale: productModel.isOnSale,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            FittedBox(
                              child: TextWidget(
                                text: 'KG',
                                color: Colors.transparent,
                                textSize: 15,
                                isTitle: true,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: TextFormField(
                              controller: _quantityTextController,
                              key: const ValueKey('10'),
                              style: TextStyle(color: color, fontSize: 18),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              enabled: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (valueee) {
                                setState(() {
                                  if (valueee.isEmpty) {
                                    _quantityTextController.text = '1';
                                  } else {}
                                });
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () async {
                          // if (_isInCart) {
                          //   return ;
                          // }
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle:
                                    'Maaf, silahkan login terlebih dahulu',
                                context: context);
                            return;
                          }
                          await GlobalMethods.addToCart(
                            productId: productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context,
                          );
                          await cartProvider.fetchCart();
                          // cartProvider.addProductsToCart(
                          //     productId: productModel.id,
                          //     quantity: int.parse(
                          //       _quantityTextController.text,
                          //     ));
                        },
                  child: productModel.stock == true
                      ? TextWidget(
                          text: _isInCart
                              ? 'Dalam keranjang'
                              : 'Tambah ke keranjang',
                          color: color,
                          textSize: 14,
                          maxLines: 1,
                        )
                      : TextWidget(
                          text: 'Stok Habis',
                          maxLines: 1,
                          color: color,
                          textSize: 20,
                        ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12))))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
