import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedLinearGradient(),
    );
  }
}

class AnimatedLinearGradient extends StatefulWidget {
  @override
  _AnimatedLinearGradientState createState() => _AnimatedLinearGradientState();
}

class _AnimatedLinearGradientState extends State<AnimatedLinearGradient> {
  // List of colors the gradient will cycle through endlessly
  List<Color> colorsList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  // Starting values to variables
  int index = 0;
  Color leftColor = Colors.red;
  Color rightColor = Colors.orange;

  static const platform = const MethodChannel('samples.flutter.dev/location');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Linear Gradient"),
      ),

      /// Using stack to stack widgets on top of one another.
      /// Animated container, play button to initiate animation, then
      /// the device location text are created in that order
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
            alignment: Alignment.bottomLeft,
            duration: Duration(seconds: 1),
            onEnd: () {
              /// Animate the linear gradient and rebuild widget every second
              /// with a different value for index, topColor and bottomColor each time
              setState(() {
                index = index + 1;
                leftColor = colorsList[index % colorsList.length];
                rightColor = colorsList[(index + 1) % colorsList.length];
              });
            },
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [leftColor, rightColor],
              // Animate left to right for linear animation
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RaisedButton(
                  child: const Text("Begin!"),
                  onPressed: () {
                    // Set blue as the primary color
                    setState(() {
                      _getLatitude();
                      _getLongitude();
                      rightColor = Colors.blue;
                    });
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Latitude: $_latitude",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Text("Longitude: $_longitude",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Get latitude and longitude
  double _latitude = 0.0;
  double _longitude = 0.0;

  Future<void> _getLatitude() async {
    double latitude = 0.0;
    try {
      final double latResult = await platform.invokeMethod('getLatitude');
      latitude = latResult;
    } on PlatformException catch (e) {
      print(e.message);
    }

    setState(() {
      _latitude = latitude;
    });
  }

  Future<void> _getLongitude() async {
    double longitude = 0.0;
    try {
      final double longResult = await platform.invokeMethod('getLongitude');
      longitude = longResult;
    } on PlatformException catch (e) {
      print(e.message);
    }

    setState(() {
      _longitude = longitude;
    });
  }
}
