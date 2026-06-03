import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double ax = 0;
  double ay = 0;
  double az = 0;

  double gx = 0;
  double gy = 0;
  double gz = 0;

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((event) {
      setState(() {
        ax = event.x;
        ay = event.y;
        az = event.z;
      });
    });

    gyroscopeEvents.listen((event) {
      setState(() {
        gx = event.x;
        gy = event.y;
        gz = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Accelerometer",
              style: TextStyle(fontSize: 22),
            ),
            Text("X : $ax"),
            Text("Y : $ay"),
            Text("Z : $az"),
            const SizedBox(height: 30),
            const Text(
              "Gyroscope",
              style: TextStyle(fontSize: 22),
            ),
            Text("X : $gx"),
            Text("Y : $gy"),
            Text("Z : $gz"),
          ],
        ),
      ),
    );
  }
}