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
	    resizeToAvoidBottomPadding: false,
	    backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
	      backgroundColor: Color.fromRGBO(97, 235, 153, 1),
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
  Widget build(BuildContext mainContext) {
    final ScaffoldState state = Scaffold.of(mainContext);
    final GardenListBloc _bloc = BlocProvider.of<GardenListBloc>(mainContext);
    _bloc.errorStream.listen((error) => _bloc.showErrorSnackbar(error, state));

    return Container(
	    alignment: Alignment.center,
      decoration: BoxDecoration(
	      gradient: LinearGradient(
		      begin: Alignment.topCenter, end: Alignment.bottomCenter,
		      stops: [0.4, 0.9],
		      colors: [
		        Theme.of(mainContext).primaryColor,
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
              builder: (context, snapshot) {
              	if (snapshot.hasData) {
              		return  GardenList(snapshot.data.documents,_bloc);
	              }
              	return Container();
              }
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
  Widget build(BuildContext mainContext) {
	  return Container(
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
	    child: ListView.builder(
			  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
			  shrinkWrap: true,
			  itemBuilder: (mainContext, index) => GardenWidget(_bloc, _gardens, index),
			  itemCount: _gardens == null
				  ? 0
				  : _gardens.length,

	    ),
	  );
  }
}

class GardenWidget extends StatelessWidget {
	final GardenListBloc _bloc;
	final List<DocumentSnapshot> _gardens;
	final int _index;

	GardenWidget(this._bloc,  this._gardens, this._index);

	@override
  Widget build(BuildContext mainContext) {
		  Garden garden = Garden.fromMap(_gardens[_index].data);

		  return Padding(
			  padding: const EdgeInsets.only(bottom: 5),
			  child: Dismissible(
				  direction: DismissDirection.endToStart,
				  dismissThresholds: {DismissDirection.endToStart : 0.7},
				  background: stackBehindDismiss(),
				  key: ObjectKey(_gardens[_index]),
				  child: Card(
					  margin: EdgeInsets.symmetric(horizontal: 10),
					  child: GestureDetector(
							  onTap: () {
								  Navigator.push(mainContext, //push plant page.
									  MaterialPageRoute(builder: (context) =>
										  BlocProvider(
											  bloc: PlantListBloc(garden.id),
											  child: PlantListPage(gardenID: garden.id,),
										  )
									  ),
								  );
							  },
							  child: Column(
							    children: [
							    	Padding(
							    	  padding: const EdgeInsets.only(top: 10, left: 10.0),
							    	  child: ListTile(
									      leading: StreamBuilder<QuerySnapshot>(
											      stream: Firestore.instance
													      .collection('batch')
													      .where('garden', isEqualTo: garden.id).snapshots(),
											      builder: (context, snapshot) {
												      if (snapshot.data == null) {
													      return CircleAvatar(backgroundColor: Theme.of(context).accentColor, child: Text("0"),);
												      }

												      int count = 0;
												      for (DocumentSnapshot doc in snapshot.data.documents) {
												      	if (doc.data["count"] != null)
													        count += doc.data["count"].toInt();
												      }
												      return Padding(
													      padding: const EdgeInsets.only(top: 10, bottom: 25.0),
													      child: CircleAvatar(
														      radius: 22,
														      backgroundColor: Theme.of(context).accentColor,
														      child: Text(
															      "${count.toString()}",
															      style: TextStyle(
																	      fontSize: 18,
																	      fontWeight: FontWeight.w400,
																	      color: Colors.white),
														      ),
													      ),
												      );
											      }
									      ),
									  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
									  title: Text(garden.name,
										  style: TextStyle(
												  fontSize: 24.0,
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
												  context: mainContext,
												  builder: (mainContext) => NewGardenDialog(garden.name, garden.description),
											  );
											  _bloc.inGardenToEdit.add(garden);
											  _bloc.inEditGarden.add(data);
										  },
									  ),
								    ),
							    	),

					  ]
							  )
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
