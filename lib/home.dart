import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uvento/data/data.dart';

import 'details.dart';
import 'models/date_model.dart';
import 'models/event_type_model.dart';
import 'models/events_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DateModel> dates = new List<DateModel>();
  String todayDateIs = "12";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/logo.png",
                          height: 28,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "UEV",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "NTS",
                              style: TextStyle(
                                  color: Color(0xffFCCD00),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          "assets/notify.png",
                          height: 22,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Image.asset(
                          "assets/menu.png",
                          height: 22,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hello, Tahir!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Let's explore what’s happening nearby",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 3, color: Color(0xffFAE072)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                "assets/profilepic.jpg",
                                height: 40,
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Dates
                    Container(
                      height: 60,
                      child: ListView.builder(
                          itemCount: dates.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return DateTile(
                              weekDay: dates[index].weekDay,
                              date: dates[index].date,
                              isSelected: todayDateIs == dates[index].date,
                            );
                          }),
                    ),

                    /// Events

                    // Text(
                    //   "All Events",
                    //   style: TextStyle(color: Colors.white, fontSize: 20),
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // Container(
                    //   height: 100,
                    //   child: ListView.builder(
                    //       itemCount: eventsType.length,
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return EventTile(
                    //           imgAssetPath: eventsType[index].imgAssetPath,
                    //           eventType: eventsType[index].eventType,
                    //         );
                    //       }),
                    // ),

                    /// Popular Events

                    Text(
                      "Popular Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    // // FutureBuilder(
                    //   builder: (context, projectSnap) {
                    //     if (projectSnap.connectionState ==
                    //             ConnectionState.none &&
                    //         projectSnap.hasData == null) {
                    //       //print('project snapshot data is: ${projectSnap.data}');
                    //       return Container();
                    //     }
                    //     if (projectSnap.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return CircularProgressIndicator();
                    //     }
                    //     var data = projectSnap.data;
                    //     print(data.toString());
                    //     if (data == null) {
                    //       return Text(projectSnap.data.toString());
                    //     }
                    //     return Container(
                    //       height: 500,
                    //       child: ListView.builder(
                    //         itemCount: data != null ? data.length : 0,
                    //         itemBuilder: (context, index) {
                    //           var project = data[index];
                    //           return Text(project.toString() ?? "No data");
                    //         },
                    //       ),
                    //     );
                    //   },
                    //   future: Ev,
                    // )
                    FutureBuilder<Data>(
                      future: getEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.6,
                            child: ListView.builder(
                                itemCount: snapshot.data.results.length,
                                itemBuilder: (context, index) {
                                  var item = snapshot.data.results[index];
                                  return PopularEventTile(
                                    desc: item.name,
                                    date: item.startDate,
                                    enddate: item.endDate,
                                    imgeAssetPath: item.icon,
                                    url: item.url,
                                  );
                                }),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  String weekDay;
  String date;
  bool isSelected;
  DateTile({this.weekDay, this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffFCCD00) : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  EventTile({this.imgAssetPath, this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgAssetPath,
            height: 27,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            eventType,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  String date;
  String enddate;
  String imgeAssetPath;
  String url;

  /// later can be changed with imgUrl
  PopularEventTile(
      {this.enddate, this.date, this.imgeAssetPath, this.desc, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Details(this.url);
        }));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/calender.png",
                          height: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/calender.png",
                          height: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            enddate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: Image.network(
                  imgeAssetPath,
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ),
    );
  }
}
