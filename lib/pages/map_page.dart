import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentPosition = const LatLng(-6.200000, 106.816666);

  bool loading = true;

  final mapController = MapController();

  List<Marker> cinemaMarkers = [];

  final List<Map<String, dynamic>> cinemas = [
    {
      "name": "XXI Ambarukmo Plaza",
      "lat": -7.7828,
      "lng": 110.4018,
    },
    {
      "name": "CGV Jwalk Mall",
      "lat": -7.7821,
      "lng": 110.4095,
    },
    {
      "name": "Cinepolis Lippo Plaza Jogja",
      "lat": -7.7825,
      "lng": 110.3678,
    },
    {
      "name": "XXI Jogja City Mall",
      "lat": -7.7475,
      "lng": 110.3555,
    },
    {
      "name": "CGV Pakuwon Mall Jogja",
      "lat": -7.7580,
      "lng": 110.3692,
    },
    {
      "name": "Empire XXI",
      "lat": -7.7829,
      "lng": 110.3748,
    },
    {
      "name": "Sleman City Hall XXI",
      "lat": -7.7169,
      "lng": 110.3554,
    },
    {
      "name": "The Premiere Ambarukmo",
      "lat": -7.7828,
      "lng": 110.4018,
    },
  ];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(
      lat1,
      lon1,
      lat2,
      lon2,
    );
  }

  Future<void> openNavigation(
    double lat,
    double lng,
  ) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();

    currentPosition = LatLng(
      position.latitude,
      position.longitude,
    );

    loadCinemaMarkers();

    setState(() {
      loading = false;
    });
  }

  void loadCinemaMarkers() {
    cinemaMarkers.clear();

    cinemaMarkers.add(
      Marker(
        point: currentPosition,
        width: 60,
        height: 60,
        child: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 40,
        ),
      ),
    );

    cinemas.sort((a, b) {
      double da = calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        a["lat"],
        a["lng"],
      );

      double db = calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        b["lat"],
        b["lng"],
      );

      return da.compareTo(db);
    });

    for (var cinema in cinemas) {
      cinemaMarkers.add(
        Marker(
          point: LatLng(
            cinema["lat"],
            cinema["lng"],
          ),
          width: 60,
          height: 60,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(cinema["name"]),
                  content: Text(
                    "Bioskop terdekat yang tersedia",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(
              Icons.movie,
              color: Colors.blue,
              size: 35,
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cinema Nearby"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: currentPosition,
                      initialZoom: 12,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.tiketbioskop',
                      ),
                      MarkerLayer(
                        markers: cinemaMarkers,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cinemas.length,
                    itemBuilder: (context, index) {
                      final cinema = cinemas[index];

                      double distance = calculateDistance(
                            currentPosition.latitude,
                            currentPosition.longitude,
                            cinema["lat"],
                            cinema["lng"],
                          ) /
                          1000;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.movie,
                            color: Colors.blue,
                          ),
                          title: Text(cinema["name"]),
                          subtitle: Text(
                            "${distance.toStringAsFixed(1)} km dari lokasi Anda",
                          ),
                          onTap: () {
                            mapController.move(
                              LatLng(
                                cinema["lat"],
                                cinema["lng"],
                              ),
                              16,
                            );

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(cinema["name"]),
                                content: Text(
                                  "Jarak ${distance.toStringAsFixed(1)} km",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      openNavigation(
                                        cinema["lat"],
                                        cinema["lng"],
                                      );
                                    },
                                    child: const Text(
                                      "Navigasi",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Tutup",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
