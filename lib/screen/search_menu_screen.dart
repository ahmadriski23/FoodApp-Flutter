import 'package:flutter/material.dart';
import 'package:new_app/models/products_model.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/empty_products_widget.dart';
import 'package:new_app/widgets/feed_items.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:new_app/widgets/widget_back.dart';
import 'package:provider/provider.dart';

import '../constants/color.dart';
import '../provider/dark_theme_provider.dart';

class SearchMenuScreen extends StatefulWidget {
  static const routeName = "/SearchMenuScreenState";
  const SearchMenuScreen({Key? key}) : super(key: key);

  @override
  State<SearchMenuScreen> createState() => _SearchMenuScreenState();
}

class _SearchMenuScreenState extends State<SearchMenuScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
  //   productsProvider.fetchProducts();
  //   super.initState();
  // }

  // void didChangeDependencies() {

  // }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Utils utils = Utils(context);
    return Scaffold(
      appBar: AppBar(
        leading: WidgetButtonBack(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'Pencarian',
          color: color,
          textSize: 16.0,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                onChanged: (valuee) {
                  setState(() {
                    listProductSearch = productProviders.searchQuery(valuee);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.black, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: kSecondColor, width: 2),
                  ),
                  hintText: "Kamu lagi mau makan apa nih?",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchTextController!.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _searchTextController!.text.isNotEmpty && listProductSearch.isEmpty
              ? const EmptyProdWidget(text: 'Maaf, makanan tidak ditemukan')
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  // crossAxisSpacing: 10,
                  childAspectRatio: size.width / (size.height * 0.61),
                  children: List.generate(
                      _searchTextController!.text.isNotEmpty
                          ? listProductSearch.length
                          : allProducts.length, (index) {
                    return ChangeNotifierProvider.value(
                      value: _searchTextController!.text.isNotEmpty
                          ? listProductSearch[index]
                          : allProducts[index],
                      child: FeedsWidget(),
                    );
                  }),
                ),
        ]),
      ),
    );
  }
}
