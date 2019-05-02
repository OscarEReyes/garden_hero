

import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/models/db_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlcool/sqlcool.dart';

class PlantPageBloc implements BlocBase {
	@override
	void dispose() {
		// TODO: implement dispose
		// _plantListInitController.close();
	}

	final Map<String, dynamic> data;

	PlantPageBloc(this.data) {

	}

	BehaviorSubject<Map<String,dynamic>> _batchListController = BehaviorSubject();
	Sink<Map<String,dynamic>>get inBatch=> _batchListController.sink;

}