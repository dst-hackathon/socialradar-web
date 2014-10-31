import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node, HttpRequest;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'question.dart' show Question;

@CustomTag('question-list')
class QuestionList extends PolymerElement {
  static const String QUESTIONS_PATH = "http://api.radar.codedeck.com/questions";
  @observable List<Question> categories = [];
  @observable List<Question> questions = [];
  @observable List<Question> questions2 = [];
  
  QuestionList.created() : super.created() {
    retrieveCategories();
  }
  
  retrieveCategories() {
    HttpRequest.getString(QUESTIONS_PATH).then(parseCategory);
  }
  
  parseCategory(String jsonString) {
      List questions = JSON.decode(jsonString);
      this.categories = [];
      for( var question in questions ) {
        Question q = new Question(question["id"], question["order"], question["text"]);
        this.categories.add(q);
      }
  }
  
  categoryClick(Event e, var detail, Node target) {
    e.preventDefault();
    print("Category clicked");
    this.questions = [];
    // Use its text to query for now.
    String selectedCategory = target.text;
    retrieveQuestionList(selectedCategory);
  }
  
  
  retrieveQuestionList(String category) {
    print("Selected category: $category");
//    HttpRequest.getString(QUESTIONS_PATH).then(parseQuestion);
  }
  
  parseQuestion(String jsonString) {
    // TBD
  }
  
  questionSelect(Event e, var detail, Node target) {
    if( detail.isSelected ) {
      Question selected = detail.item as Question;
      print("Question  $selected.text selected.");
      
    }
  }
}
