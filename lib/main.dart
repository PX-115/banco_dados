import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main()=> runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
));

class Home extends StatefulWidget {
  const Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, 'banco.db');

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = 'CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)';
        db.execute(sql);
      }
    );

    return bd;
  }

  _salvar () async {

    Database bd = await _recuperarBancoDados();

    Map <String, dynamic> dadosUsuario = {
      'nome': 'Chihiro Ayasato',
      'idade': 27
    };
    int id = await bd.insert('usuarios', dadosUsuario);
    print('Salvo: $id');
  }

  _listarUsuarios () async {

    Database bd = await _recuperarBancoDados();

    //String filtro = 'ni';
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%'";
      String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY(id) ASC";

    List usuarios = await bd.rawQuery(sql);

    for (var usuario in usuarios){
      print(
        'ID: ' + usuario['id'].toString() + 
        ' / Nome: ' + usuario['nome'] + 
        ' / Idade: ' + usuario['idade'].toString()
      );
    }
  }

  _listarUsuariosPeloID (int id) async {
    
    Database bd = await _recuperarBancoDados();

    List usuarios = await bd.query(
      'usuarios',
      columns: ['id', 'nome', 'idade'],
      where: 'id = ?',
      whereArgs: [id]
    );

    for (var usuario in usuarios){
      print(
        'ID: ' + usuario['id'].toString() +
        ' / Nome: ' + usuario['nome'] +
        ' / Idade: ' + usuario['idade'].toString()
      );
    }

  }

  _excluirUsuario (int id) async {

    Database bd = await _recuperarBancoDados();

    bd.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id]
    );

    _listarUsuarios();
  }

  _atualizarUsuario(int id) async {
  
    Database db = await _recuperarBancoDados();
  
    Map<String, dynamic> dadosUsuario = {
      'nome' : 'Mia Fey',
    };

    db.update(
      'usuarios',
      dadosUsuario,
      where: 'id = ?',
      whereArgs: [id]
    );

  }

  @override
  Widget build(BuildContext context) {

    //_salvar();
    //_atualizarUsuario(13);
    _listarUsuarios();
    //_listarUsuariosPeloID(6);
    //_excluirUsuario();

    return Container(
      
    );
  }
}