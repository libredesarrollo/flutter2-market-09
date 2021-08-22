

part of '../actions.dart';

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();

  final Map<String, dynamic> userMap = prefs.getString('email') == null
      ? Map()
      : ({
          'email': prefs.getString('email'),
          'jwt': prefs.getString('jwt'),
          'username': prefs.getString('username'),
          'id': prefs.getString('id'),
          'cart_id': prefs.getString('cart_id'),
          'favorite_id': prefs.getString('favorite_id'),
        });

  final user = userMap.length == 0 ? null : User.fromJson(userMap);

  store.dispatch(GetUserAction(user));

  return user;
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove('email');
  await prefs.remove('id');
  await prefs.remove('jwt');
  await prefs.remove('username');
  await prefs.remove('cart_id');
  await prefs.remove('favorite_id');

  store.dispatch(LogoutUserAction(null));
};


class GetUserAction {
  final dynamic _user;

  dynamic get user => this._user;

  GetUserAction(this._user);
}

class LogoutUserAction {
  final dynamic _user;

  dynamic get user => this._user;

  LogoutUserAction(this._user);
}