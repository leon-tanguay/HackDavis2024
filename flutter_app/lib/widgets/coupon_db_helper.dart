import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'coupon.dart'; // Assuming Coupon class is defined in coupon.dart

class CouponDatabaseHelper {
  static Future<String> _getDatabasePath() async {
    // Get the directory for storing databases
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final databasePath = join(appDocumentDir.path, 'coupon_database.db');
    return databasePath;
  }

  static Future<Database>_openDatabase() async {
    final databasePath = await _getDatabasePath(); // Get the database path
    return openDatabase(
      databasePath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE coupons(id INTEGER PRIMARY KEY, code TEXT, description TEXT, restaurantID INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertCoupon(Coupon coupon) async {
    final Database db = await _openDatabase();
    await db.insert(
      'coupons',
      coupon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Coupon>> getCoupons() async {
    final Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query('coupons');

    return List.generate(maps.length, (i) {
      return Coupon(
        id: maps[i]['id'],
        code: maps[i]['code'],
        description: maps[i]['description'],
        restaurantID: maps[i]['restaurantID'],
      );
    });
  }

  static Future<void> deleteCoupon(int id) async {
    final Database db = await _openDatabase();
    await db.delete(
      'coupons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}