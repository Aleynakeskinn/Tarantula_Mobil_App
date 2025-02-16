import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RobotDataScreen(),
    );
  }
}

class RobotDataScreen extends StatefulWidget {
  const RobotDataScreen({Key? key}) : super(key: key);

  @override
  _RobotDataScreenState createState() => _RobotDataScreenState();
}

class _RobotDataScreenState extends State<RobotDataScreen> {
  DateTime selectedDate = DateTime.now();
  Uint8List? imageData;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
  }

  // Cihaz tarama işlevi
  void scanForDevices() async {
    final status = await Permission.bluetoothScan.request();
    if (status.isGranted) {
      setState(() => isScanning = true);

      // Bluetooth cihazlarını tarama işlemlerini burada gerçekleştir
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
      var subscription = FlutterBlue.instance.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('${r.device.name} found! rssi: ${r.rssi}');
        }
      });

      await Future.delayed(Duration(seconds: 4));
      FlutterBlue.instance.stopScan();
      subscription.cancel();

      setState(() => isScanning = false);
    } else {
      print('Bluetooth scanning requires permission.');
    }
  }

  // Tarih seçim dialogunu göster
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.bluetooth, color: isScanning ? Colors.blue : Colors.black),
              onPressed: scanForDevices,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () => _selectDate(context),
            ),
            Text(
              DateFormat('dd.MM.yyyy').format(selectedDate),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: imageData == null
                ? const Center(child: Text('No Image Received'))
                : Image.memory(imageData!),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                DataBar(
                  iconData: Icons.thermostat,
                  label: 'Temperature',
                  value: '24°C',
                ),
                DataBar(
                  iconData: Icons.speed,
                  label: 'Pressure',
                  value: '1013 hPa',
                ),
                DataBar(
                  iconData: Icons.gps_fixed,
                  label: 'GPS',
                  value: '37.7749° N, 122.4194° W',
                ),
              ],
            ),
          ),
        ],
      ),
      // BottomAppBar ve ilgili butonu kaldırdık
    );
  }
}

class DataBar extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  const DataBar({
    Key? key,
    required this.iconData,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Icon(iconData),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 18.0)),
          ),
          Text(value, style: const TextStyle(fontSize: 18.0), textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
