import 'package:kumpulin/models/img.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ImgDatabase {
  static final ImgDatabase instance = ImgDatabase._init();
  static Database? _database;
  static const imgTable = "imgTable";

  ImgDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('img_database.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const stringType = "VARCHAR NOT NULL";

    await db.execute(
        "CREATE TABLE imgTgitable (${ImgFields.id} $idType, ${ImgFields.img} $stringType, ${ImgFields.longitude} $stringType, ${ImgFields.latitude} $stringType, ${ImgFields.desc} $stringType)");
  }

  Future<List<Img>> listImg() async {
    final db = await instance.database;

    final query = await db.query(imgTable, orderBy: '${ImgFields.id} DESC');

    return query.map((json) => Img.fromJson(json)).toList();
  }

  Future<Img> addImg(Img image) async {
    final db = await instance.database;
    final query = await db.insert(imgTable, image.toJson());

    return image.copy(id: query);
  }

  Future<int> updateImg(Img image) async {
    final db = await instance.database;
    final query = await db.update(imgTable, image.toJson(),
        where: '${ImgFields.id} = ?', whereArgs: [image.id]);

    return query;
  }

  Future<Img> readImg(int id) async {
    final db = await instance.database;
    final query = await db.query(
      imgTable,
      columns: ImgFields.imgCol,
      where: '${ImgFields.id} = ?',
      whereArgs: [id],
    );

    if (query.isEmpty) {
      return Img.fromJson(query.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> deleteImg(int id) async {
    final db = await instance.database;
    final query = await db
        .delete(imgTable, where: '${ImgFields.id} = ?', whereArgs: [id]);

    return query;
  }

  Future<void> deleteAllImg() async {
    final db = await instance.database;

    await db.delete(imgTable);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
