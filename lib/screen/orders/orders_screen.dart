import 'package:flutter/material.dart';
import 'package:new_app/provider/orders_provider.dart';
import 'package:new_app/screen/orders/orders_widget.dart';
import 'package:new_app/widgets/empty_screen.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:new_app/widgets/widget_back.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/OrdersScreenState";
  OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderList = ordersProvider.getOrders;

    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderList.isEmpty
              ? EmptyScreen(
                  imagePath: 'assets/images/cart.png',
                  title: 'Kamu belum pesan apapun disini',
                  subtitle: 'Pesan apapun sekarang dan buat perutmu kenyang',
                  buttontext: 'Pesan sekarang')
              : Scaffold(
                  appBar: AppBar(
                    leading: WidgetButtonBack(),
                    elevation: 0,
                    centerTitle: false,
                    title: TextWidget(
                      text: 'Pesanan kamu (${orderList.length})',
                      color: color,
                      textSize: 15,
                      isTitle: true,
                    ),
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  body: ListView.separated(
                    itemCount: orderList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                          value: orderList[index],
                          child: OrderWidget(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: color,
                        thickness: 1,
                      );
                    },
                  ));
        });
  }
}
