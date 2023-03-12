import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/firebase_const.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/models/viewed_model.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({super.key});

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProdModel = Provider.of<ViewedProdModel>(context);
    final getCurrentProduct =
        productProvider.findProdById(viewedProdModel.productId);
    int usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);

    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FancyShimmerImage(
                imageUrl: getCurrentProduct.imageUrl,
                boxFit: BoxFit.fill,
                height: size.width * 0.27,
                width: size.width * 0.25,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  TextWidget(
                    text: getCurrentProduct.title,
                    color: color,
                    textSize: 15,
                    isTitle: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextWidget(
                    text: 'Rp${usedPrice.toStringAsFixed(0)}',
                    color: color,
                    textSize: 14,
                    isTitle: false,
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: kYellowOneColor,
                  child: InkWell(
                    onTap: _isInCart
                        ? null
                        : () async {
                            final User? user = authInstance.currentUser;
                            if (user == null) {
                              GlobalMethods.errorDialog(
                                  subtitle: 'No user found, Please login first',
                                  context: context);
                              return;
                            }
                            await GlobalMethods.addToCart(
                              productId: getCurrentProduct.id,
                              quantity: 1,
                              context: context,
                            );
                            await cartProvider.fetchCart();
                            // cartProvider.addProductsToCart(
                            //   productId: getCurrentProduct.id,
                            //   quantity: 1,
                            // );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isInCart ? Icons.check : CupertinoIcons.plus,
                        color: kBlackColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
