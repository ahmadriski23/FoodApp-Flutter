import 'package:flutter/material.dart';
import 'package:new_app/models/products_model.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/empty_products_widget.dart';
import 'package:new_app/widgets/on_sale_widget.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:new_app/widgets/widget_back.dart';
import 'package:provider/provider.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: WidgetButtonBack(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Menu Terlaris',
          color: color,
          textSize: 18.0,
          isTitle: true,
        ),
      ),
      body: productsOnSale.isEmpty
          ? const EmptyProdWidget(
              text: 'Maaf, tidak ada makanan yang ditemukan',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              //crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.65),
              children: List.generate(productsOnSale.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productsOnSale[index],
                  child: OnSaleWidget(),
                );
              }),
            ),
    );
  }
}
