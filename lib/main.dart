import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'places.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Mon nom',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Colors.indigo
      ),
      home: new MyHomePage(title: 'Mon nom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Place> _places = <Place>[];
  Map<String,double> _currentLocation;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      listenForPlaces();
    }

    listenForPlaces() async {
      var stream = await getPlaces(33.9850, -118.4695);
      stream.listen((place) => setState(() => _places.add(place)) );
    }

    _getCurrentLocation() async{
      Location _location = new Location();

      _currentLocation = await _location.getLocation;
      
      var stream = await getPlaces(_currentLocation['latitude'],_currentLocation['longitude']);
       _places.clear();
      stream.listen((place) => setState(() => _places.add(place)) );
    }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text (widget.title) ,
      ),
      body: new Center(
        child: new ListView(
          children: _places.map((place) => new PlaceWidget(place)).toList(),
        )
      ),
      floatingActionButton: new FloatingActionButton(
         onPressed: _getCurrentLocation,
         tooltip: 'Get current Location',
         child: new Icon(Icons.add_location),
      ),
    );
  }
}

class PlaceWidget extends StatelessWidget {

  final Place _places; 
  PlaceWidget(this._places);

  Color getColor(double rating){
    return Color.lerp(Colors.red, Colors.green, rating/5);
  }

  @override
  Widget build(BuildContext context) {
    return new Dismissible( 
        key: new Key(_places.name),
        background: new Container(color: Colors.green),
        secondaryBackground: new Container(color: Colors.red),
        onDismissed: (direction){
          direction == DismissDirection.endToStart? Scaffold.of(context).showSnackBar(
             new SnackBar( content: new Text('No Like !!'))
          ) : Scaffold.of(context).showSnackBar(
             new SnackBar( content: new Text('I Like !!!')));
        },
        child:  new ListTile(
        leading: new CircleAvatar(
          child: new Text(_places.rating.toString()),
          backgroundColor: getColor(_places.rating),
        ),
      title: new Text(_places.name),
      subtitle: new Text(_places.address),
    ),
    );
  }
}