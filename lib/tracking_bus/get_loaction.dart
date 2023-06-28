import 'dart:async';

import 'package:bus_tracking/Screens/home_screen.dart';
import 'package:bus_tracking/google_map%20copy.dart';
import 'package:bus_tracking/tracking_bus/update_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          backgroundColor: Colors.transparent,
          color: Colors.deepPurple,
          animationDuration: const Duration(milliseconds: 300),
          height: 60,
          items: [
            IconButton(
                icon: Icon(
                  Icons.directions_bus_filled_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  _getLocation();
                }),
            IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  );
                }),
            IconButton(
                icon: Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationTrack()));
                }),
          ]),
      appBar: AppBar(
        title: Text('IU bus  tracker'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                _listenLocation();
              },
              child: Text('enable live location')),
          TextButton(
              onPressed: () {
                _stopListening();
              },
              child: Text('stop live location')),


          Expanded(
              child: StreamBuilder(
                stream:
                FirebaseFirestore.instance.collection('locationss').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                          Text(snapshot.data!.docs[index]['name'].toString()),
                          subtitle: Row(
                            children: [
                              Text(snapshot.data!.docs[index]['latitude']
                                  .toString()),
                              SizedBox(
                                width: 20,
                              ),
                              Text(snapshot.data!.docs[index]['longitude']
                                  .toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MyMap(snapshot.data!.docs[index].id)));
                            },
                          ),
                        );
                      });
                },
              )),
        ],
      ),
    );
  }

  _getLocation() async {
    print('name');
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('locationss').doc('user2').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'Taufique'

      }, SetOptions(merge: true));

    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('locationss').doc('user2').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'Taufique'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
