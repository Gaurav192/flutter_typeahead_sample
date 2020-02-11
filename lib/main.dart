import 'dart:async';
import 'dart:convert';

import 'package:autocomplete_sample/places.dart';
import 'package:autocomplete_sample/textfield.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autocomplete Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'AutoComplete Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String _selectedState;
  // String _selectedCountry;

  // String _selectedCity;
  TextEditingController _stateController;
  TextEditingController _cityController;
  TextEditingController _countryController;
  StreamController _stateStream;
  StreamController _cityStream;
  Stream get stateStream => _stateStream?.stream;
  Stream get cityStream => _cityStream?.stream;

  void updateState(List value) => _stateStream.sink.add(value);
  void updateCity(List value) => _cityStream.sink.add(value);

  static const placesJson = [
    {"zip_code": "450201", "city": "city1", "state": "state1", "country": "IN"},
    {"zip_code": "675201", "city": "city2", "state": "state1", "country": "IN"},
    {"zip_code": "456801", "city": "city4", "state": "state2", "country": "IN"},
    {"zip_code": "453201", "city": "city5", "state": "state2", "country": "IN"},
    {"zip_code": "452201", "city": "city3", "state": "state3", "country": "IN"},
    {"zip_code": "568974", "city": "city6", "state": "state4", "country": "IN"},
    {"zip_code": "216458", "city": "city7", "state": "state4", "country": "IN"},
    {"zip_code": "401235", "city": "city9", "state": "state5", "country": "IN"},
    {"zip_code": "568974", "city": "city8", "state": "state5", "country": "IN"}
  ];

  var stateList = <String>[];
  var countryList = <String>[];
  var cityList = <String>[];

  @override
  void initState() {
    _cityStream = StreamController<List<String>>();
    _stateStream = StreamController<List<String>>();
    countryList = placesModelFromJson(jsonEncode(placesJson))
        .map((e) => e.country)
        .toSet()
        .toList();
    _countryController = TextEditingController()
      ..addListener(() {
        print(_countryController.text);
        stateList = placesModelFromJson(jsonEncode(placesJson))
            .where((element) =>
                element.country == (_countryController?.text ?? ''))
            .map((e) => e.state)
            .toSet() //to avoid duplicates
            .toList();
        updateState(stateList);
      });
    _stateController = TextEditingController()
      ..addListener(() {
        cityList = placesModelFromJson(jsonEncode(placesJson))
            .where((element) => element.state == (_stateController?.text ?? ''))
            .map((e) => e.city)
            .toSet()
            .toList();
        updateCity(cityList);
      });

    _cityController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stateStream.close();
    _cityStream.close();
    _stateController.clear();
    _countryController.clear();
    _cityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: CustomTextField(
                  placesList: countryList,
                  title: 'Country',
                  controller: _countryController,
                  onSelected: (item) => _countryController.text = item,
                ),
              ),
              Flexible(
                child: StreamBuilder<List<String>>(
                    stream: stateStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        title: 'State',
                        placesList: snapshot.data ?? <String>[],
                        controller: _stateController,
                        onSelected: (item) => _stateController.text = item,
                      );
                    }),
              ),
              Flexible(
                child: StreamBuilder<List<String>>(
                    stream: cityStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        title: 'City',
                        placesList: snapshot.data ?? <String>[],
                        controller: _cityController,
                        onSelected: (item) => _cityController.text = item,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
