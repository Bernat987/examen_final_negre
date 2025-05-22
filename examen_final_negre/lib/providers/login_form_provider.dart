import 'package:flutter/material.dart';
import 'package:examen_final_negre/models/login_model.dart';
import 'package:examen_final_negre/providers/db_provider.dart';
import 'package:provider/provider.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String? user;
  
  String errorMessage = '';

  String email = '';
  String password = '';
  bool saveCredentials = false;

  bool accesGranted = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print('Valor del formulari: ${formKey.currentState?.validate()}');
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }
  loginUser(String email, String password, bool saveCredentials) async {
    isLoading = true;
    notifyListeners();
    try {
      final login = LoginModel(email: email, password: password, saveCredentials:saveCredentials);
      DBProvider.db.insertRawLogin(login);
      user = email;

      
    } catch (error) {
      errorMessage = getMessageFromErrorCode(error);
    }

    isLoading = false;
    accesGranted = user != null;
    notifyListeners();
  }

  loginUserWithoutSave(String email, String password, bool saveCredentials) async {
    isLoading = true;
    notifyListeners();
    try {
    
      user = email;

      
    } catch (error) {
      errorMessage = getMessageFromErrorCode(error);
    }

    isLoading = false;
    accesGranted = user != null;
    notifyListeners();
  }

  checkIsLogged()async{
    final log = await DBProvider.db.getAllLogins();
    print(log);
    return true;
    }
}
String getMessageFromErrorCode(errorCode) {
  switch (errorCode.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
    case "INVALID_LOGIN_CREDENTIALS":
      return "Invalid credentials.";
    default:
      return "Login failed. Please try again.";
  }
}