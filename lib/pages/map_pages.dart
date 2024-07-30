import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng loc1 = LatLng(20.352057930738336, 85.8192980439382);
  static const LatLng loc2 = LatLng(20.348189401234272, 85.82079535982004);

  LocationData? currentLocation;

  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async{
    Location location = Location();
    location.enableBackgroundMode(enable: true);
    location.getLocation().then(
       (location) {
         setState(() {
           currentLocation = location;
         });

      },
    );
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
          (LocationData newLoc) {
            setState(() {
              currentLocation = newLoc;
              googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    zoom: 15,
                    target: LatLng(
                        newLoc.latitude!, newLoc.longitude!
                    )),
              ),
              );
            });


      },

    );
  }

  void setCustomIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "images/StrayPalicon.png").then((icon)
    {
      currentIcon = icon;
    },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomIcon();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        ListView(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
              child:
                Container(
                  alignment: Alignment.center,
                  width: 500,
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  margin: EdgeInsets.only(top:0.0),
                  child: currentLocation == null
                      ?const GoogleMap(
                      initialCameraPosition: CameraPosition(target: loc1, zoom: 15))
                      : GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 15),
                    markers: {

                      Marker(

                          markerId: const MarkerId("Location0"),
                          icon: currentIcon,
                          position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)),
                      // const Marker(
                      //     markerId: MarkerId("Location1"),
                      //     icon: BitmapDescriptor.defaultMarker,
                      //     position: loc1),
                      // const Marker(
                      //     markerId: MarkerId("Location2"),
                      //     icon: BitmapDescriptor.defaultMarker,
                      //     position: loc2)
                    },
                    circles: {
                      Circle(
                          circleId: CircleId("Eru"),
                          center: loc2,
                          radius: 200,
                          strokeWidth: 2,
                          strokeColor: Colors.grey,
                          fillColor: Colors.tealAccent.withOpacity(0.187)
                      ),
                      Circle(
                          circleId: CircleId("Campus6"),
                          center: loc1,
                          radius: 200,
                          strokeWidth: 2,
                          strokeColor: Colors.grey,
                          fillColor: Colors.tealAccent.withOpacity(0.187)
                      )
                    },
                    onMapCreated: (mapController) {
                      _controller.complete(mapController);
                    },
                  ),
                ),
            ),
        Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top:10.0,left: 15.0, right: 15.0),
        width: 500,
        height: 100,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),

        ),
        margin: EdgeInsets.only(top:0.0),
        child: TextField(
          decoration: InputDecoration(

            filled: true,
            fillColor: Color(0xFF5C4450 ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
              borderSide: BorderSide.none,
            ),
            hintText: "Search for a StrayPal!",
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.white,
          ),
        )
        ),
            Container(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 10.0),
                    child: Container(
                      height:200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFFFAC5C0)
                    ),
                    ),),
                    Padding(padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 10.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFFFAC5C0)
                        ),),),
                    Padding(padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 10.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(0xFFFAC5C0)
                        ),),),
                    Padding(padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 10.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(0xFFFAC5C0)
                        ),),),
                  ],
              )
            )
          ],
        ),

    );
  }
}
