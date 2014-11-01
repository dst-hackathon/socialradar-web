import 'package:polymer/polymer.dart';

class Option extends Observable{
  @observable String id;
  @observable String order;
  @observable String text;
  
  
  Option(this.id, this.order, this.text);
}
