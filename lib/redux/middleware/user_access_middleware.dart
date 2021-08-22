import 'package:market/redux/actions.dart';
import 'package:redux/redux.dart';

import 'package:market/models/app_state.dart';
/*
List<Middleware<AppState>>userAccessMiddleware(){

  return [
    TypedMiddleware<AppState,ToggleFavoriteAction>(saveProductMiddleware)
  ];

}*/

checkStatusUserMiddleware(Store store, action, NextDispatcher next) {
  print("checkStatusUserMiddleware");
  print(action);

  if (action is Function) {
    // funciones
    //if (store.state.user != null) 
    next(action);
    //clases
  } else {
    next(action);
  }
  /*else if(action is GetProductsAction){
    print("GetProductsAction");

  }*/
}
