import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('sign-in')
class ToolbarCountingPage extends PolymerElement {
  
  @observable String pageNumber = "0";
  
  ToolbarCountingPage.created() : super.created() {
    
  }

}