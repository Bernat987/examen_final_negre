import 'package:examen_final_negre/models/examen_model.dart';
import 'package:flutter/material.dart';

class ExamenFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Examen tempExamen;

  ExamenFormProvider(this.tempExamen);

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }
}