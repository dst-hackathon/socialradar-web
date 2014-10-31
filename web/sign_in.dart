import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('sign-in')
class SignIn extends PolymerElement {
  
  @observable bool hiddenSigninForm = false;
  @observable bool hiddenRegisterForm = true;
  @published String pageNumber = "";
  
  toggleSigninForm(Event e, var detail, Node sender) {
    hiddenSigninForm = !hiddenSigninForm;
    hiddenRegisterForm = !hiddenRegisterForm;
  }
  
  SignIn.created() : super.created() {
    
  }

}