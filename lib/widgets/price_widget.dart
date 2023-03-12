import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/text_widgets.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale})
      : super(key: key);
  final int salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    int userPrice = isOnSale ? salePrice : price;
    return FittedBox(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                TextWidget(
                    text:
                        'Rp.${(userPrice * int.parse(textPrice)).toStringAsFixed(0)}',
                    color: Colors.green,
                    textSize: 14),
                Visibility(
                  visible: isOnSale ? true : false,
                  child: Text(
                    'Rp.${(price * int.parse(textPrice)).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
