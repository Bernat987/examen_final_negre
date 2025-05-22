import 'dart:convert';

class Examen {
     String? id;
     String nom;
     String descripcio;
     String? foto;
     String dificultat;
     String tipus;

    Examen({
        this.id,
        required this.nom,
        required this.descripcio,
        this.foto,
        required this.dificultat,
        required this.tipus,
    });

    Examen copy() => Examen(
        descripcio: this.descripcio,
        foto: this.foto,
        nom: this.nom,
        tipus: this.tipus,
        dificultat: this.dificultat,
        id: this.id
      );

    factory Examen.fromJson(String str) => Examen.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Examen.fromMap(Map<String, dynamic> json) => Examen(
        id: json["id"],
        nom: json["nom"],
        descripcio: json["descripcio"],
        foto: json["foto"],
        dificultat: json["dificultat"],
        tipus: json["tipus"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nom": nom,
        "descripcio": descripcio,
        "foto": foto,
        "dificultat": dificultat,
        "tipus": tipus,
    };
}
