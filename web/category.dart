import 'package:polymer/polymer.dart';
import 'option.dart' show Option;
class Category extends Observable{
  @observable String id;
  @observable String order;
  @observable String text;
  @observable List<Option> options = toObservable([]);
  
  Category(this.id, this.order, this.text);
  
}
