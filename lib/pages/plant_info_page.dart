import 'package:flutter/material.dart';

class PlantInfoPage extends StatelessWidget {
	Map<String, dynamic> data;

	PlantInfoPage(this.data);

  @override
  Widget build(BuildContext context) {
  	TextStyle style = Theme.of(context).textTheme.body1.copyWith(fontSize: 16);
    return Scaffold(
	    appBar: AppBar(title: Text(data["name"],)),
	    body: Padding(
	      padding: const EdgeInsets.all(25.0),
	      child: SingleChildScrollView(
	        child: Column(
		      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
		      children: <Widget>[
		    	  ExpansionTile(
				      title: Text("Plant Information"),
				      children: <Widget>[
					      Text(data["info"], style: style,),
				      ],
			      ),
			      ExpansionTile(
				      title: Text("Planting"),
				      children: <Widget>[
					      Text(data["planting"], style: style,),
				      ],
			      ),
			      ExpansionTile(
				      title: Text("Caring"),
				      children: <Widget>[
					      Text(data["care"], style: style,),
				      ],
			      ),
			      ExpansionTile(
				      title: Text("Diseases"),
				      children: <Widget>[
					      Text(data["diseases"], style: style,),
				      ],
			      ),



		         ],
	        ),
	      ),
	    ),
    );
  }
}
