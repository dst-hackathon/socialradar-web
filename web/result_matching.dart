import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert' show JSON;
import 'result.dart' show Result;
import 'dart:html' show Event, Node, HttpRequest;

@CustomTag('result-matching')
class ResultMatching extends PolymerElement {
  static const String RESULT_PATH = "http://http://api.radar.codedeck.com/users/1/friendsuggestions";
  
  @observable List<Result> results = toObservable([]);
  @observable List<int> stars = toObservable([]);
  @observable int currentPage = 0;
  
  ResultMatching.created() : super.created() {
    //retrieveResults();
    String json = '[{"email": "prawit@gmail.com","id": "2","weight": "4"},{"email": "opas@gmail.com","id": "4","weight": "3"},{"email": "atip@gmail.com","id": "5","weight": "3"}]';
    parseResults(json);
    
    getStars();
  }
  
  getStars() {
    stars = [];
    for(int i = 0; i < int.parse(results[currentPage].weight); i++) {
      stars.add(i);
    }
  }
  
  retrieveResults() {
    HttpRequest.getString(RESULT_PATH).then(parseResults);
  }
  
  parseResults(String jsonString) {
    List results = JSON.decode(jsonString);
    this.results = [];
    String picture = "";
    for( var result in results ) {
      if(int.parse(result["id"]) % 2 == 0) {
        picture = "boy";
      } else {
        picture = "girl";
      }
      Result r = new Result(result["id"], result["email"], picture, result["weight"]);
      this.results.add(r);
    }
  }
  
  seeNextMatching(Event e, var detail, Node target) {
    if(currentPage < results.length - 1) {
      currentPage = currentPage + 1;
      getStars();
    }
  }
  
  seePreviousMatching(Event e, var detail, Node target) {
    if(currentPage > 0) {
      currentPage = currentPage - 1;
      getStars();
    }
  }
}