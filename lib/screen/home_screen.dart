import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/constants/contss.dart';
import 'package:new_app/inner_screen/feeds_screen.dart';
import 'package:new_app/inner_screen/on_sale_screen.dart';
import 'package:new_app/models/products_model.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/dark_theme_provider.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/screen/cart/cart_screen.dart';
import 'package:new_app/screen/search_menu_screen.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/feed_items.dart';
import 'package:new_app/widgets/on_sale_widget.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAppbarCollapsing = false;
  final ScrollController _homeController = new ScrollController();
  @override
  void initState() {
    super.initState();

    // for adding appbar background color change effect
    // when scrolled
    _initializeController();
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  void _initializeController() {
    _homeController.addListener(() {
      if (_homeController.offset == 0.0 &&
          !_homeController.position.outOfRange) {
        //Fully expanded situation
        if (!mounted) return;
        setState(() => isAppbarCollapsing = false);
      }
      if (_homeController.offset >= 9.0 &&
          !_homeController.position.outOfRange) {
        //Collapsing situation
        if (!mounted) return;
        setState(() => isAppbarCollapsing = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);

    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              GlobalMethods.navigateTo(
                  ctx: context, routeName: SearchMenuScreen.routeName);
            },
            child: Icon(IconlyBroken.search,
                color: isDark
                    ? kSecondColor
                    : isAppbarCollapsing
                        ? kBlackColor
                        : kBlackColor),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InkWell(onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            }, child: Consumer<CartProvider>(
              builder: (_, myCart, ch) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -7, end: -7),
                  showBadge: true,
                  ignorePointer: false,
                  onTap: () {},
                  badgeContent: FittedBox(
                      child: TextWidget(
                          text: myCart.getCartItems.length.toString(),
                          color: isDark ? Colors.black : Colors.white,
                          textSize: 11)),
                  badgeAnimation: badges.BadgeAnimation.rotation(
                    toAnimate: true,
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: isDark ? kSecondColor : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                    padding: EdgeInsets.all(5),
                    elevation: 0,
                  ),
                  child: Icon(IconlyBroken.buy,
                      color: isDark
                          ? kSecondColor
                          : isAppbarCollapsing
                              ? kBlackColor
                              : kBlackColor),
                );
              },
            )),
          ),
        ],
        elevation: 0,
        backgroundColor:
            isAppbarCollapsing ? Colors.transparent : Colors.transparent,
        title: Text('Kami Saiyo',
            style: GoogleFonts.aclonica(
              textStyle: TextStyle(
                  color: isDark ? kSecondColor : kBlackColor, fontSize: 20),
            )),
      ),
      body: ListView(
        controller: _homeController,
        children: [
          Column(
            children: [
              SizedBox(
                child: Swiper(
                  layout: SwiperLayout.CUSTOM,
                  customLayoutOption: CustomLayoutOption(

                      // Which index is the first item of array below
                      startIndex: -1,
                      // array length
                      stateCount: 3)
                    ..addRotate([
                      // rotation of every item
                      -5.0 / 180,
                      0.0,
                      195.0 / 180
                    ])
                    ..addTranslate([
                      // offset of every item
                      Offset(-370.0, -40.0),
                      Offset(0.0, 0.0),
                      Offset(370.0, -40.0)
                    ]),

                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      Constss.offerImages[index],
                      fit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemWidth: 500,
                  itemHeight: size.height * 0.20,
                  itemCount: Constss.offerImages.length,
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.black, activeColor: Colors.red)),
                  // control: SwiperControl(color: Colors.pinkAccent),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: OnSaleScreen.routeName);
                },
                child: Container(
                  height: 30,
                  width: 140,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                          maxLines: 1,
                          text: 'Lihat Semua',
                          color: isDark
                              ? Colors.white
                              : Color.fromARGB(255, 0, 0, 0),
                          textSize: 14),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 70, top: 5),
                          child: TextWidget(
                            text: 'SEMUA DISKON',
                            color: Colors.red,
                            textSize: 18,
                            isTitle: true,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Icon(
                            IconlyLight.discount,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: size.height * 0.35,
                      child: ListView.builder(
                        itemCount: productsOnSale.length < 10
                            ? productsOnSale.length
                            : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: productsOnSale[index],
                              child: OnSaleWidget());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Untukmu',
                      color: color,
                      textSize: 18,
                      isTitle: true,
                    ),
                    InkWell(
                      onTap: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                      },
                      child: Container(
                        height: 30,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                                maxLines: 1,
                                text: 'Lihat Semua',
                                color: isDark
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 0, 0),
                                textSize: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                //crossAxisSpacing: 10,
                childAspectRatio: size.width / (size.height * 0.60),
                children: List.generate(
                    allProducts.length < 4 ? allProducts.length : 4, (index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: FeedsWidget(),
                  );
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
