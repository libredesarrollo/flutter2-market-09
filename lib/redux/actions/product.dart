part of '../actions.dart';

ThunkAction<AppState> getProductsAction(Function errorFunction){
return (Store<AppState> store) async {

  try {
    final res = await http.get(Uri.parse("http://10.0.2.2:1337/products"));
    final List<dynamic> resData = json.decode(res.body);
    final List<Product> products = [];
    resData.forEach((pm) {
      final Product p = Product.fromJson(pm);
      products.add(p);
    });

    store.dispatch(GetProductsAction(products));
    store.dispatch(ErrorAction(ErrorEnum.Ok, "ok"));
  } catch (e) {
    //return errorFunction();
    print("Error Fatal de conexión " + e.toString());
    store.dispatch(GetProductsAction([]));
    store.dispatch(ErrorAction(ErrorEnum.ConnectionTimeOut, "No se pudo conectar al server *-*"));
  }
};
}

ThunkAction<AppState> updateProductAction(Product product) {
  return (Store<AppState> store) async {
    //final List<Product> products = store.state.products;

    //final int index = products.indexWhere((p) => p.id == product.id);
    //products[index] = product;

    // final res = await http.get("http://10.0.2.2:1337/products");
    // final List<dynamic> resData = json.decode(res.body);

    store.dispatch(UpdateProductAction(product));
  };
}

class GetProductsAction {
  final List<Product> _products;

  GetProductsAction(this._products);

  dynamic get products => this._products;
}

class UpdateProductAction {
  final Product _product;

  UpdateProductAction(this._product);

  dynamic get product => this._product;
}
