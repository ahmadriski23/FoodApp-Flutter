import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_app/constants/theme_data.dart';
import 'package:new_app/fetch_screen.dart';
import 'package:new_app/inner_screen/category_screen.dart';
import 'package:new_app/inner_screen/feeds_screen.dart';
import 'package:new_app/inner_screen/on_sale_screen.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/provider/cart_provider.dart';
import 'package:new_app/provider/dark_theme_provider.dart';
import 'package:new_app/provider/orders_provider.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/provider/viewed_products.dart';
import 'package:new_app/provider/wishlist_provider.dart';
import 'package:new_app/screen/auth/forget_pass.dart';
import 'package:new_app/screen/auth/login.dart';
import 'package:new_app/screen/auth/register.dart';
import 'package:new_app/screen/bottom_bar1.dart';
import 'package:new_app/screen/home_screen.dart';
import 'package:new_app/screen/orders/orders_detail.dart';
import 'package:new_app/screen/orders/orders_screen.dart';
import 'package:new_app/screen/search_menu_screen.dart';
import 'package:new_app/screen/viewed_recently/viewed_recently.dart';
import 'package:new_app/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('An error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Kami Saiyo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                  FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                  SearchMenuScreen.routeName: (ctx) => const SearchMenuScreen(),
                  ProductDetails.routeName: (ctx) => ProductDetails(),
                  WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  ViewedRecentlyScreen.routeName: (ctx) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                  LoginScreen.routeName: (ctx) => const LoginScreen(),
                  ForgetPasswordScreen.routeName: (ctx) =>
                      const ForgetPasswordScreen(),
                  CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                },
              );
            }),
          );
        });
  }
}
