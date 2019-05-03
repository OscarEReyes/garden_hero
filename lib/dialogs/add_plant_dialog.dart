
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/models/Batch.dart';
import 'package:garden_hero/models/db_client.dart';
import 'package:sqlcool/sqlcool.dart';

class AddPlantDialog extends StatefulWidget {
  double numPlants = 1.0;
  List<String> _typeList;
  List<String> _phaseList = ["planted", "growing", "yield", "germenated"];
  String _plantType;
  String _phaseType;
  String gardenID;
  PlantListBloc plantListBloc;
  DateTime _curDate = DateTime.now();

  AddPlantDialog(this.gardenID,this.plantListBloc, this._typeList);


 // Map<String,dynamic> get batch=>_batch;

  Map<String, dynamic> toMap() {
    Map<String,dynamic> data  ={
    	'water': 0,
      'garden':gardenID,
      'plantType':_plantType,
      'phase': _phaseType,
      'count':numPlants,
      'date':_curDate,
    };
    return data;
  }

  @override
  _NewPlantDialogState createState() => _NewPlantDialogState();
}

class _NewPlantDialogState extends State<AddPlantDialog> {


  @override
  void initState() {
   // widget.d = widget.gardenID+widget.id.toString();
    super.initState();
    widget._plantType = widget._typeList.elementAt(0);
    widget._phaseType = widget._phaseList.elementAt(0);
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget._curDate,
        firstDate: DateTime(2018),
        builder: (context,Widget data){
          return Theme(
              data: ThemeData.dark().copyWith(
	              accentColor: Theme.of(context).primaryColor,
	              dialogBackgroundColor: Color.fromRGBO(230, 31, 111,1),
	              primaryColorDark: Theme.of(context).accentColor,
	              backgroundColor: Color.fromRGBO(28, 206, 100,1)
              ),
            child: data
          );
        },
        lastDate: DateTime(2020));
    if (picked != null && picked != widget._curDate) {
      setState(() {
	      widget._curDate = picked;
      });
    }
  }

  void _onChanged(double val) {
    setState(() {
      widget.numPlants = val;
    });
  }

  void _onTypeSwitched(String value) {
    setState(() {
      widget._plantType = value;
    });
  }

  void _onPhaseSwitched(String value) {
    setState(() {
      widget._phaseType = value;
    });
  }

  Widget _showBatch(BuildContext context) {
    String batchStr= "";
    String month = widget._curDate.month.toString();
    String day = widget._curDate.day.toString();
    String year = widget._curDate.year.toString();

    if(widget._curDate ==null ){
      widget._curDate = DateTime.now();
      batchStr ="$month/$day/$year";
    }else{
      batchStr = "$month/$day/$year";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          _showPhaseDropdown(),
          SizedBox(height: 5,),
          _showTypeDropdown(),
          Row(
	          children: <Widget>[
	          Padding(
		          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 50),
		          child: IconButton(
			          icon: Icon(Icons.date_range, color: Theme.of(context).accentColor,),
			          iconSize: 30,
			          onPressed: () => _selectDate(context),
		          ),
	          ),
	          Text("Date:    ", style: TextStyle(
			          fontSize: 18,
			          color: Theme.of(context).accentColor,
		          fontWeight: FontWeight.w600
	          ),

	          ),
	          Text("$batchStr", style: TextStyle(color: Colors.white, fontSize: 14),),
          ],),
          Container(
            child: Slider(
              value: widget.numPlants,
              onChanged: (double val) => _onChanged(val),
              max: 30,
              min: 0,
              divisions: 30,
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
		        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 40),
	        ),
        ],
      ),
    );
  }

  Widget _showPhaseDropdown() {
    return Container(
	    width: 300,
	    color: Colors.white,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: widget._plantType,
            items: widget._typeList.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text("${value.trim()}"));
            }).toList(),
            onChanged: (String value) =>_onTypeSwitched(value),
          ),
        ),
      ),
    );
  }

  Widget _showTypeDropdown() {
    return Container(
	    color: Colors.white,
			width: 300,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
	        alignedDropdown: true,
          child: DropdownButton(
            value: widget._phaseType,
            items: widget._phaseList.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text("$value"));
            }).toList(),
            onChanged: (String value) {
              _onPhaseSwitched(value);
            },
          ),
        ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25,bottom: 25),
                  child: Text("New Batch",
                    style: theme.textTheme.subhead
	                    .copyWith(color: Colors.white),)
                ),
                _showBatch(context),
                Padding(
	                padding: const EdgeInsets.all(10.0),
	                child: RaisedButton(
		                color: theme.accentColor,
                    onPressed: () {
                      widget.plantListBloc.inBatch.add(widget.toMap());
                      Navigator.pop(context);
                    },
                    child: Text("Add",
	                    style: theme.textTheme.button
                    ),
                  ),
                ),
              ],
            )),
        ),
      ),
    );
  }
}





