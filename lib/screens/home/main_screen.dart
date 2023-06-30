import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/screens/maps/map.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/container/appcontainer.dart';
import 'package:smarttrashcan/widgets/double_back/double_back_to_close.dart';
import 'package:http/http.dart' as http;
import 'package:smarttrashcan/widgets/drawer/drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool startWork = false;
  MapController mapController = MapController();
  List<LatLng> trashCanPoint = [];
  LatLng? myLocation;
  List trashData = [];
  bool loadPage = true;

  // var jsondata = [
  //   {
  //     "id": 2,
  //     "IDNumber": 12,
  //     "is_full": true,
  //     "Trash_Level": "75",
  //     "is_open": false,
  //     "healthy": "70",
  //     "ResultConfidence": 2,
  //     "latitude": "36.71040438745263",
  //     "longitude": "52.682176261148",
  //     "trashlevel_status": "empty",
  //   },
  //   {
  //     "id": 4,
  //     "IDNumber": 14,
  //     "is_full": false,
  //     "Trash_Level": "50",
  //     "is_open": false,
  //     "healthy": "90",
  //     "ResultConfidence": 4,
  //     "latitude": "36.70317893228073",
  //     "longitude": "52.67212803648576",
  //     "trashlevel_status": "full",
  //   }
  // ];
  // setTest() {
  //   print(jsondata);
  //   setState(() {
  //     trashCanPoint = List.generate(
  //       jsondata.length,
  //       (index) => LatLng(
  //         double.parse(jsondata[index]['latitude'].toString()),
  //         double.parse(jsondata[index]['longitude'].toString()),
  //       ),
  //     );
  //     trashData = List.generate(
  //       jsondata.length,
  //       (index) => jsondata[index],
  //     );
  //     loadPage = true;
  //   });
  // }

  apiDriverLocation() async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/DriverLocation/"),
        body: jsonEncode(
          <String, String>{
            "latitude": myLocation!.latitude.toString(),
            "longitude": myLocation!.longitude.toString(),
          },
        ),
      );
      print("DriverLocation => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);
          setState(() {
            trashCanPoint = List.generate(
              jsondata.length,
              (index) => LatLng(
                double.parse(jsondata[index]['latitude'].toString()),
                double.parse(jsondata[index]['longitude'].toString()),
              ),
            );
            trashData = List.generate(
              jsondata.length,
              (index) => jsondata[index],
            );
            loadPage = true;
          });
        });
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      toast("خطایی به‌ وجود آمده است");
      print("DriverLocation catch => $e");
    }
  }

  getMyLocation() async {
    toast("در حال دریافت اطلاعات شما");
    setState(() {
      loadPage = false;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      myLocation = LatLng(position.latitude, position.longitude);
    });
    mapController.move(myLocation!, 15.5);
    apiDriverLocation();
    // setTest();
  }

  void Function(bool)? start(value) {
    setState(() {
      startWork = value;
    });
    if (startWork) {
      getMyLocation();
    } else {
      trashCanPoint.clear();
      trashData.clear();
      MapScreenState.isSelectTrash = false;
      MapScreenState.pointsDirection.clear();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleBackToClose(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: scaffoldKey,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerTop,
            floatingActionButton: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppContainer(
                        onTap: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        height: 45,
                        width: 45,
                        borderRadius: 100,
                        color: AppTheme.primaryColor,
                        icon: Icons.menu,
                        iconcolor: AppTheme.iconColor,
                      ),
                      SizedBox(
                        width: 100,
                        height: 75,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: startWork,
                            activeTrackColor: AppTheme.primaryColor,
                            inactiveThumbColor: AppTheme.primaryColor,
                            onChanged: start,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 45,
                      ),
                      // AppContainer(
                      //   onTap: () {
                      //     if (startWork) {
                      //       getMyLocation();
                      //     } else {
                      //       toast("برای دریافت اطلاعات آنلاین شوید.");
                      //     }
                      //   },
                      //   height: 45,
                      //   width: 45,
                      //   borderRadius: 100,
                      //   color: AppTheme.primaryColor,
                      //   icon: Icons.my_location,
                      //   iconcolor: AppTheme.iconColor,
                      // ),
                    ],
                  ),
                  if (!startWork)
                    const AppContainer(
                      height: 40,
                      width: 230,
                      color: AppTheme.white,
                      border: true,
                      borderColor: AppTheme.primaryColor,
                      text: "برای دریافت اطلاعات آنلاین شوید.",
                      textColor: AppTheme.primaryColor,
                    )
                ],
              ),
            ),
            body: MapScreen(
              trashCanPoint: trashCanPoint,
              myLocation: myLocation,
              mapController: mapController,
              trashData: trashData,
              loadpage: loadPage,
            ),
            drawer: const AppDrawer(),
          ),
        ),
      ),
    );
  }
}
