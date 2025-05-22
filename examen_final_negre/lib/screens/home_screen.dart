import 'package:flutter/material.dart';
import 'package:examen_final_negre/services/examen_service.dart';
import 'package:examen_final_negre/models/models.dart';
import 'package:examen_final_negre/screens/screens.dart';
import 'package:examen_final_negre/services/services.dart';
import 'package:examen_final_negre/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examenService = Provider.of<ExamenService>(context);

    if (examenService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Productes'),
      ),
      body: ListView.builder(
        itemCount: examenService.examen.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: ExamenCard(
            examen: examenService.examen[index],
          ),
          onTap: () {
            examenService.selectedExamen =
                examenService.examen[index].copy();
            Navigator.of(context).pushNamed('examen');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          examenService.newpicture = null;
          examenService.selectedExamen = Examen(descripcio: '', nom: '', dificultat: '', tipus: '');
          Navigator.of(context).pushNamed('examen');
        },
      ),
    );
  }
}