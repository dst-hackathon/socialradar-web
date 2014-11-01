import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
import 'dart:html';
import 'user.dart';

@CustomTag('sign-in')
class SignIn extends PolymerElement {

  static const String SERVER = 'http://api.radar.codedeck.com';
  static const String SIGNUP_API = '$SERVER/signup';

  @observable bool hiddenSigninForm = false;
  @observable bool hiddenRegisterForm = true;
  @observable User user;

  @published String pageNumber = "";


  toggleSigninForm(Event e, var detail, Node sender) {
    hiddenSigninForm = !hiddenSigninForm;
    hiddenRegisterForm = !hiddenRegisterForm;
  }

  SignIn.created() : super.created() {
    user = new User();
  }

  prepareAvatar(Event event, Object detail, FileUploadInputElement fileInput) {
    if (fileInput.files.length == 1) {
      final File file = fileInput.files[0];
      user.file = file;
    }
  }

  bool isRegisterFormValid() {
    List<PaperInput> registerInputs =
        shadowRoot.querySelectorAll('#registerForm > paper-input');

    bool isFormValid = true;
    for (var input in registerInputs) {
      if (input.invalid) {
        isFormValid = false;
      }
    }

    return isFormValid;
  }

  registerUser(Event event, Object detail, Node sender) {
    if (isRegisterFormValid()) {
      
      final xhr = new HttpRequest();
      xhr.open('POST', SIGNUP_API);
      xhr.onReadyStateChange.listen((e) {
        if (xhr.readyState == 4 && xhr.status == 200) {
          print('Sign-up Successfully');
        } else {
          print(xhr.responseText);
        }
      });
      
      xhr.send(new FormData()
        ..append('email', user.email)
        ..append('password', user.password)
        ..appendBlob('file', user.file)
      );
    }
  }
}
