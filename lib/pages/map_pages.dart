import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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

  late double height, width;

  static const LatLng loc1 = LatLng(20.352057930738336, 85.8192980439382);
  static const LatLng loc2 = LatLng(20.348189401234272, 85.82079535982004);

  LocationData? currentLocation;

  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
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
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  zoom: 15,
                  target: LatLng(newLoc.latitude!, newLoc.longitude!)),
            ),
          );
        });
      },
    );
  }

  void setCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "images/StrayPalicon.png")
        .then(
      (icon) {
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const GNav(
        gap: 5,
        backgroundColor: Color(0xFFC8E9EE),
        tabBackgroundColor: Color(0xFF63B6AD),
        // tabMargin: EdgeInsets.all(2.0),
        tabBorderRadius: 20,
        activeColor: Color(0xFF5C4450),
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.pets, text: 'Strays'),
          GButton(icon: Icons.group, text: 'Community'),
          GButton(icon: Icons.account_circle_outlined, text: 'Profile'),
        ],
      ),
      body: Stack(
        children: [
          Column(children: [
            Container(
              height: height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: EdgeInsets.only(top: 0.0),
              child: currentLocation == null
                  ? const GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: loc1, zoom: 15))
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 15),
                      markers: {
                        Marker(
                            markerId: const MarkerId("Location0"),
                            icon: currentIcon,
                            position: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!)),
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
                            fillColor: Colors.tealAccent.withOpacity(0.187)),
                        Circle(
                            circleId: CircleId("Campus6"),
                            center: loc1,
                            radius: 200,
                            strokeWidth: 2,
                            strokeColor: Colors.grey,
                            fillColor: Colors.tealAccent.withOpacity(0.187))
                      },
                      onMapCreated: (mapController) {
                        _controller.complete(mapController);
                      },
                    ),
            ),
            Container(
              height: height * 0.4,
              width: width,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    width: 500,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: EdgeInsets.only(top: 0.0),
                    child:
                        ListView(scrollDirection: Axis.horizontal,
                            children: [
                      Container(
                          height: 10.0,
                        child:
                            SizedBox(

                               width: 300.0,
                               child: FilledButton.icon(
                              onPressed: (){},
                              label: Text("Search for a StrayPal !", style: TextStyle(fontSize: 15.0, color: Colors.white),),
                              icon: const Icon(Icons.search, color: Colors.white,),
                              style: FilledButton.styleFrom(backgroundColor: Color(0xFF5C4450)),
                            ))
                      //   TextField(
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Color(0xFF5C4450),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(13.0),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     hintText: "Search for a StrayPal!",
                      //     hintStyle: TextStyle(color: Colors.white),
                      //     prefixIcon: Icon(Icons.search),
                      //     prefixIconColor: Colors.white,
                      //   ),
                      ),

                              Container(

                                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt) ))
                    ]),
                  ),
                  Container(
                      height: 250,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 10.0),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: const Color(0xFFFAC5C0)),
                                  child: ListView(
                                    children: [
                                      Padding(padding: EdgeInsets.all(20),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 120,
                                        width: 90,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          image: const DecorationImage (image: AssetImage('images/Catto.jpg'),
                                          fit: BoxFit.cover),
                                        ),
                                      ),),
                                      Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0),

                                        child: FilledButton.icon(onPressed: (){
                                          print("Pressed!");
                                        },
                                            label: Text("Community A", style: TextStyle(fontSize: 15.0, color: Colors.black87)),
                                            icon: const Icon(Icons.remove_red_eye, color: Colors.black87,),
                                            style: FilledButton.styleFrom(backgroundColor: Color(0xFFFEE9E1)),
                                        ),
                                      )
                                          ],
                                  )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 10.0),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xFFFAC5C0)),
                              child: ListView(
                                    children: [
                                      Padding(padding: EdgeInsets.all(20),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 120,
                                        width: 90,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          image: const DecorationImage (image: AssetImage('images/doggo.jpg'),
                                          fit: BoxFit.cover),
                                        ),
                                      ),),
                                      Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0),

                                        child: FilledButton.icon(onPressed: (){},
                                            label: Text("Community B", style: TextStyle(fontSize: 15.0, color: Colors.black87)),
                                            icon: const Icon(Icons.remove_red_eye, color: Colors.black87,),
                                            style: FilledButton.styleFrom(backgroundColor: Color(0xFFFEE9E1)),
                                        ),
                                      )
                                          ],
                                  )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 10.0),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xFFFAC5C0)),
                              child: ListView(
                                    children: [
                                      Padding(padding: EdgeInsets.all(20),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 120,
                                        width: 90,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          image: const DecorationImage (image: AssetImage('images/smolgatto.jpg'),
                                          fit: BoxFit.cover
                                          ),
                                        ),
                                      ),),
                                      Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0),

                                        child: FilledButton.icon(onPressed: (){},
                                            label: Text("Community C", style: TextStyle(fontSize: 15.0, color: Colors.black87)),
                                            icon: const Icon(Icons.remove_red_eye, color: Colors.black87,),
                                            style: FilledButton.styleFrom(backgroundColor: Color(0xFFFEE9E1)),
                                        ),
                                      )
                                          ],
                                  )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 10.0),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xFFFAC5C0)),
                              child: ListView(
                                    children: [
                                      Padding(padding: EdgeInsets.all(20),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 120,
                                        width: 90,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          image: const DecorationImage (image: AssetImage('images/elgatto.jpg'),
                                          fit: BoxFit.cover),
                                        ),
                                      ),),
                                      Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0),

                                        child: FilledButton.icon(onPressed: (){},
                                            label: Text("Community D", style: TextStyle(fontSize: 15.0, color: Colors.black87)),
                                            icon: const Icon(Icons.remove_red_eye, color: Colors.black87,),
                                            style: FilledButton.styleFrom(backgroundColor: Color(0xFFFEE9E1)),
                                        ),
                                      )
                                          ],
                                  )
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}
