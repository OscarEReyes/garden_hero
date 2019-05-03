
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/models/Batch.dart';
import 'package:garden_hero/models/db_client.dart';
import 'package:sqlcool/sqlcool.dart';

class PestDialog extends StatefulWidget {
	double numPlants = 1.0;
	String batchId;
	double count;
	PlantListBloc plantListBloc;

	PestDialog(this.batchId, this.count,this.plantListBloc);

	Map<String, dynamic> toMap() {
		Map<String,dynamic> data  ={
			'count': numPlants,
		};
		return data;
	}

	@override
	_NewPlantDialogState createState() => _NewPlantDialogState();
}

class _NewPlantDialogState extends State<PestDialog> {

	@override
	void initState() {
		// widget.d = widget.gardenID+widget.id.toString();
		super.initState();
//		max = widget.plantListBloc.getMax();
	}

	void _onChanged(double val) {
		setState(() {
			widget.numPlants = val;
		});
	}

	Widget _showBatch(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10.0),
			child: Column(
				children: <Widget>[
					Container(
						child: Slider(
							value: widget.numPlants,
							onChanged: (double val) => _onChanged(val),
							max: widget.count, min: 0,
							divisions: widget.count.toInt(),
							activeColor: Theme.of(context).accentColor,
							inactiveColor: Colors.white,
							label: widget.numPlants.toString(),
						),
					),
					Text("Count ",
						style: TextStyle(
								fontSize: 18,
								color: Theme.of(context).accentColor,
								fontWeight: FontWeight.w600
						),),
					Text("${widget.numPlants.round().toString()}",
						style: TextStyle(
								color: Colors.white,
								fontWeight: FontWeight.w600, fontSize: 40),
					),
				],
			),
		);
	}


	@override
	Widget build(BuildContext context) {
		ThemeData theme = Theme.of(context);

		return Container(
			alignment: Alignment.center,
			padding: EdgeInsets.fromLTRB(25, 25, 25, 120),
			child: Container(
				decoration: BoxDecoration(
						borderRadius: BorderRadius.all(Radius.circular(12)),
						gradient: LinearGradient(
								begin: Alignment.topCenter,
								end: Alignment.bottomCenter,
								stops: [0.2, 0.7],
								colors: [
									Color.fromRGBO(97, 235, 153, 0.9),
									Color.fromRGBO(28, 206, 100,.9),
								]
						)
				),
				child: Material(
					color: Colors.transparent,
					child: Form(
						child: Column(
							children: <Widget>[
								Padding(
										padding: const EdgeInsets.only(top: 25,bottom: 25),
										child: Text("Set Number of Plants with Pest",
											style: theme.textTheme.subhead
													.copyWith(color: Colors.white),)
								),
								_showBatch(context),
								Padding(
									padding: const EdgeInsets.all(10.0),
									child: RaisedButton(
										color: theme.accentColor,
										onPressed: () {
											widget.plantListBloc.handleSetSick(widget.numPlants, widget.batchId);
											Navigator.pop(context);
											},
										child: Text("Set", style: theme.textTheme.button),
									),
								),
							],
						)),
				),
			),
		);
	}
}





