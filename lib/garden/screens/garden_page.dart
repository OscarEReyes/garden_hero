import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  String _value = "Garden 1";
  List<String> gardens = ["Garden 1", "Garden 2"];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: <Widget>[
          _buildRow(),
          SizedBox(height: size.height * 0.05,),
          Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.5),
            child: _buildGardenDisplay(context, size)
          )
        ],
      ),
    );
  }

  Widget _buildRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Gardens",
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.w400
            ),
          ),
          DropdownButton(
            elevation: 24,
            value: _value,
            onChanged: (String newGarden) {
              _value = newGarden;
            },
            items: gardens.map(
              (String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$value",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                );
              }
            ).toList()
          ),
        ],
      ),
    );
  }

  Widget _buildGardenDisplay(BuildContext context, Size size) {
    
    return CarouselSlider(
      items: [1,2,3,4,5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0
              ),
              child: Card(
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Plant $i', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 48.0
                    ),
                  ),
                ),
              )
            );
          },
        );
      }).toList(),
      height: 400.0,
      autoPlay: true
    );
  }
}