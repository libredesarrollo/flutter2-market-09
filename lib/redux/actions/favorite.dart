part of '../actions.dart';

ThunkAction<AppState> toggleFavoriteAction(Product productFavorite) {
  return (Store<AppState> store) async {
    final List<Product> products = store.state.products;
    final User user = store.state.user;

    if (!_checkUserAuth(store)) return;

    final int index = products.indexWhere((p) => productFavorite.id == p.id);

    if (index > -1) {
      products[index].favorite = !products[index].favorite;
    }

    final List<Product> productsFavorite =
        products.where((p) => p.favorite).toList();

    final List<Map> productsFavoriteId =
        productsFavorite.map((p) => {'product_id': p.id}).toList();

    print(productsFavoriteId);

    final res = await http.put(
        Uri.parse("http://10.0.2.2:1337/favorites/${user.favoriteId}"),
        body: {
          "products": json.encode(productsFavoriteId),
        },
        headers: {
          "Authorization": "Bearer ${user.jwt}"
        });

    print(res.statusCode);

    store.dispatch(ToggleFavoriteAction(products));
  };
}

ThunkAction<AppState> getProductsFavoriteAction =
    (Store<AppState> store) async {
  final User user = store.state.user;

  final res = await http.get(
      Uri.parse("http://10.0.2.2:1337/favorites/${user.favoriteId}"),
      headers: {"Authorization": "Bearer ${user.jwt}"});

  print(res.statusCode);

  if (res.statusCode == 200) {
    final resData = json.decode(res.body);

    final resDataProducts = json.decode(resData['products']);

    return store.dispatch(GetProductsFavoriteAction(
        _setProductsIdToProductsFavorite(store, resDataProducts)));
  }
  store.dispatch(GetProductsFavoriteAction([]));
};

List<Product> _setProductsIdToProductsFavorite(
    Store<AppState> store, List<dynamic> productsString) {
  List<Product> products = store.state.products;

  productsString.forEach((pString) {
    final index =
        store.state.products.indexWhere((p) => p.id == pString['product_id']);

    if (index > -1) {
      store.state.products[index].favorite = true;
    }
  });

  return products;
}

// *** acciones

class ToggleFavoriteAction {
  final List<Product> _products;

  ToggleFavoriteAction(this._products);

  dynamic get products => this._products;
}

class GetProductsFavoriteAction {
  final List<Product> _products;

  GetProductsFavoriteAction(this._products);

  dynamic get products => this._products;
}
