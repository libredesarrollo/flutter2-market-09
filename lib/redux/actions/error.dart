part of '../actions.dart';

enum ErrorEnum {
  Ok,
  ConnectionTimeOut,
  Forbidden,
}

class ErrorAction {
  final ErrorEnum _errorEnum;
  final String _msj;

  ErrorEnum get errorEnum => this._errorEnum;
  String get msj => this._msj;

  ErrorAction(this._errorEnum,this._msj);
}