import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/garden_list_bloc.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/dialogs/new_garden_dialog.dart';
import 'package:garden_hero/models/garden.dart';
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
    final GardenListBloc _bloc = BlocProvider.of<GardenListBloc>(context);
    _bloc.errorStream.listen((error) => _bloc.showErrorSnackbar(error, state));

    return Container(
	    alignment: Alignment.center,
      decoration: BoxDecoration(
	      gradient: LinearGradient(
		      begin: Alignment.topCenter, end: Alignment.bottomCenter,
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
                .where("user", isEqualTo: _bloc.user.uid)
                .snapshots(),
              builder: (context, snapshot) =>
	              GardenList(snapshot.data.documents,_bloc)
              ),
            flex: 8,
          ),
          Padding(
	          padding: EdgeInsets.all(25),
            child: AddButton(_bloc),
          )
        ],
      ),
    );
	}
}

class GardenList extends StatelessWidget {
	final List<DocumentSnapshot> _gardens;
	final GardenListBloc _bloc;

	GardenList(this._gardens, this._bloc);

  @override
  Widget build(BuildContext context) {
	  return ListView.builder(
		  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
		  shrinkWrap: true,
		  itemBuilder: (context, index) => GardenWidget(_bloc, _gardens, index),
		  itemCount: _gardens == null
			  ? 0
			  : _gardens.length,
	  );
  }
}

class GardenWidget extends StatelessWidget {
	final GardenListBloc _bloc;
	final List<DocumentSnapshot> _gardens;
	final int _index;

	GardenWidget(this._bloc,  this._gardens, this._index);

	@override
  Widget build(BuildContext context) {
		  Garden garden = Garden.fromMap(_gardens[_index].data);

		  return Padding(
			  padding: const EdgeInsets.only(bottom: 5),
			  child: Dismissible(
				  direction: DismissDirection.endToStart,
				  dismissThresholds: {DismissDirection.endToStart : 0.7},
				  background: stackBehindDismiss(),
				  key: ObjectKey(_gardens[_index]),
				  child: Card(
					  child: GestureDetector(
							  onTap: () {
								  Navigator.push(context, //push plant page.
									  MaterialPageRoute(builder: (context) =>
										  BlocProvider(
											  bloc: PlantListBloc(garden.id),
											  child: PlantListPage(gardenID: garden.id,),
										  )
									  ),
								  );
							  },
							  child: GardenDisplay(garden, _bloc)
					  ),
				  ),
				  onDismissed: (direction) => _bloc.inRemoveGarden.add(garden),
			  ),
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



class AddButton extends StatelessWidget {
	final GardenListBloc bloc;

	AddButton(this.bloc);

  @override
  Widget build(BuildContext context) {
	  return FloatingActionButton(
		  mini: true,
		  child:  Icon(Icons.add,
			  color: Colors.white,
		  ),
		  onPressed: () async {
			  Map<String, String> data = await showDialog(
				  context: context,
				  builder: (context) => NewGardenDialog("", ""),
			  );
			  bloc.inAddGarden.add(data);
		  }
	  );
  }
}



class GardenDisplay extends StatelessWidget {
	final Garden garden;
	final GardenListBloc _bloc;

	GardenDisplay(this.garden, this._bloc);

  @override
  Widget build(BuildContext context) {
	  return ListTile(
		  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
		  subtitle: Text(garden.description,
			  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
		  ),
		  trailing: IconButton(
			  icon: const Icon(Icons.edit, color: Color.fromRGBO(239, 66, 136,1),),
			  onPressed: () async {
				  Map<String, String> data = await showDialog(
					  context: context,
					  builder: (context) => NewGardenDialog(garden.name, garden.description),
				  );
				  _bloc.inGardenToEdit.add(garden);
				  _bloc.inEditGarden.add(data);
			  },
		  ),
	  );  }
}
