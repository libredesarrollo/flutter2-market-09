import 'dart:convert';

import 'package:market/models/product.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:market/models/app_state.dart';
import 'package:market/models/user.dart';

part './actions/cart.dart';
part './actions/user.dart';
part './actions/favorite.dart';
part './actions/product.dart';
part './actions/error.dart';

_checkUserAuth(store) {
  if (store.state.user == null) {
     store.dispatch(ErrorAction(ErrorEnum.Forbidden, "Error de auth"));
  }
  return store.state.user != null;
}

//*** Middleware

