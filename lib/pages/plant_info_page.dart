import 'package:flutter/material.dart';

class PlantInfoPage extends StatelessWidget {
	Map<String, dynamic> data;

	PlantInfoPage(this.data);

  @override
  Widget build(BuildContext context) {
  	TextStyle style = Theme.of(context).textTheme.body1
			  .copyWith(fontSize: 16, color: Colors.black,
		      fontWeight: FontWeight.w400
	  );
	  TextStyle title = Theme.of(context).textTheme.title
			  .copyWith(color: Colors.black);

		String name = data["name"].toString();
	  return Scaffold(
//	    backgroundColor: Theme.of(context).primaryColor,
	    appBar: AppBar(
		    backgroundColor: Color.fromRGBO(97, 235, 153, 1),

		    title: Text(name.substring(0,1).toUpperCase() + name.substring(1),
			    style: title.copyWith(color: Colors.white),
		    ),
		    elevation: 0,
		    centerTitle: true,
		    
	    ),
	    body: Container(
		    decoration: BoxDecoration(
			    gradient: LinearGradient(
				    begin: Alignment.topCenter, end: Alignment.bottomCenter,
				    stops: [0.5, 0.9],
				    colors: [
					    Color.fromRGBO(97, 235, 153, 1),
					    Color.fromRGBO(28, 206, 100, 1)
				    ]
			    ),
		    ),
	      padding: const EdgeInsets.all(25.0),
	      child: SizedBox(
		      height: MediaQuery.of(context).size.height,
	        child: SingleChildScrollView(
	          child: Column(
			      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			      children: <Widget>[
			        Card(
			          child: ExpansionTile(
						      title: Text("PLANT INFORMATION", style: title,),
						      children: <Widget>[
							      Padding(
							        padding: const EdgeInsets.all(8.0),
							        child: Text(data["info"], style: style,),
							      ),
						      ],
					      ),
			        ),
				      Card(
				        child: ExpansionTile(
					      title: Text("PLANTING", style: title,),
					      children: <Widget>[
						      Padding(
						        padding: const EdgeInsets.all(8.0),
						        child: Text(data["planting"], style: style,),
						      ),
					      ],
				        ),
				      ),
				      Card(
				        child: ExpansionTile(
					      title: Text("CARING", style: title,),
					      children: <Widget>[
						      Padding(
						        padding: const EdgeInsets.all(8.0),
						        child: Text(data["care"], style: style,),
						      ),
					      ],
				        ),
				      ),
			        Card(
				        child: ExpansionTile(
					        title: Text("HARVESTING", style: title,),
					        children: <Widget>[
						        Padding(
							        padding: const EdgeInsets.all(8.0),
							        child: Text(data["harvest"], style: style,),
						        ),
					        ],
				        ),
			        ),
				      Card(
				        child: ExpansionTile(
					      title: Text("DISEASES", style: title,),
					      children: <Widget>[
						      Padding(
						        padding: const EdgeInsets.all(8.0),
						        child: Text(data["diseases"], style: style,),
						      ),
					      ],
				        ),
				      ),
		         ],
	          ),
	        ),
	      ),
	    ),
    );
  }
}
