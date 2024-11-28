// ignore_for_file: constant_identifier_names

import 'package:cart_sqflite_provider/modal/cart_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DBHelper {
  // Private constructor for singleton pattern
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();

  Database? _database;

  static const String TABLE_NAME = "cart";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PRODUCT_ID = "productId";
  static const String COLUMN_PRODUCT_NAME = "productName";
  static const String COLUMN_INITIAL_PRICE = "initialPrice";
  static const String COLUMN_PRODUCT_PRICE = "productPrice";
  static const String COLUMN_QUANTITY = "quantity";
  static const String COLUMN_UNIT_TAG = "unitTag";
  static const String COLUMN_IMAGE = "image";

  // Database getter
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> initializeDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cartDb.db');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  // Create table
  Future<void> _onCreate(Database database, int version) async {
    await database.execute(
      '''
      CREATE TABLE $TABLE_NAME(
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COLUMN_PRODUCT_ID VARCHAR UNIQUE, 
        $COLUMN_PRODUCT_NAME TEXT, 
        $COLUMN_INITIAL_PRICE INTEGER, 
        $COLUMN_PRODUCT_PRICE INTEGER, 
        $COLUMN_QUANTITY INTEGER, 
        $COLUMN_UNIT_TAG TEXT, 
        $COLUMN_IMAGE TEXT
      )
      ''',
    );
  }

  // Insert data into the table
  Future<CartModel> insert(CartModel cart) async {
    final db = await database;
    try {
      await db.insert(
        TABLE_NAME,
        cart.toMap(),

        conflictAlgorithm: ConflictAlgorithm
            .replace, // Replace if the product ID already exists
      );
    } catch (e) {
      print('Insert Error: $e');
    }
    return cart;
  }

  // Fetch all cart items
  Future<List<CartModel>> fetchCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

    return List.generate(
      maps.length,
      (i) => CartModel.fromMap(maps[i]),
    );
  }

  // Update cart item
  Future<int> updateCartItem(CartModel cart) async {
    final db = await database;
    return await db.update(
      TABLE_NAME,
      cart.toMap(),
      where: '$COLUMN_PRODUCT_ID = ?',
      whereArgs: [cart.productId],
    );
  }

  // Delete cart item
  Future<int> deleteCartItem(String productId) async {
    final db = await database;
    return await db.delete(
      TABLE_NAME,
      where: '$COLUMN_PRODUCT_ID = ?',
      whereArgs: [productId],
    );
  }

  // Clear the entire cart
  Future<int> clearCart() async {
    final db = await database;
    return await db.delete(TABLE_NAME);
  }
}
