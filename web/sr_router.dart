import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'package:core_elements/core_scaffold.dart';
import 'dart:html';

@CustomTag('sr-router')
class SrRouter extends PolymerElement {

  CoreScaffold scaffold;

  SrRouter.created() : super.created() {
    print('created');

    var router = new Router(useFragment: true);

    router.root
        ..addRoute(
            name: 'home',
            defaultRoute: true,
            path: '/home',
            enter: showHome)
        ..addRoute(name: 'signin', path: '/signin', enter: showSignin)
        ..addRoute(name: 'questions', path: '/questions', enter: showQuestions)
        ..addRoute(name: 'result', path: '/result', enter: showResult);

    querySelector('#linkHome').attributes['href'] = router.url('home');
    querySelector('#linkSignIn').attributes['href'] = router.url('signin');
    querySelector('#linkQuestions').attributes['href'] =
        router.url('questions');
    querySelector('#linkResult').attributes['href'] = router.url('result');

    router.listen();
  }

  @override
  void attached() {
    super.attached();
    scaffold = $['scaffold'];
  }

  showHome(RouteEvent e) {
    print('Home');
    selectSection('section#home');
  }

  showSignin(RouteEvent e) {
    print('Sign In');
    selectSection('#signin');
  }

  showQuestions(RouteEvent e) {
    print('Questions');
    selectSection('#questions');
  }

  showResult(RouteEvent e) {
    print('Result');
    selectSection('#result');
  }

  selectSection(String sectionSelector) {
    querySelectorAll('section').classes.remove('core-selected');
    querySelector(sectionSelector).classes.add('core-selected');
    scaffold.closeDrawer();
  }
}
