import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../blocs/mehrab_bloc.dart';

class QiblaMosqueScreen extends StatefulWidget {
  const QiblaMosqueScreen({super.key});

  @override
  State<QiblaMosqueScreen> createState() => _QiblaMosqueScreenState();
}

class _QiblaMosqueScreenState extends State<QiblaMosqueScreen> {
  bool _mockMosquesCalculated = false;
  List<Map<String, dynamic>> _mosques = [];

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  void _requestLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      context.read<MehrabBloc>().add(UpdateLocationEvent(position.latitude, position.longitude));
      _calculateLocalMosques(position.latitude, position.longitude);
    }
  }

  void _calculateLocalMosques(double lat, double lng) {
    // Elegant local mosque simulation relative to current user coordinates
    setState(() {
      _mosques = [
        {"name": "Masjid Al-Noor", "lat": lat + 0.003, "lng": lng - 0.002, "distance": "320m"},
        {"name": "Grand Jama'a Mosque", "lat": lat - 0.005, "lng": lng + 0.004, "distance": "780m"},
        {"name": "Taqwa Community Mosque", "lat": lat + 0.008, "lng": lng + 0.007, "distance": "1.2km"},
      ];
      _mockMosquesCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MehrabBloc, MehrabState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (context, snapshot) {
                      double direction = snapshot.data?.heading ?? 0;
                      double qiblaDirection = (state.qiblaAngle - direction) % 360;

                      return Column(
                        children: [
                          const Text(
                            "QIBLA FINDER",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.colorScheme.secondary, width: 3),
                                ),
                              ),
                              Transform.rotate(
                                angle: (qiblaDirection * (3.1415926535897932 / 180.0)),
                                child: Icon(Icons.navigation, size: 90, color: theme.colorScheme.secondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Qibla Angle: ${state.qiblaAngle.toStringAsFixed(1)}°",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text("LOCAL MOSQUES", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Divider(),
              if (!_mockMosquesCalculated)
                const Center(child: CircularProgressIndicator())
              else
                ..._mosques.map((m) => Card(
                      margin:const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          child: Icon(Icons.church, color: theme.colorScheme.primary),
                        ),
                        title: Text(m["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Located nearby: ${m["distance"]}"),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Route"),
                        ),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }
}
