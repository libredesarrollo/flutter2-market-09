import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:market/models/app_state.dart';
import 'package:market/models/product.dart';
import 'package:market/redux/actions.dart';

import 'package:market/pages/login_page.dart';
import 'package:market/pages/product/detail_page.dart';
import 'package:market/pages/cart/index_page.dart' as cartPage;
import 'package:shared_preferences/shared_preferences.dart';

enum FilterOptions { Favorite, All }

class ProductsPage extends StatefulWidget {
  static const String ROUTE = "/";

  final Function() onInit;

  const ProductsPage({required this.onInit});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _showOnlyFavorite = false;
  bool _firstRequest = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {

    //final prefs = await SharedPreferences.getInstance();
    //prefs.setString('jwt', "asasas");

    await widget.onInit();
    _firstRequest = true;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Size size = MediaQuery.of(context).size;

    int countItem = 2;
    double space = size.width;

    if (orientation == Orientation.landscape) {
      countItem = 3;
    }

    if (space > 800.0) {
      countItem = 4;
    }

    return StoreConnector<AppState, AppState>(converter: (store) {
      if (store.state.user != null) {
        // NO VA BUCLE
//        store.dispatch(getProductsCartAction);
        //      store.dispatch(getProductsFavoriteAction);
      }

      return store.state;
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.store),
            onPressed: () {
              Navigator.pushNamed(context, cartPage.IndexPage.ROUTE);
            },
          ),
          centerTitle: true,
          title: state.user == null ? Text("Products") : Text(state.user.email),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    _showOnlyFavorite = selectedValue == FilterOptions.Favorite;
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Todos'),
                        value: FilterOptions.All,
                      ),
                      PopupMenuItem(
                        child: Text('Favoritos'),
                        value: FilterOptions.Favorite,
                      )
                    ]),
            state.user == null
                ? IconButton(
                    icon: Icon(Icons.login),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.ROUTE);
                    })
                : StoreConnector<AppState, VoidCallback>(
                    converter: (store) =>
                        () => store.dispatch(logoutUserAction),
                    builder: (_, callback) {
                      return IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            callback();
                          });
                    })
          ],
        ),
        body: Container(
          child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state) {
              final errorEnum = state.errorEnum;

              if (errorEnum == ErrorEnum.ConnectionTimeOut) {
                print("****** " + errorEnum.toString());
              }

              List<Product> products =
                  _showOnlyFavorite ? state.favorites() : state.products;

              if (state.products.length == 0 && _firstRequest) {
                print("Ocurrio un error, estoy en la página");
              }

              return errorEnum != ErrorEnum.ConnectionTimeOut
                  ? GridView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: countItem,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0),
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, DetailPage.ROUTE,
                                arguments: products[i]);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: GridTile(
                              header: GridTileBar(
                                title: Row(
                                  children: [
                                    Icon(
                                      products[i].cartCount >= 1
                                          ? Icons.shopping_cart
                                          : Icons.shopping_cart_outlined,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Icon(
                                      products[i].favorite
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: Theme.of(context).accentColor,
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                ),
                              ),
                              footer: Container(
                                  color: Colors.black87,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[i].name,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "${products[i].price.toString()} \$",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  )),
                              child: Image.network(
                                products[i].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("A ocurrido un error"),
                      SizedBox(height: 15,),
                      Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Text("Recargar"),
                              onPressed: (){
                                Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (_) =>super.widget));
                              },),
                        ),
                    ],
                  );
            },
          ),
        ),
      );
    });
  }
}
