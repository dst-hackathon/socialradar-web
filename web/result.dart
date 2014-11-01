library polymer_and_dart.web.models;

import 'package:polymer/polymer.dart';

class Result extends Observable{
  @observable String id;
  @observable String email;
  @observable String picture;
  @observable String weight;
  
  Result(this.id, this.email, this.picture, this.weight);
}
