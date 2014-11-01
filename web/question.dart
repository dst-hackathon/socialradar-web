import 'package:polymer/polymer.dart';

class Question extends Observable{
  @observable String id;
  @observable String order;
  @observable String text;
  @observable String tag;
  
  Question(this.id, this.order, this.text, this.tag);
}
