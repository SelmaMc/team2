import 'package:courses_in_english/model/campus/campus.dart';
import 'package:courses_in_english/ui/scaffolds/location_details.dart';
import 'package:flutter/material.dart';

/// Location screen showing the different campuses of the munich university of applied sciences.
class LocationScreen extends StatefulWidget {
  final List<Campus> campuses;

  LocationScreen(this.campuses);

  @override
  State<StatefulWidget> createState() => new _LocationState(this.campuses);
}

class _LocationState extends State<LocationScreen> {
  /// List of campuses displayed.
  List<Campus> _campuses;

  _LocationState(this._campuses);

  @override
  Widget build(BuildContext context) {
    if (_campuses != null) {
      return new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          double width = MediaQuery.of(context).size.width;

          Campus campus = _campuses[index];
          return new Container(
              child: new GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) =>
                            new LocationDetailScreen(campus.id),
                      ),
                    );
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Image.asset(
                        campus.imagePath,
                        height: width / 2,
                        width: width,
                        fit: BoxFit.fitWidth,
                      ),
                      new Container(
                        child: new Text(
                          campus.name,
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                          ),
                          textScaleFactor: 3.0,
                        ),
                        color: new Color(0xCCFFFFFF),
                      )
                    ],
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                  )),
              padding: new EdgeInsets.all(10.0));
        },
        itemCount: _campuses.length,
      );
    } else {
      return new Center(
          child: new Image(image: new AssetImage("res/anim_cow.gif")));
    }
  }
}
