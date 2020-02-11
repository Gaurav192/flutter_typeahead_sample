import 'dart:convert';

import 'package:autocomplete_sample/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final List<String> placesList;
  final TextEditingController controller;
  final ValueChanged<String> valueChanged;
  final Function(String) onSelected;

  const CustomTextField(
      {Key key,
      this.controller,
      this.title,
      this.placesList,
      this.valueChanged,
      this.onSelected})
      : super(key: key);
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      getImmediateSuggestions: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(hintText: "Select ${widget.title}"),
      ),
      // itemSubmitted: (item) {
      //   widget.valueChanged(item);
      // },
      onSuggestionSelected: (item) => widget.onSelected(item),
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
            title: new Text(suggestion),
          ),
          padding: EdgeInsets.all(8.0)),
      suggestionsCallback: (input) => getSuggestions(widget.placesList, input),
      // suggestion.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  String fetchSuggestion(PlacesModel place) {
    switch (widget.title) {
      case 'Country':
        return place.country;
      case 'State':
        return place.state;
      case 'City':
        return place.city;
      default:
        return null;
    }
  }

  getSuggestions(List<String> items, String input) {
    final filteredItems = items
        .where(
            (element) => element.toLowerCase().startsWith(input.toLowerCase()))
        .toList();
    return filteredItems;
  }
}
