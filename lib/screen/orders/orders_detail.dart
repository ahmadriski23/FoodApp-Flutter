import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/models/orders_model.dart';
import 'package:provider/provider.dart';

import '../../constants/firebase_const.dart';
import '../../provider/dark_theme_provider.dart';
import '../../provider/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widgets.dart';
import '../../widgets/widget_back.dart';

class OrdersDetail extends StatefulWidget {
  String? orderId;
  String? productsId;

  static const routeName = "/OrdersDetailScreenState";

  OrdersDetail({super.key, required this.orderId, required this.productsId});

  @override
  State<OrdersDetail> createState() => _OrdersDetailState();
}

class _OrdersDetailState extends State<OrdersDetail> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late String orderDateToShow;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    bool isDark = themeState.getDarkTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.yellow : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: WidgetButtonBack(),
        title: TextWidget(
          text: 'Detail pesanan',
          color: color,
          textSize: 15,
          isTitle: true,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('orderId',
                        isEqualTo:
                            widget.orderId!.replaceAll(RegExp('%20'), ' '))
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.data != null || snapshot.hasData) {
                    DateTime orderDate =
                        snapshot.data!.docs[0].get('orderDate').toDate();
                    orderDateToShow =
                        '${orderDate.day}/${orderDate.month}/${orderDate.year}';
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 25, 25, 0),
                                  child: Text(
                                    'No.Pesanan: ${(snapshot.data!.docs[0].get('orderId'))}',
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 10, 25, 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total Pembayaran',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Rp.${int.parse(snapshot.data!.docs[0].get('price').toStringAsFixed(0))}',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                              ],
                                            )),
                                        Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Waktu Pembayaran',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                fontSize: 12,
                                              )),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              orderDateToShow,
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black12,
                                  height: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 10, 25, 25),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Rincian Pengiriman',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  _name ?? 'user',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                                ),
                                                Text(
                                                  address ?? 'user',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                                ),
                                              ],
                                            )),
                                        Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Metode Pembayaran',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                fontSize: 12,
                                              )),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'COD (Bayar Di Tempat)',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                fontSize: 11,
                                              )),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text('Loading'),
                      ),
                    );
                  }
                }),
              ),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('id',
                        isEqualTo:
                            widget.productsId!.replaceAll(RegExp('%20'), ' '))
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.data != null || snapshot.hasData) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rincian Pesanan'),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.docs[0].get('title')),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Jenis: ${snapshot.data!.docs[0].get('productCategoryName')}'),
                                Text(
                                    'Rp.${(snapshot.data!.docs[0].get('salePrice'))}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text('Loading'),
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
