import 'dart:async';

import 'package:sqlcool/sqlcool.dart';

class DatabaseClient {
	static final DatabaseClient _database = DatabaseClient._internal();

	factory DatabaseClient() => _database;
	static 	Db _db;


	Future<Db> get db async {
		if (_db != null) {
			return _db;
		}
		return db_init();
	}

	DatabaseClient._internal() {
		db_init();
	}

	Future<Db> db_init() async {
		_db = Db();

		String dbpath = "data.sqlite";
		_db.init(path: dbpath, fromAsset: "assets/plantData.db", verbose: true)
			.catchError((e) {
				print("Error initializing the database; $e");
			});

		return db;
	}
}