
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/plant_list_bloc.dart';
import 'package:garden_hero/models/Batch.dart';

class AddPlantDialog extends StatefulWidget {
  double numPlants = 1.0;
  List<String> _typeList = ["apples", "pears", "oranges", "roses"];
  List<String> _phaseList = ["planted", "growing", "yeild", "germenated"];
  String _plantType = null;
  String _phaseType = null;
  String gardenID;
  int id=0;
  String _id = "";
  PlantListBloc plantListBloc;
  DateTime _curDate = DateTime.now();
  Map<String,dynamic> _batch;

  AddPlantDialog({this.gardenID,this.plantListBloc,this.id});


 // Map<String,dynamic> get batch=>_batch;

  Map<String, dynamic> toMap() {
    Map<String,dynamic> data  ={
      'garden':gardenID,
      'plantType':_plantType,
      'phase': _phaseType,
      'count':numPlants,
      'date':_curDate,
      'id': _id
    };
    return data;
  }

  @override
  _NewPlantDialogState createState() => _NewPlantDialogState();
}

class _NewPlantDialogState extends State<AddPlantDialog> {


  @override
  void initState() {
    widget._plantType = widget._typeList.elementAt(0);
    widget._phaseType = widget._phaseList.elementAt(0);
   // widget.d = widget.gardenID+widget.id.toString();
    super.initState();
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget._curDate,
        firstDate: DateTime(2018),
        builder: (context,Widget data){
          return Theme(
              data: ThemeData.dark(),
            child: data
          );
        },
        lastDate: DateTime(2020));
    if (picked != null && picked != widget._curDate) {
      print("date selected ${widget._curDate.toString()}");
    }
    setState(() {
      widget._curDate = picked;
    });
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
    if(widget._curDate ==null ){
      widget._curDate = DateTime.now();
      batchStr ="${widget._curDate.month.toString()}/${widget._curDate.day.toString()}/${widget._curDate.year.toString()}";
    }else{
      batchStr = "${widget._curDate.month.toString()}/${widget._curDate.day.toString()}/${widget._curDate.year.toString()}";
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: _showPhaseDropdown(),
          ),
          Container(
            child: _showTypeDropdown(),
          ),

          IconButton(
            icon: Icon(
              Icons.date_range,
              color: Colors.purpleAccent,
            ),
            onPressed: () {
              _selectDate(context);
            },
          ),
          Container(
            child: Slider(
              value: widget.numPlants,
              onChanged: (double val) => _onChanged(val),
              max: 30,
              min: 0,
              divisions: 30,
              activeColor: Colors.greenAccent,
              inactiveColor: Colors.grey,
              label: widget.numPlants.toString(),
            ),
          ),

          Card(
              elevation: 3.0,
              child: Text("date selected: $batchStr")),
          Card(
              elevation: 3.0,
              child: Text("count: ${widget.numPlants.toString()}")),
        ],
      ),
    );
  }

  Widget _showPhaseDropdown() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  value: widget._plantType,
                  items: widget._typeList.map((String value) {
                    return DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Text("$value"),
                            IconButton(
                              alignment: Alignment.centerRight,
                              color: Colors.black12,
                              icon: Icon(
                                Icons.add,
                              ),
                              onPressed: () {
                                print("added\t$value");
                              },
                            ),
                          ],
                        ));
                  }).toList(),
                  onChanged: (String value) {
                    _onTypeSwitched(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showTypeDropdown() {

    return Container(
      child: DropdownButton(
        value: widget._phaseType,
        items: widget._phaseList.map((String value) {
          return DropdownMenuItem(
              value: value,
              child: Row(
                children: <Widget>[
                  Text("$value"),
                  IconButton(
                    alignment: Alignment.centerRight,
                    color: Colors.black12,
                    icon: Icon(
                      Icons.add,
                    ),
                    onPressed: () {
                      print("added\t$value");
                    },
                  ),
                ],
              ));
        }).toList(),
        onChanged: (String value) {
          _onPhaseSwitched(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * .5,
          maxWidth: size.width * .75,
        ),
        child: Card(
          child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("add Batch:")),
                    flex: 1,
                  ),
                  Container(child: _showBatch(context)),
                  Container(
                    child: RaisedButton(
                      padding: const EdgeInsets.all(5.0),
                      onPressed: () {


                        setState(() {
                         // widget._batch.fromMap(widget.toMap());
                        // widget.id+=1;
                       //   widget.d = widget.id.toString();
                          widget._id = widget.gardenID+widget.id.toString();
                          widget._batch = widget.toMap();
                          widget.id++;

                        });
                        print("id:\t${widget._batch["id"]}\t"+widget.id.toString());
                        widget.plantListBloc.inBatch.add(widget._batch);
                        Navigator.pop(context);
                      },
                      child: Text("add batch", style: theme.textTheme.button),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}



