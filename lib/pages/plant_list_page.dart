import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/dialogs/death_dialog.dart';

import 'package:garden_hero/dialogs/info_dialog.dart';
import 'package:garden_hero/dialogs/pest_dialog.dart';
import 'package:garden_hero/models/Batch.dart';

class PlantListPage extends StatelessWidget {
  final String gardenID;
  PlantListPage({this.gardenID});

  @override
  Widget build(BuildContext context) {
  	TextStyle style = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
	      backgroundColor: Color.fromRGBO(97, 235, 153, 1),
        centerTitle: true,
        elevation: 0,
        title: Text("Plants", style: style.copyWith(color: Colors.white)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: PlantListBody(gardenID: gardenID)
    );
  }
}

class PlantListBody extends StatelessWidget {
  final gardenID;

  InfoDialog infoDialog = new InfoDialog();

  PlantListBody({this.gardenID});

  @override
  Widget build(BuildContext context) {
    final PlantListBloc plantListBloc = BlocProvider.of<PlantListBloc>(context);
    return Container(
	    alignment: Alignment.center,
	    decoration: BoxDecoration(
		    gradient: LinearGradient(
			    begin: Alignment.topCenter,
			    end: Alignment.bottomCenter,
			    stops: [0.1, 0.9],
				    colors: [
					    Color.fromRGBO(97, 235, 153, 1),
					    Color.fromRGBO(28, 206, 100,1),
				    ]
		    )
	    ),
      child: Column(
        children: <Widget>[
	        Container(
		        alignment: Alignment.topRight,
			        child: _buildIconButton(context, plantListBloc)),
	        Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                .collection("batch")
                .where("garden", isEqualTo: gardenID)
                .snapshots(),
              builder: (context, snapshot) {
              	if (snapshot.data == null) {
              		return Container();
	              }
              	if (snapshot.data.documents.isEmpty) {
              		return Padding(
              		  padding: EdgeInsets
			                .only(
					                top: MediaQuery.of(context).size.height * 0.35
			                ),
              		  child: Text("Add a Plant",
			                style: TextStyle(color: Colors.white, fontSize: 32),
		                ),
              		);
	              }
	              return _buildBatchList(context, plantListBloc, snapshot);
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, PlantListBloc plantListBloc) {
	  return Padding(
	    padding: const EdgeInsets.symmetric(horizontal: 10.0),
	    child: FloatingActionButton(
			  child:  Icon(Icons.add,
				  size: 32,
				  color: Colors.white,
			  ),
			  onPressed: () async {
				  plantListBloc.handleAddBatch(context);

			  }
	    ),
	  );

  }

  Widget _buildBatchList(BuildContext context, PlantListBloc plantListBloc,
      AsyncSnapshot<QuerySnapshot> snapshot) {

	  return CarouselSlider(
			  items: snapshot.data.documents.map((DocumentSnapshot doc) {
				  return _buildBatchTile(context, plantListBloc, doc);
			  }).toList(),
			  height: 450.0,
	  );


  }

  Widget _buildBatchTile(BuildContext context, PlantListBloc plantListBloc,
      DocumentSnapshot doc) {
		ThemeData theme = Theme.of(context);

		Map<String, int> waterForPlant = {
			"basil" : 8,
			"potatoes" : 1,
			"onions" : 1,
			"carrots" : 1,
			"tomatoes" : 4,
			"watermelons" : 55,
			"lemons-oranges" : 55
		};

    Map<String, dynamic> batchData = doc.data;

		int healthy = batchData["count"].round();

		if (batchData["pest"] != null) {
			healthy -=  batchData["pest"].round();
		}

    String str = "";
    DateTime date = batchData["date"];
    if (date != null){
      str = "${date.month.toString()}/${date.day.toString()}/${date.year.toString()}";
    }else{
      str = "empty";
    }
    return GestureDetector(
	    onTap: () {
	    	plantListBloc.handleGoToInfoPage(context,
			    doc.data["plantType"]
		    );
	    },
      child: Card(
	    margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
	            Container(
		            alignment: Alignment.topRight,
	              child: IconButton(
		            onPressed: () => plantListBloc.inBatchRemove.add(batchData),
		            icon: Icon(Icons.close, color: Colors.red,),
	              ),
	            ),
	            Padding(
	              padding: const EdgeInsets.only(bottom: 10.0),
	              child: Text("${batchData["plantType"].toString().toUpperCase()}",
		            style: theme.textTheme.subhead.copyWith(fontSize: 32, color: theme.accentColor),
		            textAlign: TextAlign.center,
	              ),
	            ),
	          Text("Planted On: $str",
		          style: TextStyle(
			          fontStyle: FontStyle.italic,
			          fontSize: 18,
			          fontWeight: FontWeight.w100
		          ),
	          ),
	            Padding(
	              padding: const EdgeInsets.only(top: 10.0),
	              child: Text("Water given this week"),
	            ),
	            Text("${waterForPlant[batchData["plantType"].toString()]} ounces required"),
	            Slider(
		            value: batchData["water"].toDouble(),
		            label: batchData["water"].toString(),
		            min: 0,
		            max: waterForPlant[batchData["plantType"].toString().trim()].toDouble(),
		            divisions: waterForPlant[batchData["plantType"]] > 10 ? 10 : waterForPlant[batchData["plantType"]],
		            onChanged: (double value) {plantListBloc.handleWater(value, batchData["id"]);},
	            ),
	            Text("${batchData["water"]} fluid ounces per plant"),
	            Row(
		            mainAxisAlignment: MainAxisAlignment.center,
		            children: <Widget>[
		            	Padding(
		            	  padding: const EdgeInsets.all(10.0),
		            	  child: Column(
				            crossAxisAlignment: CrossAxisAlignment.center,
				            children: <Widget>[
				            	Text("Healthy Plants",
						            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
					            Text(healthy.toString(),
						            style: theme.textTheme.body1.copyWith(
								            color: theme.accentColor,
								            fontSize: 40
						            ),
					            ),
				            ],
			            ),
		            	),
			            Padding(
			              padding: const EdgeInsets.all(10.0),
			              child: (batchData["pest"] != null && batchData["pest"] > 0 )
					            ? Column(children: <Widget>[
							            Text("Diseased Plants",
									            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
							            Text(batchData["pest"].round().toString(),
								            style: theme.textTheme.body1.copyWith(
										            color: theme.accentColor,
										            fontSize: 40
								            ),
							            )
						            ],
						            )
						            : Container(width: 0),
			            ),
		            ],
	            ),
	            Padding(
	              padding: const EdgeInsets.all(15.0),
	              child: Row(
		              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			            children: <Widget>[
			              RaisedButton(
			                onPressed: () {
			                  showDialog(context: context,builder: (context) {
						              return PestDialog(batchData["id"],
							              batchData["count"],
							              plantListBloc
						              );
				                });
		                   },
			                child: SizedBox(
					              height: 40,
					              width: 75,
			                  child: Row(
					                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					                children: <Widget>[
					                  Icon(Icons.bug_report, color: theme.accentColor,),
					                  Text("Pest", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800),)],
				                )
			                ),
			              ),

				            RaisedButton(
					            onPressed: () {
					              double pest = batchData["pest"] != null ? batchData["pest"] : 0;
						            double death = batchData["death"] != null ? batchData["death"] : 0;

						            showDialog(context: context,builder: (context) {
							            return DeathDialog(batchData["id"],
									            batchData["count"],
									            pest,
									            death,
									            plantListBloc
							            );
						            });
					            },
					            child: SizedBox(
							            height: 40,
							            width: 75,
							            child: Row(
								            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								            children: <Widget>[
									            Icon(Icons.delete_outline, color: theme.accentColor,),
									            Text("Death", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800),)],
							            )
					            ),
				            )
			            ],
	              ),
	            )
          ],
        ),
      ),
    );

  }
}



