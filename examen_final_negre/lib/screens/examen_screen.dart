import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:examen_final_negre/providers/examen_form_provider.dart';
import 'package:examen_final_negre/services/services.dart';
import 'package:examen_final_negre/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class ExamenScreen extends StatelessWidget {
  const ExamenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examenService = Provider.of<ExamenService>(context);

    return ChangeNotifierProvider(
      create: (_) => ExamenFormProvider(examenService.selectedExamen),
      child: ProductScreenBody(productService: examenService),
    );
  }
}

class ProductScreenBody extends StatelessWidget {
  const ProductScreenBody({Key? key, required this.productService})
    : super(key: key);

  final ExamenService productService;

  @override
  Widget build(BuildContext context) {
    final examenForm = Provider.of<ExamenFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ExamenImage(url: productService.selectedExamen.foto),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            _ProductForm(),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _crearBotons(context, productService, examenForm)
    );
  }
}

Widget _crearBotons(BuildContext context, ExamenService examenService, ExamenFormProvider examenForm) {
    return Row(
      children: [
        SizedBox(width: 30.0),
        //Tipus de botons inspirats per l'api de Flutter
        //https://api.flutter.dev/flutter/material/FloatingActionButton-class.html

        //Problema amb múltiples botons pel heroTag, ajuda de Stack Overflow
        //https://stackoverflow.com/questions/51125024/there-are-multiple-heroes-that-share-the-same-tag-within-a-subtree
        FloatingActionButton(
        child:
            examenService.isSaving
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.save_outlined),
        onPressed:
            examenService.isSaving
                ? null
                : (() async {
                  if (!examenForm.isValidForm()) return;
                  final String? imageURL = await examenService.uploadImage();
                  if (imageURL != null) examenForm.tempExamen.foto = imageURL;
                  examenService.saveOrCreateExamen(examenForm.tempExamen);
                  Navigator.of(context).pushNamed('home');
                }),
      ),
      Expanded(child: SizedBox()),
      FloatingActionButton(
        heroTag: 'fe2',
        child:
            examenService.isSaving
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.delete),
        onPressed:
            examenService.isSaving
                ? null
                : (() async {
                  if (!examenForm.isValidForm()) return;
                  final String? imageURL = await examenService.uploadImage();
                  if (imageURL != null) examenForm.tempExamen.foto = imageURL;
                  examenService.deleteExamen(examenForm.tempExamen);
                  Navigator.of(context).pushNamed('home');
                }),
      ),
      ],
    );
  }

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final examenForm = Provider.of<ExamenFormProvider>(context);
    final tempProduct = examenForm.tempExamen;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: examenForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: tempProduct.nom,
                onChanged: (value) => tempProduct.nom = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El nom es obligatori';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nom del producte',
                  labelText: 'Nom:',
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempProduct.descripcio,
                onChanged: (value) => tempProduct.descripcio = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El nom es obligatori';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Descripcio del producte',
                  labelText: 'Descripcio:',
                ),
              ),

              SizedBox(height: 30),
              TextFormField(
                initialValue: tempProduct.tipus,
                onChanged: (value) => tempProduct.tipus = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El tipus es obligatori';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Tipus examen',
                  labelText: 'Tipus:',
                ),
              ),

              SizedBox(height: 30),

              TextFormField(
                initialValue: tempProduct.dificultat,
                onChanged: (value) => tempProduct.dificultat = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'La dificultat es obligatori';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Dificultat',
                  labelText: 'Dificultat:',
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(25),
      bottomLeft: Radius.circular(25),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0, 5),
        blurRadius: 5,
      ),
    ],
  );
}
