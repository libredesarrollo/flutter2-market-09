
import 'package:market/models/app_state.dart';
import 'package:redux/redux.dart';

class UserAccessMiddleware implements MiddlewareClass<AppState> {

  @override
  call(Store<AppState> store, action, NextDispatcher next) {

    print("call");

      print(action);

  if (action is Function) {
    // funciones
    //if (store.state.user != null) 
    next(action);
    //clases
  } else {
    next(action);
  }

  }

}