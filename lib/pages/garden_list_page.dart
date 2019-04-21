import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/garden_list_bloc.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/dialogs/new_garden_dialog.dart';
import 'package:garden_hero/models/garden.dart';
import 'package:garden_hero/garden/screens/plant_page.dart';
import 'package:garden_hero/pages/plant_list_page.dart';
class GardenListPage extends StatelessWidget {
  GardenListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
	      title: Text("Gardens",
			      style: TextStyle(
					      fontSize: 20,
					      color: Colors.white,
					      fontWeight: FontWeight.w600
			      )
	      ),
	      elevation: 0,
	      centerTitle: true,
      ),
      body: GardenListBody()
    );
  }
}

class GardenListBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ScaffoldState state = Scaffold.of(context);
    final GardenListBloc gardenListBloc = BlocProvider.of<GardenListBloc>(context);
    gardenListBloc.errorStream.listen((error) => gardenListBloc.showErrorSnackbar(error, state));

    return Container(
	    alignment: Alignment.center,
      decoration: BoxDecoration(
	      gradient: LinearGradient(
		      begin: Alignment.topCenter,
		      end: Alignment.bottomCenter,
		      stops: [0.4, 0.9],
		      colors: [
		        Theme.of(context).primaryColor,
			      Color.fromRGBO(28, 206, 100, 1)
		      ]
	      )
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("gardens")
                    .where("user", isEqualTo: gardenListBloc.user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                      return _buildList(context, gardenListBloc, snapshot);
                }),
            flex: 8,
          ),
          Padding(
	          padding: EdgeInsets.all(25),
            child: _buildIconButton(context, gardenListBloc),
          )
        ],
      ),
    );
}

  Widget _buildList(BuildContext context, GardenListBloc gardenListBloc, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildGardenWidget(context, gardenListBloc, snapshot, index);
      },
      itemCount: snapshot.data == null
          ? 0
          : snapshot.data.documents.length,
    );
  }
  
  Widget _buildGardenWidget(BuildContext context, GardenListBloc gardenListBloc, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    Garden garden = Garden.fromMap(snapshot.data.documents[index].data);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
          direction: DismissDirection.endToStart,
          dismissThresholds: {
            DismissDirection.endToStart : 0.7
          },
          background: stackBehindDismiss(),
          key: ObjectKey(snapshot.data.documents[index]),
          child: Card(
            elevation: 2.0,
            child: GestureDetector(
	            onTap: () {
	              print(garden.id+" is tapped");
                Navigator.push(
                  context, //push plant page.
                 // MaterialPageRoute(builder: (context) => new PlantPage(gardenId: garden.id,)),
                  MaterialPageRoute(builder: (context) =>
                    BlocProvider(
                    bloc: PlantListBloc(garden.id),
                    child: PlantListPage(gardenID: garden.id,),
                  )
                  ),
                );


	            },
              child: _buildGardenDisplay(context, garden, gardenListBloc)
            ),
          ),
          onDismissed: (direction) {
            gardenListBloc.inRemoveGarden.add(garden);
          },
        ),
    );
  }

  Widget _buildGardenDisplay(BuildContext context, Garden garden, GardenListBloc gardenListBloc) {
  	return ListTile(
		  leading: CircleAvatar(
			  backgroundColor: Color.fromRGBO(230, 31, 111,1),
			  child: Text(
				  garden.count.toString(),
				  style: TextStyle(
					  fontSize: 18,
					  fontWeight: FontWeight.w600,
					  color: Colors.white),
			  ),
		  ),
		  title: Text(garden.name,
			  style: TextStyle(
					  fontSize: 18.0,
					  fontWeight: FontWeight.w700,
					  color: Color.fromRGBO(28, 206, 100,1)
			  ),
		  ),
		  subtitle: Text(garden.description),
		  trailing: IconButton(
			  icon: Icon(Icons.edit),
			  color: Color.fromRGBO(239, 66, 136,1),
			  onPressed: () async {
				  Map<String, String> data = await showDialog(
					  context: context,
					  builder: (context) => NewGardenDialog(garden.name, garden.description),
				  );
				  gardenListBloc.inGardenToEdit.add(garden);
				  gardenListBloc.inEditGarden.add(data);
			  },
		  ),
	  );
  }


  Widget _buildIconButton(BuildContext context, GardenListBloc templateBloc) {
    return IconButton(
        icon: const Icon(
          Icons.add,
	        size: 40,
	        color: Color.fromRGBO(196, 251, 218,1),
        ),
        onPressed: () async {
          Map<String, String> data = await showDialog(
            context: context,
            builder: (context) => NewGardenDialog("", ""),
          );
          templateBloc.inAddGarden.add(data);
        }
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
