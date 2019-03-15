import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/garden_list_bloc.dart';

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

                        Map<String, int> plantTypes =
                            Map.from(snapshot.data.documents[0]['plantTypes']);

                        List<String> keys = List.of(plantTypes.keys);
                        if (snapshot.hasData) {
                          return GridView.count(
                            crossAxisCount: 2,
                            children: List.generate(plantTypes.length, (index) {
                              return Card(
                                elevation: 4.0,
                                  child: Text("type: " + keys[index] + "\tcount: " +
                                      plantTypes[keys[index]].toString()));
                            }),
                          );

                        } else
                          return new Text("Error...");
                        // return _buildList(context, snapshot,plantListBloc);
                      }),
                  flex: 8,
                ),
              ],
            ),
          ),
    );
  }

 /* Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildPlantWidget(context, snapshot, index);
      }
    );
  }
  Widget _buildPlantWidget(AsyncSnapshot<QuerySnapshot> snapshot) {
    //   Plant plant = Plant.fromMap(snapshot.data.documents[index]);
    return Card(
      child: InkWell(
        child: Text(snapshot.data.documents[0]['plantTypes'][0]),
      ),
    );
  }*/
}
