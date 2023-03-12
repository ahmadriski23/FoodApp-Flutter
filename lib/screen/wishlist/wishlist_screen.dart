import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/screen/cart/cart_widget.dart';
import 'package:new_app/screen/wishlist/wishlist_widget.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/widgets/empty_screen.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:new_app/widgets/widget_back.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreenState";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemList.isEmpty
        ? EmptyScreen(
            imagePath: 'assets/images/wishlist.png',
            title: 'Wishlist mu kosong',
            subtitle: 'Tambahkan wishlistmu sekarang ',
            buttontext: 'Tambahkan wish')
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: WidgetButtonBack(),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                  text: 'Wishlist Kamu (${wishlistItemList.length})',
                  color: color,
                  textSize: 15,
                  isTitle: true),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        title: 'Hapus Wishlist',
                        subtitle: 'Anda yakin ingin menghapus?',
                        fct: () async {
                          await wishlistProvider.clearOnlineWishlist();
                          wishlistProvider.clearWishlist();
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
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MasonryGridView.count(
                itemCount: wishlistItemList.length,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 20,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                      value: wishlistItemList[index],
                      child: const WishlistWidget());
                },
              ),
            ),
          );
  }
}
