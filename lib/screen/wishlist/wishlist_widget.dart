import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/models/wishlist_model.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/heart_button.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrentProduct =
        productProvider.findProdById(wishlistModel.productId);
    int usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: wishlistModel.productId);
          },
          child: Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: color, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.20,
                  width: size.height * 0.20,
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: size.height * 0.20,
                  height: size.height * 0.13,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: TextWidget(
                          text: getCurrentProduct.title,
                          color: color,
                          textSize: 14,
                          maxLines: 2,
                          isTitle: true,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        text: 'Rp${usedPrice.toStringAsFixed(0)}',
                        color: color,
                        textSize: 12,
                        maxLines: 1,
                        isTitle: true,
                      ),
                      Flexible(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              HeartButton(
                                productId: getCurrentProduct.id,
                                isInWishlist: _isInWishlist,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
