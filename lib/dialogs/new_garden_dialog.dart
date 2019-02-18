import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/new_garden_bloc.dart';

class NewGardenDialog extends StatefulWidget {
  final String _initialDesc;
  final String _initialName;

  NewGardenDialog(this._initialName, this._initialDesc);



  @override
  _NewGardenDialogState createState() => _NewGardenDialogState();
}

class _NewGardenDialogState extends State<NewGardenDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  NewGardenBloc _newGardenBloc;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget._initialName;
    _descriptionController.text = widget._initialDesc;
    _newGardenBloc = NewGardenBloc();
    _newGardenBloc.onNameChanged(widget._initialName);
    _newGardenBloc.onDescriptionChanged(widget._initialDesc);
  }

  @override dispose() {
    _newGardenBloc?.dispose();
    _nameController?.dispose();
    _descriptionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(top: 50.0),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: size.height * 0.45,
            maxWidth: size.width * 0.9
        ),
        child: Card(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(height: 5.0,),
                  Text("New Garden"),
                  _buildFieldNameTextField(),
                  _buildDescriptionTextField(),
                  _buildAddFieldButton(theme),
                  const SizedBox(height: 15.0,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFieldNameTextField() {
    return StreamBuilder<String>(
        stream: _newGardenBloc.name,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              onChanged: _newGardenBloc.onNameChanged,
              decoration: InputDecoration(
                errorText: snapshot.error,
                labelText: 'Name',
                labelStyle: Theme.of(context).textTheme.subhead,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildDescriptionTextField() {
    return StreamBuilder<String>(
        stream: _newGardenBloc.description,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              onChanged: _newGardenBloc.onDescriptionChanged,
              decoration: InputDecoration(
                errorText: snapshot.error,
                labelText: 'Description',
                labelStyle: Theme.of(context).textTheme.subhead,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildAddFieldButton(ThemeData data) {
    return StreamBuilder<bool>(
        stream: _newGardenBloc.fieldValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return RaisedButton(
            padding: const EdgeInsets.all(10.0),
            child: Text('Add Field',
              style: data.textTheme.button,
            ),
            onPressed: (snapshot.hasData && snapshot.data == true)
                ? ()  {
              Map<String, String> data = {
                "name" : _nameController.text,
                "description" : _descriptionController.text
              };
              Navigator.of(context).pop((
                  data
              ));
            }
                : null,
          );
        });
  }
}