import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/button/button.dart';
import 'package:smarttrashcan/widgets/container/appcontainer.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  MapController mapController = MapController();
  LatLng? center;
  LatLng? myLocation;

  List<LatLng> pointsDirection = [];
  List<LatLng> trashCanPoint = [
    const LatLng(36.7005, 52.6502),
  ];

  showDetails(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                30,
              ),
              topRight: Radius.circular(
                30,
              ),
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
                    const AppText(
                      text: "سطل زباله شماره 1",
                      textColor: AppTheme.white,
                      size: AppTextFontSize.large,
                      weight: AppTextFontWeight.bold,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.layers,
                        ),
                        AppText(
                          text: " سطح: ",
                          size: AppTextFontSize.normal,
                          textColor: AppTheme.white,
                        ),
                        AppText(
                          text: "20%",
                          size: AppTextFontSize.medium,
                          weight: AppTextFontWeight.bold,
                          textColor: AppTheme.white,
                        ),
                      ],
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
                          text: myLocation == null
                              ? ""
                              : "${calculatedistance(myLocation!, trashCanPoint[index])} کیلومتر",
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
                  // if (myLocation != null) {
                  //   updateRoute(
                  //     myLocation!,
                  //     trashCanPoint[index],
                  //   );
                  Navigator.pop(context);
                  // }
                },
                height: 50,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppTheme.white),
                ),
                text: "مسیریابی",
                textColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getMyLocation() async {
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
    mapController.move(myLocation!, 16.5);
  }

  calculatedistance(LatLng start, LatLng end) {
    double distance = const Distance().as(LengthUnit.Meter, start, end);
    return (distance / 1000).toStringAsFixed(2);
  }

//widget******************************

  Widget trashMark() {
    return MarkerLayer(
      markers: List.generate(
        trashCanPoint.length,
        (index) => Marker(
          point: trashCanPoint[index],
          builder: (context) => AppContainer(
            onTap: () {
              showDetails(index);
            },
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
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 8.0,
                    backgroundColor: AppTheme.primaryColor,
                    child: AppText(
                      text: "1",
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
          point: myLocation!,
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
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: center,
            zoom: 8.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),

            //show trashcan position
            if (trashCanPoint.isNotEmpty) trashMark(),

            //show my location
            if (myLocation != null) myLocationMark(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            getMyLocation();
          },
          child: const Icon(
            Icons.my_location,
            color: AppTheme.iconColor,
          ),
        ),
      ),
    );
  }
}
