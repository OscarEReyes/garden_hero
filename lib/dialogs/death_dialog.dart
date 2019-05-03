
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';


class DeathDialog extends StatefulWidget {
	double numDeath = 0.0;
	double numDeathByPest = 0;
	String batchId;
	double pest;
	double count;
	double death;
	PlantListBloc plantListBloc;

	DeathDialog(this.batchId, this.count, this.pest, this.death,this.plantListBloc);

	@override
	_NewPlantDialogState createState() => _NewPlantDialogState();
}

class _NewPlantDialogState extends State<DeathDialog> {

	@override
	void initState() {
		// widget.d = widget.gardenID+widget.id.toString();
		super.initState();
//		max = widget.plantListBloc.getMax();
	}

	void _onChanged(double val) {
		if (widget.numDeathByPest > (widget.count - val)) {
			setState(() {
				double dif = widget.numDeathByPest -  (widget.count - val) ;
				widget.numDeathByPest -= dif;
			});
		}
		setState(() {
			if (val <= widget.count) {
				widget.numDeath = val;
			}
		});
	}

	void _onChangedByPest(double val) {
		setState(() {
			widget.numDeathByPest = val;
		});
	}

	Widget _showBatch(BuildContext context) {
		print((widget.count - widget.numDeath).round());
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 10.0),
			child: Column(
				children: <Widget>[
					Container(
						child: Slider(
							value: widget.numDeath,
							onChanged: (double val) => _onChanged(val),
							max: widget.count, min: 0,
							divisions: widget.count.toInt(),
							activeColor: Theme.of(context).accentColor,
							inactiveColor: Colors.white,
							label: widget.numDeath.toString(),
						),
					),
					Text("Death By Other Causes ",
						style: TextStyle(
								fontSize: 18,
								color: Theme.of(context).accentColor,
								fontWeight: FontWeight.w600
						),),
					Text("${widget.numDeath.round().toString()}",
						style: TextStyle(
								color: Colors.white,
								fontWeight: FontWeight.w600, fontSize: 40),
					),



					widget.numDeath < widget.count
						? Container(
								child: Slider(
									value: widget.numDeathByPest,
									onChanged: (double val) => _onChangedByPest(val),
									max: (widget.count - widget.numDeath).round().toDouble(), min: 0,
									divisions: widget.count.toInt() - widget.numDeath.toInt(),
									activeColor: Theme.of(context).accentColor,
									inactiveColor: Colors.white,
									label: widget.numDeathByPest.toInt().toString(),
								),
							)
						: Container(),
					widget.numDeath < widget.count
						? Text("Death By Pest",
							style: TextStyle(
									fontSize: 18,
									color: Theme.of(context).accentColor,
									fontWeight: FontWeight.w600
							),)
						: Container(),
					widget.numDeath < widget.count
						? Text("${widget.numDeathByPest.round().toString()}",
							style: TextStyle(
									color: Colors.white,
									fontWeight: FontWeight.w600, fontSize: 40),
						)
					: Container(),
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
											child: Text("Journal Death Plants",
												style: theme.textTheme.subhead
														.copyWith(color: Colors.white),)
									),
									_showBatch(context),
									Padding(
										padding: const EdgeInsets.all(10.0),
										child: RaisedButton(
											color: theme.accentColor,
											onPressed: () {
												widget.plantListBloc.handleDeath(widget.count, widget.pest, widget.death, widget.numDeath,widget.numDeathByPest, widget.batchId);
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





