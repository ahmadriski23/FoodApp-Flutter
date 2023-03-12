import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_app/models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> productsList = [];
  List<ProductModel> get getProducts {
    return productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      productsList = [];
      // productsList.clear();
      productSnapshot.docs.forEach((element) {
        productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: int.parse(element.get('price')),
              salePrice: element.get('salePrice'),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
              stock: element.get('stock'),
            ));
      });
    });
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> categoryList = productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return _searchList;
  }

  // static final List<ProductModel> productsList = [
  //   ProductModel(
  //       id: '666',
  //       title: 'Kopi Susu Gula Aren',
  //       imageUrl:
  //           'https://assets.resepedia.id/assets/images/2021/02/1692211110068875-es-kopi-susu-gula-aren.jpg',
  //       productCategoryName: 'Coffee',
  //       price: 20000,
  //       SalePrice: 17000,
  //       isOnSale: true),
  //   ProductModel(
  //       id: '678',
  //       title: 'Espresso',
  //       imageUrl:
  //           'https://akcdn.detik.net.id/community/media/visual/2021/12/19/3-trik-bikin-kopi-espresso-tanpa-mesin-hasilnya-tetap-nikmat.jpeg?w=700&q=90',
  //       productCategoryName: 'Coffee',
  //       price: 12000,
  //       SalePrice: 10000,
  //       isOnSale: true),
  //   ProductModel(
  //       id: '679',
  //       title: 'Americano',
  //       imageUrl:
  //           'https://images.tokopedia.net/img/cache/900/product-1/2020/4/7/8232057/8232057_a24f80ad-593d-4a04-a798-3302f81e0edd_836_836.jpg',
  //       productCategoryName: 'Coffee',
  //       price: 15000,
  //       SalePrice: 12000,
  //       isOnSale: true),
  //   ProductModel(
  //       id: '680',
  //       title: 'Blue Ocean',
  //       imageUrl:
  //           'https://winarno999wins.files.wordpress.com/2014/04/blue-ocean.jpg?w=1400&h=',
  //       productCategoryName: 'Fresh Drink',
  //       price: 23000,
  //       SalePrice: 20000,
  //       isOnSale: true),
  //   ProductModel(
  //       id: '681',
  //       title: 'Red Velvet Latte',
  //       imageUrl:
  //           'https://endeus.tv/_next/image?url=https%3A%2F%2Fkurio-img.kurioapps.com%2F20%2F06%2F28%2Fb8bcbf61-e003-459b-b347-dd8d72f0d4b8.jpg&w=360&q=70',
  //       productCategoryName: 'Powder Drink',
  //       price: 23000,
  //       SalePrice: 20000,
  //       isOnSale: false),
  // ];
}
