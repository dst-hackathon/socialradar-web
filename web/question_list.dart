import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node, HttpRequest;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'question.dart' show Question;
import 'category.dart' show Category;
import 'option.dart' show Option;
import 'package:core_elements/core_item.dart' show CoreItem;
import 'package:paper_elements/paper_item.dart' show PaperItem;
import 'package:paper_elements/paper_tab.dart' show PaperTab;

@CustomTag('question-list')
class QuestionList extends PolymerElement {
  static const String QUESTIONS_PATH = "http://api.radar.codedeck.com/questions";
  
  @observable List<Question> questions = toObservable([]);
  @observable List<Category> categories = toObservable([]);
  Map<String, Category> categoryMap = {};
  @observable List<Option> options = toObservable([]);
  @observable String questionLabel = "";
  
  
  QuestionList.created() : super.created() {
    //retrieveQuestions();
    String json = '[{"id": "1", "order": "1", "text": "What are your favorite menus?", "tag": "food"},{"id": "2", "order": "2", "text": "What sports do you play?", "tag": "sport"},{"id": "3", "order": "3", "tag": "movie", "text": "What are your favorite movies?"},{"id": "4", "order": "4", "tag": "music", "text": "What do music genres belong to you?"},{"id": "5", "order": "5", "tag": "book", "text": "What are your favorite books?"}]';
    parseQuestion(json);
  }
  
  retrieveQuestions() {
    HttpRequest.getString(QUESTIONS_PATH).then(parseQuestion);
  }
  
  parseQuestion(String jsonString) {
      List questions = JSON.decode(jsonString);
      this.questions = [];
      for( var question in questions ) {
        Question q = new Question(question["id"], question["order"], question["text"], question["tag"]);
        this.questions.add(q);
      }
  }
  
  questionClick(Event e, var detail, Node target) {
    e.preventDefault();
    print("Question clicked");
    
    String selectedQuestion = target.attributes["value"];
    retrieveCategoryList(selectedQuestion);
  }
   
  questionMouseOver(Event e, var detail, Node target) {
    clearCategoryName(target.parent.children);
    
    PaperItem paperItem = (target as PaperTab).children.first;
    paperItem.label = paperItem.attributes["text"];
  }
  
  questionMouseOut(Event e, var detail, Node target) {
    clearCategoryName(target.parent.children);
  }
  
  clearCategoryName(var paperTabs) {
    for(var item in paperTabs) {
      if(item is PaperTab) {
        PaperTab paperTab = item as PaperTab;
        (paperTab.children.first as PaperItem).label = '';
      }
    }
  }
  
  retrieveCategoryList(String questionId) {
    print("Selected question: $questionId");
    HttpRequest.getString(QUESTIONS_PATH + "/$questionId").then(parseCategory);
  }
  
  parseCategory(String jsonString) {
    List categoryList = JSON.decode(jsonString);
    this.categories = [];
    this.categoryMap = {};
    for( var c in categoryList ) {
      Category category = new Category(c["id"], c["order"], c["text"]);
      this.categories.add(category);
      this.categoryMap[c["id"]] = category;
      for(var o in c["options"]) {
        Option option = new Option(o["id"], o["order"], o["text"]);
        category.options.add(option);
      }
    }
  }
  
  categorySelect(Event e, var detail, Node target) {
    if( detail["isSelected"] ) {
      CoreItem c = detail["item"] as CoreItem;
      String id = c.getAttribute("value");
      this.options = this.categoryMap[id].options;
      print("Category  $id selected.");
    }
    else {
      this.options = [];
    }
  }
  
  optionSelect(Event e, var detail, Node target) {
    if( detail["isSelected"] ) {
      CoreItem c = detail["item"] as CoreItem;
      String id = c.getAttribute("value");
      print("Option  $id selected.");
    }
  }
}
