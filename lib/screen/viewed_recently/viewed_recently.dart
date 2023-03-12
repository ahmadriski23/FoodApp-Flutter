import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:new_app/provider/viewed_products.dart';
import 'package:new_app/screen/viewed_recently/viewed_widget.dart';
import 'package:new_app/services/global_methods.dart';
import 'package:new_app/services/utils.dart';
import 'package:new_app/widgets/empty_screen.dart';
import 'package:new_app/widgets/text_widgets.dart';
import 'package:new_app/widgets/widget_back.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = "/ViewedRecentlyScreenState";
  const ViewedRecentlyScreen({super.key});

  @override
  State<ViewedRecentlyScreen> createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  bool _isEmpty = false;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemList = viewedProdProvider.getViewedProdlistItems.values
        .toList()
        .reversed
        .toList();

    if (viewedProdItemList.isEmpty) {
      return EmptyScreen(
          imagePath: 'assets/images/history.png',
          title: 'Histori mu kosong',
          subtitle: 'Tidak ada menu yang terlihat disini',
          buttontext: 'Pesan menu sekarang');
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: TextWidget(text: 'Histori', color: color, textSize: 20),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.10),
          leading: WidgetButtonBack(),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Kosongkan Historimu?',
                    subtitle: 'Kamu Yakin?',
                    fct: () async {
                      viewedProdProvider.clearHistory();
                      Navigator.pop(context);
                    },
                    context: context);
              },
              icon: Icon(
                IconlyBold.delete,
                color: color,
              ),
            )
          ],
        ),
        body: ListView.builder(
            itemCount: viewedProdItemList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: viewedProdItemList[index],
                    child: ViewedRecentlyWidget()),
              );
            }),
      );
    }
  }
}
