import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:examen_final_negre/models/examen_model.dart';
import 'package:http/http.dart' as http;

class ExamenService extends ChangeNotifier {
  final String _baseURL = 'ca1249a708d96b2381b3.free.beeceptor.com';

  final List<Examen> examen = [];
  late Examen selectedExamen;
  File? newpicture;

  bool isLoading = true;
  bool isSaving = false;

  ExamenService(){
    this.loadExamen();
  }

  Future loadExamen() async{
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'api/examen/');
    final resp = await http.get(url);

    print(resp.body);
    
    var jsonResponse = List<Map<String, dynamic>>.from(convert.jsonDecode(resp.body));

    jsonResponse.forEach((value) {
      final tempProduct = Examen.fromMap(value);
      examen.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateExamen(Examen examen) async {
    isSaving = true;
    notifyListeners();

    if(examen.id == null) {
      await createExamen(examen);
    }else{
      await updateExamen(examen);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateExamen(Examen examen) async {
    final url = Uri.https(_baseURL, 'api/examen/');
    final resp = await http.put(url, body: examen.toJson());
    final decodedData = resp.body;
    print(decodedData);

    final index = this.examen.indexWhere((element) => element.id == examen.id);

    this.examen[index] = examen;

    return examen.id!;

  }

  Future<bool> deleteExamen(Examen examen) async{
    final url = Uri.https(_baseURL, 'api/examen/'+examen.id!);
    final resp = await http.delete(url);
    final decodedData = resp.body;

    return true;
  }

  Future<String> createExamen(Examen plat) async {
    final url = Uri.https(_baseURL, 'api/examen/');
    final resp = await http.post(url, body: plat.toJson());
    final decodedData = json.decode(resp.body);
    plat.id = decodedData['id'];
    this.examen.add(plat);

    //final index = this.products.indexWhere((element) => element.id == product.id);

    //this.products[index] = product;

    return plat.id!;

  }

  void updateSelectedImage(String path){
    this.newpicture = File.fromUri(Uri(path: path));
    this.selectedExamen.foto = path;

    notifyListeners();
  }

  Future<String?> uploadImage()async{
    if(this.newpicture == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dmkf327ed/image/upload?upload_preset=productapp');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newpicture!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print("Hi ha algun error");
      print(resp.body);
      return resp.body;
    }

    this.newpicture = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}