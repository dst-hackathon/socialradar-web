import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node;

@CustomTag('question-list')
class QuestionList extends PolymerElement {
  @observable List<String> categories;
  @observable List<String> questions;
  
  QuestionList.created() : super.created() {
    retrieveCategories();
  }
  
  retrieveCategories() {
    categories = ["Sport", "Food", "Movie"];
  }
  
  categoryClick(Event e, var detail, Node target) {
    e.preventDefault();
    print("Category clicked");
    // Use its text to query for now.
    String selectedCategory = target.text;
    retrieveQuestionList(selectedCategory);
  }
  
  questionClick(Event e, var detail, Node target) {
    e.preventDefault();
    print("Question clicked");
  }
  
  retrieveQuestionList(String category) {
    print("Selected category: $category");
    if( category == "Food") {
      questions = [];
    }
    else {
      questions= ["Football", "Baseball", "Basketball"]; 
    }
  }
}
