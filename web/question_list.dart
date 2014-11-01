import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node, HttpRequest;
import 'dart:convert' show JSON;
import 'question.dart' show Question;
import 'category.dart' show Category;
import 'option.dart' show Option;
import 'package:paper_elements/paper_item.dart' show PaperItem;

@CustomTag('question-list')
class QuestionList extends PolymerElement {
  static const String QUESTIONS_PATH = "http://api.radar.codedeck.com/questions";

  @observable List<Question> questions = toObservable([]);
  Question selectedQuestion;
  @observable List<Category> categories = toObservable([]);
  Category selectedCategory;
  @observable List<Option> options = toObservable([]);
  Option selectedOption;
  @observable String questionLabel = "";

  // Dynamic map to put answer to the server.
  @observable Map answerMap = {};

  @observable List<String> selectedItems = toObservable([]);

  QuestionList.created() : super.created() {
    retrieveQuestions();
//    String json = '[{"id": "1", "order": "1", "text": "What are your favorite menus?", "tag": "food"},{"id": "2", "order": "2", "text": "What sports do you play?", "tag": "sport"},{"id": "3", "order": "3", "tag": "movie", "text": "What are your favorite movies?"},{"id": "4", "order": "4", "tag": "music", "text": "What do music genres belong to you?"},{"id": "5", "order": "5", "tag": "book", "text": "What are your favorite books?"}]';
//    parseQuestion(json);
  }

  retrieveQuestions() {
    HttpRequest.getString(QUESTIONS_PATH).then(parseQuestion);
  }

  parseQuestion(String jsonString) {
    List questions = JSON.decode(jsonString);
    this.questions = toObservable([]);
    if (!questions.isEmpty) {
      for (var question in questions) {
        Question q = new Question(question["id"], question["order"], question["text"], question["tag"]);
        this.questions.add(q);
      }
      questionLabel = this.questions[0].text;
      this.selectedQuestion = this.questions[0];
      retrieveCategoryList(this.questions[0].id);
    }

  }

  questionClick(Event e, var detail, Node target) {
    e.preventDefault();
    print("Question clicked");
    String id = target.attributes["value"];
    questionLabel = target.attributes["text"];
    this.selectedQuestion = findQuestion(id);
    this.selectedCategory = null;
    this.selectedOption = null;
    retrieveCategoryList(id);
  }

  retrieveCategoryList(String questionId) {
    print("Selected question: $questionId");
    HttpRequest.getString(QUESTIONS_PATH + "/$questionId").then(parseCategory);
//    HttpRequest.getString("categories.json").then(parseCategory);
  }

  parseCategory(String jsonString) {
    Map questionMap = JSON.decode(jsonString);
    this.categories = toObservable([]);
    for (var c in (questionMap["categories"] as List)) {
      Category category = new Category(c["id"], c["order"], c["text"]);
      this.categories.add(category);
      for (var o in c["options"]) {
        Option option = new Option(o["id"], o["order"], o["text"]);
        category.options.add(option);
      }
    }
  }

  categorySelect(Event e, var detail, Node target) {
    this.options = toObservable([]);
    this.selectedOption = null;

    if (detail["isSelected"]) {
      PaperItem c = detail["item"] as PaperItem;
      String id = c.getAttribute("value");
      selectedCategory = findCategory(id);
      this.options = selectedCategory.options;

      print("Category  $id selected.");
    }

  }

  optionSelect(Event e, var detail, Node target) {
    if (detail["isSelected"]) {
      PaperItem c = detail["item"] as PaperItem;
      String id = c.getAttribute("value");
      this.selectedOption = findOption(id);
      print("Option  $id selected.");
    }
  }

  add() {
    // Build Map(Object) graph to be ready to post to server.
    if (answerMap[this.selectedQuestion.id] == null) {
      answerMap[this.selectedQuestion.id] = {};
    }
    if (answerMap[this.selectedQuestion.id][this.selectedCategory.id] == null) {
      answerMap[this.selectedQuestion.id][this.selectedCategory.id] = [];
    }
    bool addToAnswerList = this.selectedOption != null && !(answerMap[this.selectedQuestion.id][this.selectedCategory.id] as List<String>).contains(this.selectedOption.id);

    if (addToAnswerList) {
      answerMap[this.selectedQuestion.id][this.selectedCategory.id].add(int.parse(this.selectedOption.id));
    }
    print(JSON.encode(answerMap));
    addSelectItem();
  }

  go() {
    String user = getUser();
    var request = new HttpRequest();
    request.open("POST", "http://api.radar.codedeck.com/users/$user/answer");
    request.onLoad.listen((event) {
      print('event');
    }, onDone: () {
      postSuccess(request);
    }, onError: (e) {
      print('err' + e.toString());
    });
    request.send(JSON.encode(answerMap));
  }
  
  String getUser() {
    //should get it from somewhere else.
    return "115";
  }

  postSuccess(HttpRequest resp) {
    print(resp.responseText);
  }

  addSelectItem() {
    StringBuffer selectItemText = new StringBuffer();
    if(this.selectedQuestion != null) {
      String questionText = findQuestion(this.selectedQuestion.id).text;
      selectItemText.write( questionText );
    }
    if(this.selectedCategory != null) {
      String categoryText = findCategory(this.selectedCategory.id).text;
      selectItemText.write(" > $categoryText");
    }
    if(this.selectedOption != null) {
      String optionText = findOption(this.selectedOption.id).text;
      selectItemText.write(" > $optionText");

    }
    selectedItems.add(selectItemText.toString());
  }

  Question findQuestion(String id) => this.questions.where((c) => c.id == id).first;

  Category findCategory(String id) => this.categories.where((c) => c.id == id).first;

  Option findOption(String id) => this.options.where((c) => c.id == id).first;

}
