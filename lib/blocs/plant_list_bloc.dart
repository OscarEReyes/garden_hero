import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garden_hero/dialogs/add_plant_dialog.dart';
import 'package:garden_hero/models/db_client.dart';
import 'package:garden_hero/models/plant.dart';
import 'package:garden_hero/pages/plant_info_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlcool/sqlcool.dart';

class PlantListBloc implements BlocBase{
  List<Map<String,dynamic>> batchList;
  Map<String,dynamic> deletedBatch;
  String gardenID ;
  final List<Plant> _plantList = List();
  final Map<String,int> initMap = {"apples":0,"pears":0,"oranges":0};
  DocumentReference documentReference = Firestore.instance
      .collection("plants").document();

  PlantListBloc(this.gardenID){
  //  _plantListInitController.listen(_initPlantDb);

    _batchListController.listen(_setBatch);
    _handleBatchRemoveController.listen(_handleRemoveBatch);
    _handleUndoBatchRemoveController.listen(_handleUndoRemove);
  }
 // BehaviorSubject<Map<String,dynamic>> _plantListInitController = BehaviorSubject();
 // Sink<Map<String,dynamic>>get initPlant=> _plantListInitController.sink;

  BehaviorSubject<Map<String,dynamic>> _batchListController = BehaviorSubject();
  Sink<Map<String,dynamic>>get inBatch=> _batchListController.sink;

  BehaviorSubject<Map<String,dynamic>> _handleBatchRemoveController = BehaviorSubject();
  Sink<Map<String,dynamic>>get inBatchRemove=> _handleBatchRemoveController.sink;

  BehaviorSubject<Map<String,dynamic>> _handleUndoBatchRemoveController = BehaviorSubject();
  Sink<Map<String,dynamic>>get inUndoRemove=> _handleUndoBatchRemoveController.sink;


  @override
  void dispose() {
    // TODO: implement dispose
   // _plantListInitController.close();
  }

  void disposeControllers() {
   // _plantListInitController.close();
    _batchListController.close();
  }

  Future<bool> hasPlantData(String garden) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('plants')
        .where('garden', isEqualTo: garden)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1){
      return true;
    }
    return false;
  }
  Future<bool> hasBatchData(String garden) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('batch')
        .where('garden', isEqualTo: garden)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1){
      return true;
    }
    return false;
  }

  void _initPlantDb(Map<String, dynamic> data) async {
    bool b = await hasPlantData(gardenID);
   // print("initPlantDb called!!!!! \t garden: "+gardenID+"\thasData: "+b.toString());
    if(data != null && (!b)){
      Firestore.instance.collection("plants").document().setData(data);
    }
  }

  void _setBatch(Map<String, dynamic> data) async{
    bool b = await hasBatchData(gardenID);
    //keep b for debug rn.
    if (data != null ){
    	String id = gardenID + DateTime.now().millisecondsSinceEpoch.toString();
    	data["id"] = id;
      Firestore.instance.collection("batch")
        .document(id)
        .setData(data);
    }
  }
  void handleGoToInfoPage(BuildContext context, String name) {
	  DatabaseClient db = DatabaseClient();
	  String query = "name LIKE '%${name}%'";
	  db.db.then((Db d) {
		  d.select(table: "plant", limit: 1, where: query).then((
				  List<Map<String, dynamic>> data) {
		  	    MaterialPageRoute route = MaterialPageRoute(
				      builder: (context) {
				      	return PlantInfoPage(data[0]);
				      }
			      );
			      Navigator.of(context).push(route);
		  });
	  });
  }

  void handleAddBatch(BuildContext context) async {
  	List<String> _types = [];
    DatabaseClient db = DatabaseClient();
    db.db.then((Db d) {
      d.select(table: "plant", columns: "name", limit: 20).then((List<Map<String, dynamic>> data) {
        for (Map<String, dynamic> thing in data) {
          _types.add(thing["name"]);
        }
        showDialog(
		        context: context,
		        builder: (context) => AddPlantDialog(
				        gardenID,
				        this,
				        _types
		        ));
      });
      });


  }

  void _handleRemoveBatch(Map<String,dynamic> batch) async {
    await Firestore.instance.collection("batch").document(batch["id"]).delete();
//    print("batch:\t${batch["id"].toString()} removed from $gardenID");
  }

  void _handleUndoRemove(Map<String, dynamic> data) {

  }
}