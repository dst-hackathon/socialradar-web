import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node;
import 'question.dart' show Question;


@CustomTag('question-dropdown')
class QuestionDropdown extends PolymerElement {
  @published List questions = [];
  
  QuestionDropdown.created() : super.created() {
  }
  
}
