import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/garden_list_bloc.dart';
import 'package:garden_hero/dialogs/new_garden_dialog.dart';
import 'package:garden_hero/models/garden.dart';

class GardenListPage extends StatelessWidget {
  GardenListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gardens"),),
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

    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 25.0),
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
            Expanded(
              child: _buildIconButton(context, gardenListBloc),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, GardenListBloc gardenListBloc, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
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

    return Dismissible(
      direction: DismissDirection.endToStart,
      dismissThresholds: {
        DismissDirection.endToStart : 0.7
      },
      background: stackBehindDismiss(),
      key: ObjectKey(snapshot.data.documents[index]),
      child: Container(
        child: GestureDetector(
          onLongPress: () {
            gardenListBloc.inRemoveGarden.add(garden);
          },
          child: Card(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0
              ),
              child: ListTile(
                title: Row (
                  children: <Widget>[
                    Text(garden.name,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    Expanded(
                      child: LimitedBox(),
                      flex: 1,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.black54,
                      onPressed: () async {
                          Map<String, String> data = await showDialog(
                            context: context,
                            builder: (context) => NewGardenDialog(garden.name, garden.description),
                          );
                          gardenListBloc.inGardenToEdit.add(garden);
                          gardenListBloc.inEditGarden.add(data);
                      },
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(garden.description,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Count: " + garden.count.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        gardenListBloc.inRemoveGarden.add(garden);
      },
    );
  }

  Widget _buildIconButton(BuildContext context, GardenListBloc templateBloc) {
    return IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.black,
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
