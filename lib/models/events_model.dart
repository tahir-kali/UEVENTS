import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// List<Events> postFromJson(String str) =>
//     List<Events>.from(json.decode(str).map((x) => Events.fromMap(x)));

class Data {
  final List<Events> results;
  Data({this.results});
  factory Data.fromJson(Map<String, dynamic> data) {
    var list = data['data'] as List;
    List<Events> resultList = list.map((e) => Events.fromJson(e)).toList();
    return Data(
      results: resultList,
    );
  }
}

class Events {
  Events(
      {this.name,
      this.icon,
      this.startDate,
      this.endDate,
      this.venue,
      this.url});

  String name;
  String icon;
  String startDate;
  String endDate;
  String venue;
  String url;

  factory Events.fromJson(Map<String, dynamic> json) => Events(
      name: json["name"],
      icon: json["icon"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      url: json['url']);
}

Future<Data> getEvents() async {
  try {
    final response = await http.get(
        Uri.parse('https://guidebook.com/service/v2/upcomingGuides'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      //print(parsed.toString());
      var data = Data.fromJson(parsed);
      print(data.toString());
      return data;
    } else {
      throw Exception('Failed to load album');
    }
  } catch (e) {
    return e;
  }
}
