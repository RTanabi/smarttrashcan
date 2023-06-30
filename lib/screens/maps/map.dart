// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/button/button.dart';
import 'package:smarttrashcan/widgets/container/appcontainer.dart';
import 'package:smarttrashcan/widgets/loading/loading.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  List<LatLng> trashCanPoint;
  LatLng? myLocation;
  final MapController mapController;
  List trashData;
  bool? loadpage;
  MapScreen({
    super.key,
    required this.trashCanPoint,
    this.myLocation,
    required this.mapController,
    required this.trashData,
    required this.loadpage,
  });

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? center;
  LatLng? selectedTrash;
  dynamic selectedTrashData;
  static bool isSelectTrash = false;
  static List<LatLng> pointsDirection = [];
  bool chooseButton = false;
  bool endButton = false;

  /////////**************************Google API********************************* *//////////

  getRoute(LatLng start, LatLng end) async {
    try {
      String url =
          "http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson";
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(
          () {
            var data = jsonDecode(response.body);
            List route = data['routes'][0]['geometry']['coordinates'];
            pointsDirection = List.generate(
              route.length,
              (index) => LatLng(
                route[index][1],
                route[index][0],
              ),
            );
          },
        );
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      print("getRoute =====> $e");
    }
  }

  ///////////////////////////   API ////////////////////////////////////////////////////////
  apiGetId(id) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/Get_TrushcanID/"),
        body: jsonEncode(
          <String, dynamic>{
            "id": id,
          },
        ),
      );
      print("apiGetId => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);

          isSelectTrash = true;
        });
        updateRoute(widget.myLocation!, selectedTrash!);
        Navigator.pop(context);
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      toast("خطایی به‌ وجود آمده است");
      print("apiGetId catch => $e");
    }
    setState(() {
      chooseButton = false;
    });
  }

  apiEndWork() async {
    print(User.token);
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/EndButten/"),
        headers: {
          "token": User.token,
        },
        body: jsonEncode(
          <String, dynamic>{
            "id": selectedTrashData['id'],
          },
        ),
      );
      print("apiEndWork => ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsondata = json.decode(utf8.decode(response.bodyBytes));
        print(jsondata);
        isSelectTrash = false;
        selectedTrash = null;
        pointsDirection.clear();
        widget.trashCanPoint.clear();
        widget.trashData.clear();
        getMyLocation();
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      toast("خطایی به‌ وجود آمده است");
      print("apiEndWork catch => $e");
    }
    setState(() {
      endButton = false;
    });
  }

  apiDriverLocation() async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/DriverLocation/"),
        body: jsonEncode(
          <String, String>{
            "latitude": widget.myLocation!.latitude.toString(),
            "longitude": widget.myLocation!.longitude.toString(),
          },
        ),
      );
      print("DriverLocation => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);
          setState(() {
            widget.trashCanPoint = List.generate(
              jsondata.length,
              (index) => LatLng(
                double.parse(jsondata[index]['latitude'].toString()),
                double.parse(jsondata[index]['longitude'].toString()),
              ),
            );
            widget.trashData = List.generate(
              jsondata.length,
              (index) => jsondata[index],
            );
            widget.loadpage = true;
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
      widget.loadpage = false;
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
      widget.myLocation = LatLng(position.latitude, position.longitude);
    });
    widget.mapController.move(widget.myLocation!, 15.5);
    apiDriverLocation();
  }

  ///////////////////////////////////////////////////////////////////////////////////////////

  launchMaps() async {
    try {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=${selectedTrash!.latitude},${selectedTrash!.longitude}';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {}
  }

  endWork() {
    setState(() {
      endButton = true;
    });
    apiEndWork();
  }

  updateRoute(LatLng start, LatLng end) async {
    try {
      await getRoute(start, end);
    } catch (e) {
      print("updateRoute ====> $e");
    }
  }

  chooseTrash(LatLng point, data) {
    setState(() {
      chooseButton = true;
    });
    apiGetId(data['id']);
    selectedTrash = point;
    selectedTrashData = data;
    pointsDirection.clear();
  }

  trashStatus(String status) {
    switch (status) {
      case "full":
        return "پر";
      case "half_full":
        return "نیمه پر";
      case "empty":
        return "خالی";
      default:
    }
  }

  showDetails(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 375,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: AppContainer(
                        height: 6.0,
                        width: 90,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text:
                              "سطل زباله ${widget.trashData[index]['IDNumber']}",
                          textColor: AppTheme.white,
                          size: AppTextFontSize.large,
                          weight: AppTextFontWeight.bold,
                        ),
                        AppText(
                          text:
                              "وضعیت: ${trashStatus(widget.trashData[index]['trashlevel_status'])}",
                          textColor: AppTheme.white,
                          size: AppTextFontSize.normal,
                          weight: AppTextFontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.layers,
                        ),
                        const AppText(
                          text: " سطح: ",
                          size: AppTextFontSize.normal,
                          textColor: AppTheme.white,
                        ),
                        AppText(
                          text: "${widget.trashData[index]['Trash_Level']}%",
                          size: AppTextFontSize.medium,
                          weight: AppTextFontWeight.bold,
                          textColor: AppTheme.white,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.delete_outline_rounded,
                    //     ),
                    //     const AppText(
                    //       text: " نتیجه اطمینان: ",
                    //       size: AppTextFontSize.normal,
                    //       textColor: AppTheme.white,
                    //     ),
                    //     AppText(
                    //       text:
                    //           "${widget.trashData[index]['ResultConfidence']}",
                    //       size: AppTextFontSize.medium,
                    //       weight: AppTextFontWeight.bold,
                    //       textColor: AppTheme.white,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Row(
                      children: [
                        const Icon(
                          Icons.health_and_safety_rounded,
                        ),
                        const AppText(
                          text: " وضعیت سلامت: ",
                          size: AppTextFontSize.normal,
                          textColor: AppTheme.white,
                        ),
                        AppText(
                          text: "${widget.trashData[index]['healthy']}%",
                          size: AppTextFontSize.medium,
                          weight: AppTextFontWeight.bold,
                          textColor: AppTheme.white,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.done_rounded,
                        ),
                        const AppText(
                          text: " وضعیت درب سطل زباله: ",
                          size: AppTextFontSize.normal,
                          textColor: AppTheme.white,
                        ),
                        AppText(
                          text: widget.trashData[index]['is_open']
                              ? "باز"
                              : "بسته",
                          size: AppTextFontSize.medium,
                          weight: AppTextFontWeight.bold,
                          textColor: AppTheme.white,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions,
                        ),
                        const AppText(
                          text: " فاصله شما تا سطل زباله: ",
                          size: AppTextFontSize.normal,
                          textColor: AppTheme.white,
                        ),
                        AppText(
                          text: widget.myLocation == null
                              ? ""
                              : "${calculatedistance(widget.myLocation!, widget.trashCanPoint[index])} کیلومتر",
                          size: AppTextFontSize.medium,
                          weight: AppTextFontWeight.bold,
                          textColor: AppTheme.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppButtons(
                onTap: () {
                  chooseTrash(
                      widget.trashCanPoint[index], widget.trashData[index]);
                },
                height: 50,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppTheme.white),
                ),
                child: chooseButton
                    ? const ButtonLoading()
                    : const AppText(
                        text: "انتخاب",
                        textColor: AppTheme.primaryColor,
                        weight: AppTextFontWeight.bold,
                        size: AppTextFontSize.xLarge,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  calculatedistance(LatLng start, LatLng end) {
    double distance = const Distance().as(LengthUnit.Meter, start, end);
    return (distance / 1000).toStringAsFixed(2);
  }

  Color setColor(isfull) {
    if (isfull) {
      return AppTheme.isFullTrash;
    } else {
      return AppTheme.isEmptyTrash;
    }
  }

//widget******************************

  Widget trashMark() {
    return MarkerLayer(
      markers: List.generate(
        widget.trashCanPoint.length,
        (index) => Marker(
          point: widget.trashCanPoint[index],
          builder: (context) => AppContainer(
            padding: EdgeInsets.zero,
            height: 50,
            width: 40,
            color: Colors.white,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/icon.png",
                    height: 20,
                    width: 20,
                    color: setColor(widget.trashData[index]['is_full']),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 8.0,
                    backgroundColor:
                        setColor(widget.trashData[index]['is_full']),
                    child: AppText(
                      text: (index + 1).toString(),
                      textColor: AppTheme.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myLocationMark() {
    return MarkerLayer(
      markers: [
        Marker(
          point: widget.myLocation!,
          builder: (context) => const Icon(
            Icons.circle,
            color: AppTheme.myLocationIconColor,
            size: 20,
            shadows: [
              Shadow(
                color: AppTheme.myLocationIconColor,
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget direction() {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: pointsDirection,
          color: AppTheme.primaryColor.withOpacity(0.8),
          strokeWidth: 4.0,
        ),
      ],
    );
  }

  @override
  void initState() {
    setState(() {
      center = const LatLng(35.7219, 51.3347);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: widget.mapController,
              options: MapOptions(
                center: center,
                zoom: 8.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),

                //show trashcan position
                if (widget.trashCanPoint.isNotEmpty) trashMark(),

                //show my location
                if (widget.myLocation != null) myLocationMark(),

                if (pointsDirection.isNotEmpty) direction(),
              ],
            ),
            if (!widget.loadpage!)
              Center(
                child: LoadingBouncingGrid.circle(
                  backgroundColor: AppTheme.primaryColor,
                  size: 30,
                ),
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isSelectTrash
            ? Padding(
                padding: AppConstants.padding,
                child: SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppContainer(
                        onTap: () {
                          launchMaps();
                        },
                        height: 40,
                        width: 80,
                        text: "مسیریابی",
                        textColor: AppTheme.primaryColor,
                        border: true,
                        borderRadius: 20,
                        borderColor: AppTheme.primaryColor,
                        color: AppTheme.white,
                      ),
                      AppButtons(
                        onTap: () {
                          endWork();
                        },
                        height: 50,
                        text: "اتمام فعالیت",
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: double.infinity,
                height: 210,
                child: PageView.builder(
                  pageSnapping: true,
                  itemCount: widget.trashData.length,
                  onPageChanged: (value) {
                    widget.mapController.move(widget.trashCanPoint[value], 16);
                  },
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppContainer(
                            onTap: () {
                              widget.mapController
                                  .move(widget.trashCanPoint[index], 16);
                            },
                            width: MediaQuery.of(context).size.width * 0.82,
                            // color: AppTheme.primaryColor.withOpacity(0.8),
                            color: setColor(widget.trashData[index]['is_full'])
                                .withOpacity(0.8),
                            border: true,
                            borderColor:
                                setColor(widget.trashData[index]['is_full']),
                            padding: AppConstants.paddingAll,
                            child: Column(
                              children: [
                                AppText(
                                  text: "سطل زباله شماره ${index + 1}",
                                  textColor: AppTheme.white,
                                  size: AppTextFontSize.large,
                                  weight: AppTextFontWeight.bold,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.directions,
                                    ),
                                    const AppText(
                                      text: " فاصله شما تا سطل زباله: ",
                                      size: AppTextFontSize.normal,
                                      textColor: AppTheme.white,
                                    ),
                                    AppText(
                                      text: widget.myLocation == null
                                          ? ""
                                          : "${calculatedistance(widget.myLocation!, widget.trashCanPoint[index])} کیلومتر",
                                      size: AppTextFontSize.medium,
                                      weight: AppTextFontWeight.bold,
                                      textColor: AppTheme.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                AppButtons(
                                  onTap: () {
                                    showDetails(index);
                                  },
                                  height: 40,
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        AppTheme.white),
                                  ),
                                  text: "مشاهده جزئیات",
                                  textColor: setColor(
                                      widget.trashData[index]['is_full']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.navigate_before_rounded,
                          color: AppTheme.primaryColor,
                          size: 40,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.navigate_next_rounded,
                          color: AppTheme.primaryColor,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
