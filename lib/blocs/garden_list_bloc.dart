import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/models/db_client.dart';
import 'package:garden_hero/models/garden.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlcool/sqlcool.dart';

class GardenListBloc implements BlocBase {
  final FirebaseUser user;
  Garden _deletedGarden;
  Garden _gardenToEdit;
  final Set<Garden> _gardens = Set<Garden>();

  GardenListBloc(this.user) {
    _gardensAddController.listen(_handleAddGarden);
    _gardensEditController.listen(_editGardenHandle);
    _gardensRemoveController.listen(_handleRemoveGarden);
    _gardensUndoRemoveController.listen(_handleUndoRemoveGarden);
    _gardenToEditController.listen(_handleGardenEdit);
  }

  Garden gardenAt(int index) => _gardens.elementAt(index);

  /// Interface that allows to add a new garden
  BehaviorSubject<Map<String, String>> _gardensAddController = BehaviorSubject<Map<String, String>>();
  Sink<Map<String, String>> get inAddGarden=> _gardensAddController.sink;

  /// Interface that allows to edit existing garden
  BehaviorSubject<Map<String, String>> _gardensEditController = BehaviorSubject<Map<String, String>>();
  Sink<Map<String, String>> get inEditGarden=> _gardensEditController.sink;

  /// Interface that allows to set garden to edit
  BehaviorSubject<Garden> _gardenToEditController = BehaviorSubject<Garden>();
  Sink<Garden> get inGardenToEdit=> _gardenToEditController.sink;

  /// Interface that allows to remove a template from the list of gardens
  BehaviorSubject<Garden> _gardensRemoveController = BehaviorSubject<Garden>();
  Sink<Garden> get inRemoveGarden => _gardensRemoveController.sink;

  /// Interface that allows to undo remove garden
  BehaviorSubject<Garden> _gardensUndoRemoveController = BehaviorSubject<Garden>();
  Sink<Garden> get _inUndoRemoveGarden=> _gardensUndoRemoveController.sink;

  /// relays error information
  final _errorSubject = PublishSubject<String>();
  Sink<String> get errorSink =>   _errorSubject.sink;
  Stream<String> get errorStream => _errorSubject.stream;

  // -------------------- HANDLING ----------------------
  void _handleAddGarden(Map<String, String> data) async {
    if (data != null) {
      Garden garden = Garden(data["name"], data["description"], user.uid);
      _gardens.add(garden);
      DocumentReference id = await Firestore.instance
          .collection("gardens")
          .add(garden.toMap());
      garden.id = id.documentID;
      Firestore.instance
          .collection("gardens")
          .document(id.documentID)
          .updateData({"id" : id.documentID});
    }
  }

  void _handleGardenEdit(Garden garden) {
    _gardenToEdit = garden;
  }

  void _editGardenHandle(Map<String, String> data) async {
    if (data != null) {
      Firestore.instance
          .collection("gardens")
          .document(_gardenToEdit.id)
          .updateData(data);
    }
  }

  void _handleRemoveGarden(Garden garden) {
    _deletedGarden = garden;
    Firestore.instance
        .collection("gardens")
        .document(garden.id)
        .delete();
    errorSink.add("Garden " + garden.name + " deleted.");
  }

  void _handleUndoRemoveGarden(Garden garden) {
    Firestore.instance
        .collection("gardens")
        .document(_deletedGarden.id)
        .setData(_deletedGarden.toMap());
  }

  void showErrorSnackbar(String event, ScaffoldState state) {
    state.showSnackBar(
        SnackBar(content: Text(event),
            action: SnackBarAction(
                label: "UNDO",
                onPressed: () {
                  _inUndoRemoveGarden.add(_deletedGarden);
                })
        )
    );
    sleep1().then((value) {
	    state.removeCurrentSnackBar();
    });
  }

  Future sleep1() {
	  return new Future.delayed(const Duration(seconds: 2), () => "1");
  }


  void dispose(){
    _gardensAddController.close();
    _gardensRemoveController.close();
  }
}