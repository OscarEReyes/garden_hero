import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garden_hero/models/Batch.dart';
import 'package:garden_hero/models/plant.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/models/garden.dart';
import 'package:rxdart/rxdart.dart';
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

  void _initPlantDb(Map<String, dynamic> data) async{
    bool b = await hasPlantData(gardenID);
   // print("initPlantDb called!!!!! \t garden: "+gardenID+"\thasData: "+b.toString());
    if(data != null && (!b)){
      Firestore.instance.collection("plants").document().setData(data);
      print("document aded!!"+data.toString());
    }
  }

  void _setBatch(Map<String, dynamic> data) async{
    bool b = await hasBatchData(gardenID);
    //keep b for debug rn.
    if(data != null ){
      Firestore.instance.collection("batch").document().setData(data);
      print("document aded!!"+data.toString());
      print("batch list length: "+batchList.length.toString());
    }
  }

  void _handleRemoveBatch(Map<String,dynamic> batch)async{
    deletedBatch = batch;
    await Firestore.instance.collection("batch").document("-LZpceZqCXiq5i5QSTMP2").delete();
    print("batch:\t${batch["id"].toString()} removed from $gardenID");
  }

  void _handleUndoRemove(Map<String, dynamic> data) {

  }
}