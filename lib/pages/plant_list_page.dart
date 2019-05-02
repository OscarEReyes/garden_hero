import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/blocs/plant_page.bloc.dart';
import 'package:garden_hero/dialogs/add_plant_dialog.dart';
import 'package:garden_hero/dialogs/info_dialog.dart';
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                .collection("batch")
                .where("garden", isEqualTo: gardenID)
                .snapshots(),
              builder: (context, snapshot) {
              	if (snapshot == null) {
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
          Container(child: _buildIconButton(context, plantListBloc)),
        ],
      ),
    );
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
            plantListBloc.handleAddBatch(context);
          }),
    );
  }

  Widget _buildBatchList(BuildContext context, PlantListBloc plantListBloc,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildBatchTile(context, plantListBloc, snapshot, index);
      },
      itemCount: snapshot.data == null ? 0 : snapshot.data.documents.length,
    );


  }

  Widget _buildBatchTile(BuildContext context, PlantListBloc plantListBloc,
      AsyncSnapshot<QuerySnapshot> snapshot, int index) {

		ThemeData theme = Theme.of(context);

    Map<String, dynamic> test = snapshot.data.documents[index].data;
    String str = "";
    DateTime date = test["date"];
    if (date != null){
      str = "${date.month.toString()}/${date.day.toString()}/${date.year.toString()}";
    }else{
      str = "empty";
    }
    return GestureDetector(
	    onTap: () {
	    	plantListBloc.handleGoToInfoPage(context, snapshot.data.documents[index].data["plantType"]);
	    },
      child: Card(
	    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            	Row(
		          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
		          children: <Widget>[
		          	Expanded(flex: 1, child: CircleAvatar(
				          radius: 25,
				          backgroundColor: theme.accentColor,
				          child: Text("x" + test["count"].round().toString(),
				            style: theme.textTheme.body1.copyWith(
						            color: Colors.white,
					            fontSize: 18
				            ),
				          ),
			          )),
			          Expanded(
				          flex: 4,
			            child: Text("${test["plantType"].toString().toUpperCase()}",
				          style: theme.textTheme.subhead.copyWith(fontSize: 24, color: theme.accentColor),
				            textAlign: TextAlign.center,
			            ),
			          ),
			          Expanded(
				          flex: 1,
			            child: IconButton(
					          onPressed: () => plantListBloc.inBatchRemove.add(test),
					          icon: Icon(Icons.close, color: Colors.red,),
			            ),
			          ),
		          ],
	          ),
	          Text("Batch: $str",
		          style: TextStyle(
			          fontStyle: FontStyle.italic,
			          fontWeight: FontWeight.w400
		          ),
	          ),
              Text(test["phase"]),
            ],
          ),
        ),
      ),
    );

  }
}
