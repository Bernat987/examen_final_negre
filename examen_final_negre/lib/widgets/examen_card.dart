import 'package:flutter/material.dart';
import 'package:examen_final_negre/models/examen_model.dart';

class ExamenCard extends StatelessWidget {
  final Examen examen;
  const ExamenCard({Key? key, required this.examen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroudWidget(url: examen.foto),
            _ExamenDetails(name: examen.nom, subtitle: examen.id!),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          ),
        ],
      );
}

class _BackgroudWidget extends StatelessWidget {
  final String? url;

  const _BackgroudWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null
            ? Image(image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover,)
            : Image.network(url!, loadingBuilder: (context, child, loadingProgress){
              if(loadingProgress == null) return child;
              return const Image(image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover,);
            },
            errorBuilder: (context, error, stackTrace) {
              return const Image(image: AssetImage('assets/no-image.png'));
            },)
      ),
    );
  }
}

class _ExamenDetails extends StatelessWidget {
  final String name, subtitle;

  const _ExamenDetails({
    Key? key,
    required this.name,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: double.infinity,
        height: 80,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
}