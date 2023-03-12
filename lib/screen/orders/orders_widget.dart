import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/inner_screen/product_details.dart';
import 'package:new_app/models/orders_model.dart';
import 'package:new_app/provider/products_provider.dart';
import 'package:new_app/screen/orders/orders_detail.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';

class OrderWidget extends StatefulWidget {
  OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct =
        productProvider.findProdById(ordersModel.productId);
    return ListTile(
      subtitle: Text(
          'Pembayaran: Rp${int.parse(ordersModel.price).toStringAsFixed(0)}'),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrdersDetail(
                      orderId: '${ordersModel.orderId}',
                      productsId: '${getCurrentProduct.id}',
                    )));
      },
      leading: FancyShimmerImage(
        height: size.width * 0.2,
        width: size.width * 0.2,
        imageUrl: getCurrentProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(
          text: '${getCurrentProduct.title} x${ordersModel.quantity}',
          color: color,
          textSize: 14),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 14),
    );
  }
}
