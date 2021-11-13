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
        "CREATE TABLE imgTable (${ImgFields.id} $idType, ${ImgFields.img} $stringType, ${ImgFields.imgPath} $stringType, ${ImgFields.longitude} $stringType, ${ImgFields.latitude} $stringType, ${ImgFields.desc} $stringType, ${ImgFields.timeStamps} $stringType)");
  }

  Future<List<Img>> index() async {
    final db = await instance.database;

    final query =
        await db.query(imgTable, orderBy: '${ImgFields.timeStamps} DESC');

    return query.map((json) => Img.fromJson(json)).toList();
  }

  Future<Img> store(Img image) async {
    final db = await instance.database;
    final query = await db.insert(imgTable, image.toJson());

    return image.copy(id: query);
  }

  Future<Img> show(int id) async {
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

  Future<int> update(Img image) async {
    final db = await instance.database;
    final query = await db.update(imgTable, image.toJson(),
        where: '${ImgFields.id} = ?', whereArgs: [image.id]);

    return query;
  }

  Future<int> destroy(int id) async {
    final db = await instance.database;
    final query = await db
        .delete(imgTable, where: '${ImgFields.id} = ?', whereArgs: [id]);

    return query;
  }

  Future<void> destroyAll() async {
    final db = await instance.database;

    await db.delete(imgTable);
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}
