import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:examen_final_negre/models/login_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database == null) _database = await initDB();

    return _database!;
  }

/**
 * Metode encarregat de inicialitzar la base de dades
 */
  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, 'Logins.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Logins(
            id INTEGER PRIMARY KEY,
            email TEXT,
            password TEXT
          )
        ''');
      },
    );
  }
/**
 * Metode encarregat de inserir un login
 */
  Future<int> insertRawLogin(LoginModel nouLogin) async {
    final id = nouLogin.id;
    final email = nouLogin.email;
    final password = nouLogin.password;

    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Logins(id, email, password)
      VALUES ($id, '$email', '$password')
    ''');
    return res;
  }

  Future<List<LoginModel>> getAllLogins() async {
    final db = await database;

    final res = await db.query('Logins');
    return res.isNotEmpty ? res.map((e) => LoginModel.fromMap(e)).toList() : [];
  }

  Future<LoginModel?> checkIsLogin() async {
    final db = await database;

    final res = await db.query('Logins');
    if(res.isNotEmpty){
      return LoginModel.fromMap(res.first);
    }else{
      return null;
    }
  }


/**
 * Mètode que retorna els scans depenet del id dins la base de dades
 */
  Future<LoginModel?> getLoginByEmail(int email) async {
    final db = await database;

    final res = await db.query('Logins', where: 'email = ?', whereArgs: [email]);

    if(res.isNotEmpty){
      return LoginModel.fromMap(res.first);
    }else{
      return null;
    }
  }
}