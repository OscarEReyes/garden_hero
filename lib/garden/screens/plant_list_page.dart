import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/dialogs/info_dialog.dart';
import 'package:garden_hero/models/plant.dart';

class PlantListPage extends StatelessWidget {
  final String gardenId;

  PlantListPage({this.gardenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("plants"),
      ),
      body: PlantListBody(
        gardenId: gardenId,
      ),
    );
  }
}

class PlantListBody extends StatelessWidget {
  final String gardenId;
  Map<String, dynamic> plantType;
  Map<String, dynamic> watered;
  Map<String, dynamic> diseased;
  Map<String, dynamic> phase;
  List<String> keys;
  int total =0;
  InfoDialog dialog = new InfoDialog();
  PlantListBody({this.gardenId});
  @override
  Widget build(BuildContext context) {

    return  Center(
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("plants")
                          .where("garden", isEqualTo: gardenId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                      //=========================maps
                        plantType =
                            Map.from(snapshot.data.documents[0]['plantTypes']);

                       watered  =Map.from(snapshot.data.documents[0]['watered']);

                       diseased  = Map.from(snapshot.data.documents[0]['diseased']);

                       phase = Map.from(snapshot.data.documents[0]['phase']);

                         keys = List.of(plantType.keys);
                        //all maps have same keys


                        if (snapshot.hasData) {
                          _buildList();
                          return GridView.count(
                              crossAxisCount: 4,
                            children: List.generate(_buildList().length, (index){

                              return GestureDetector(
                                child: _buildList()[index].toCard(),
                                onTap: (){
                                  dialog.information(context, _buildList()[index].type+" info","static plant information",_buildList()[index].toCard());
                                },
                              );
                            }),
                          );
                        } else
                          return new Text("Error...");

                      }),
                  flex: 8,
                ),
              ],
            ),
          ),
    );
  }


  List<Plant> _buildList () {
    int total = 0;
    plantType.forEach((String,V){
      total += plantType[String];
    });
    //print("the total is: "+total.toString());
    List<Plant> list =new List();
   for(int i = 0; i<keys.length;i++){
     String type = keys[i];
     int numPlant = plantType[type];
      String ph = phase[type];
      int numWatered = watered[type];
      int numDis = diseased[type];

      for(int n=0;n<numPlant;n++){
      bool watered = n<numWatered?true:false;
      bool dis = n<numDis?true:false;
      
        Plant p = Plant(
          type: type,
          phase: ph,
          watered: watered,
          diseased: dis
        );
        list.add(p);
      }
   }
   this.total = total;
   return list;
  /* int i =1;
    list.forEach((V){
      print("plant: "+i.toString()+" "+V.toString());
      i++;
    });*/

   
  }
}
