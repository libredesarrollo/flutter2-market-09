import 'package:market/models/product.dart';
import 'package:market/redux/actions.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final dynamic user;
  final List<Product> products;
  final List<Product> productsCart;
  final ErrorEnum errorEnum;

  AppState({required this.user, required this.products, required this.productsCart, required this.errorEnum});

  factory AppState.initial() {
    return AppState(user: null, products: [], productsCart: [], errorEnum: ErrorEnum.Ok);
  }

  List<Product> favorites() => products.where((p) => p.favorite).toList();
  //List<Product> carts() => products.where((p) => p.cartCount >= 1).toList();

  Product findOne(Product product) {
    final int index = products.indexWhere((p) => p.id == product.id);
    return products[index];
  }
}
