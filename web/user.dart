import 'package:polymer/polymer.dart';
import 'dart:html';

class User extends Observable {

  @observable String email = '';
  @observable String name = '';
  @observable String password = '';
  @observable String confirmPassword = '';
  @observable File file;

  // Constructor.
  User();

  Map<String, String> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'confirmPassword': confirmPassword,
      'file': file.name
    };
  }
}
