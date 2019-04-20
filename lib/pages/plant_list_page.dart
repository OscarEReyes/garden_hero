import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/dialogs/add_plant_dialog.dart';
import 'package:garden_hero/dialogs/info_dialog.dart';
import 'package:garden_hero/models/Batch.dart';

class PlantListPage extends StatelessWidget {
  final String gardenID;
  PlantListPage({this.gardenID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Plants"),
        ),
        body: PlantListBody(
          gardenID: gardenID,
        ));
  }
}

class PlantListBody extends StatelessWidget {
  final Map<String, int> initMap = {"apples": 0, "pears": 0, "oranges": 0};
  final gardenID;
  int _batchCount =0;

  InfoDialog infoDialog = new InfoDialog();

  PlantListBody({this.gardenID});

  @override
  Widget build(BuildContext context) {
    final PlantListBloc plantListBloc = BlocProvider.of<PlantListBloc>(context);

    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("batch")
                    .where("garden", isEqualTo: gardenID)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
            return _buildBatchList(context, plantListBloc, snapshot);
                },
              ),
            ),
            Container(child: _buildIconButton(context, plantListBloc)),
          ],
        ),
      ),
    );
  }

/*  void initPlantDatabase(PlantListBloc plantListBloc) {
    List<String> i = new List(initMap.length);
    i.fillRange(0, i.length, "planted");
    Map<String, String> phase = Map.fromIterables(initMap.keys, i);
    Map<String, dynamic> data = {
      'garden': gardenID,
      'phase': phase,
      'plantTypes': initMap,
      'watered': initMap,
      'diseased': initMap
    };
    plantListBloc.initPlant.add(data);
  }*/
void initPlantDatabase(PlantListBloc plantListBloc)async{

}

  Widget _buildIconButton(BuildContext context, PlantListBloc plantListBloc) {
    return Container(
      child: IconButton(
          padding: const EdgeInsets.only(bottom: 20),
          alignment: Alignment.bottomCenter,
          icon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () async {
            _batchCount ++;
            Map<String, dynamic> data = await showDialog(
                context: context,
                builder: (context) => AddPlantDialog(
                      plantListBloc: plantListBloc,
                      gardenID: gardenID,
                      id: _batchCount,
                    ));

            print("batchCount:\t$_batchCount");
          }),
    );
  }

  Widget _buildBatchList(BuildContext context, PlantListBloc plantListBloc,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        //call batch tile
        return _buildBatchTile(context, plantListBloc, snapshot, index);
      },
      itemCount: snapshot.data == null ? 0 : snapshot.data.documents.length,
    );


  }

  Widget _buildBatchTile(BuildContext context, PlantListBloc plantListBloc,
      AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    Map<String, dynamic> test = snapshot.data.documents[index].data;
    String str = "";
    DateTime date = test["date"];
    _batchCount = snapshot.data.documents.length;
    if(date != null){
      str = "${date.month.toString()}/${date.day.toString()}/${date.year.toString()}";
    }else{
      str = "empty";
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Text(test["id"].toString()),
              ),
              Text(test["plantType"]),
              Text(test["count"].toString()),
              Text(test["phase"]),
              Text(str),
              IconButton(
                onPressed: (){
                  plantListBloc.inBatchRemove.add(test);
                },
                icon: Icon(Icons.close,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
