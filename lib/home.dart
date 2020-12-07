import 'dart:async';

import 'package:SeeThroughMe/bounding_box.dart';
import 'package:SeeThroughMe/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  final List<String> phoneNos;

  const HomePage({this.phoneNos});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  bool _loading = false;
  int _imageHeight = 0;
  int _imageWidth = 0;
  List<dynamic> _recognitions;
  Position _position;
  String recipientAddress = "+919900339134";
  SmsSender sender = SmsSender();
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 10), (Timer t) => getLocation());
    //getLocation();
    loadAllAsync();
  }

  @override
  void dispose() {
    _controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  sendSms() {
    widget.phoneNos.forEach((number) {
      sender.sendSms(SmsMessage(number, "Hello, this is my location https://www.google.com/maps/search/?api=1&query=${_position.latitude},${_position.longitude}"));
    });
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString() + "\n" + position.longitude.toString());
    setState(() {
      _position = position;
    });
    sendSms();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadAllAsync() async {
    setState(() => _loading = true);
    final cameras = await availableCameras();
    String res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/label.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
    print("Result from tf: $res");
    setState(() {
      _cameras = cameras;
      _loading = false;
    });
    _controller = CameraController(_cameras.first, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (!_controller.value.isInitialized) {
        return Container();
      }
      return Stack(
        children: [
          Camera(_cameras, setRecognitions),
          BoundingBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.width, screen.height
          )
        ],
      );
    }
  }
}
