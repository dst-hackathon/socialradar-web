import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'dart:html';

@CustomTag('sr-router')
class SrRouter extends PolymerElement {
  
  SrRouter.created() : super.created() {
    print('created');
    
    var router = new Router(useFragment: true);
   
    router.root
        ..addRoute(name: 'home', defaultRoute: true, path: '/home', enter: showHome)
        ..addRoute(name: 'signin', path: '/signin', enter: showSignin);

    querySelector('#linkHome').attributes['href'] = router.url('home');
    querySelector('#linkSignIn').attributes['href'] = router.url('signin');

    router.listen();
  }
  
  showHome(RouteEvent e) {
    print('Home');
    querySelector('#home').classes.add('core-selected');
    querySelector('#signin').classes.remove('core-selected');
  }
  
  showSignin(RouteEvent e) {
    print('Sign In');
    querySelector('#signin').classes.add('core-selected');
    querySelector('#home').classes.remove('core-selected'); 
  }
}
