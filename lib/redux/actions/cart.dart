part of '../actions.dart';

ThunkAction<AppState> toggleCartProductAction(Product cartProduct, int count) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = List.of(store.state.productsCart);

    final User user = store.state.user;

    if(!_checkUserAuth(store))return;

    final int index = cartProducts.indexWhere((p) => cartProduct.id == p.id);

    if (index > -1) {
      cartProduct.cartCount = 0;
      cartProducts.removeAt(index);
    } else {
      cartProduct.cartCount = count;
      print(store.state.productsCart);
      cartProducts.add(cartProduct);
      print(store.state.productsCart);
    }

    final List<Map> cartProductsIds = cartProducts
        .map((p) => {'product_id': p.id, 'count': p.cartCount})
        .toList();

    print(cartProductsIds);

    final res = await http
        .put(Uri.parse("http://10.0.2.2:1337/carts/${user.cartId}"), body: {
      "products": json.encode(cartProductsIds),
    }, headers: {
      "Authorization": "Bearer ${user.jwt}"
    });

    if (res.statusCode == 200) {
      store.dispatch(TogleCartProductAction(cartProducts));
    } else if (res.statusCode == 401) {
      store.dispatch(logoutUserAction);
      store
          .dispatch(ErrorAction(ErrorEnum.Forbidden, "Problemas con el login"));
    }
  };
}

ThunkAction<AppState> changeCartProductAction(Product cartProduct, int count) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.productsCart;
    final User user = store.state.user;

    final int index = cartProducts.indexWhere((p) => cartProduct.id == p.id);

    if (index > -1) {
      cartProducts[index].cartCount = count;
    }

    final List<Map> cartProductsIds = cartProducts
        .map((p) => {'product_id': p.id, 'count': p.cartCount})
        .toList();

    print(cartProductsIds);

    final res = await http
        .put(Uri.parse("http://10.0.2.2:1337/carts/${user.cartId}"), body: {
      "products": json.encode(cartProductsIds),
    }, headers: {
      "Authorization": "Bearer ${user.jwt}"
    });

    print(res.statusCode);

    store.dispatch(ChangeCartProductAction(cartProducts));
  };
}

ThunkAction<AppState> getProductsCartAction = (Store<AppState> store) async {
  final User user = store.state.user;

  final res = await http.get(
      Uri.parse("http://10.0.2.2:1337/carts/${user.cartId}"),
      headers: {"Authorization": "Bearer ${user.jwt}"});

  if (res.statusCode == 200) {
    final resData = json.decode(res.body);

    try {
      final resDataProducts = json.decode(resData['products']);

      return store.dispatch(GetProductsCartAction(
          _setProductsIdToProducts(store, resDataProducts)));
    } catch (e) {}
  }
  store.dispatch(GetProductsCartAction([]));
};

List<Product> _setProductsIdToProducts(
    Store<AppState> store, List<dynamic> productsString) {
  List<Product> productsCart = [];

  productsString.forEach((pString) {
    final index =
        store.state.products.indexWhere((p) => p.id == pString['product_id']);

    if (index > -1) {
      store.state.products[index].cartCount = pString['count'];
      productsCart.add(store.state.products[index]);
    }
  });

  return productsCart;
}

class GetProductsCartAction {
  final List<Product> _productsCart;

  GetProductsCartAction(this._productsCart);

  dynamic get productsCart => this._productsCart;
}

class TogleCartProductAction {
  final List<Product> _cartProducts;

  TogleCartProductAction(this._cartProducts);

  dynamic get cartProducts => this._cartProducts;
}

class ChangeCartProductAction {
  final List<Product> _cartProducts;

  ChangeCartProductAction(this._cartProducts);

  dynamic get cartProducts => this._cartProducts;
}
