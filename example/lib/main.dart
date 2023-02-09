import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stage/flutter_stage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'control.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stage',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// Weather condition in English.
enum WeatherCondition {
  cloudy,
  foggy,
  rainy,
  snowy,
  sunny,
  thunderstorm,
  windy,
}

/// Temperature unit of measurement.
enum TemperatureUnit {
  celsius,
  fahrenheit,
}

class _MyHomePageState extends State<MyHomePage> {
  late Scene scene;
  String _location = 'Mountain View, CA';
  num _temperature = 22.0;
  WeatherCondition? _weatherCondition = WeatherCondition.sunny;
  TemperatureUnit? _unit = TemperatureUnit.celsius;

  ClockTimeControl _clockControl = ClockTimeControl();
  ClockHandControl _clockHandControl = ClockHandControl();

  /// Temperature unit of measurement with degrees.
  String get unitString {
    switch (_unit) {
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.celsius:
      default:
        return '°C';
    }
  }

  num _convertFromCelsius(num degreesCelsius) {
    switch (_unit) {
      case TemperatureUnit.fahrenheit:
        return 32.0 + degreesCelsius * 9.0 / 5.0;
      case TemperatureUnit.celsius:
      default:
        return degreesCelsius;
    }
  }

  String enumToString(Object e) => e.toString().split('.').last;

  void _onSceneCreated(Scene scene) {
    this.scene = scene;
    scene.camera.position.setFrom(Vector3(0, 0, 500));
    scene.camera.updateTransform();
  }

  Actor makeBlock({
    required String name,
    required Vector3 position,
    required double size,
    required List<Actor> faces,
  }) {
    final double radius = size / 2 - size * 0.0015;
    return Actor(name: name, position: position, children: [
      Actor(
          name: faces[0].name,
          position: Vector3(0, 0, radius),
          rotation: Vector3(0, 0, 0),
          width: size,
          height: size,
          widget: faces[0].widget,
          children: faces[0].children),
      Actor(
          name: faces[1].name,
          position: Vector3(radius, 0, 0),
          rotation: Vector3(0, 90, 0),
          width: size,
          height: size,
          widget: faces[1].widget,
          children: faces[1].children),
      Actor(
          name: faces[2].name,
          position: Vector3(0, 0, -radius),
          rotation: Vector3(0, 180, 0),
          width: size,
          height: size,
          widget: faces[2].widget,
          children: faces[2].children),
      Actor(
          name: faces[3].name,
          position: Vector3(-radius, 0, 0),
          rotation: Vector3(0, 270, 0),
          width: size,
          height: size,
          widget: faces[3].widget,
          children: faces[3].children),
      Actor(
          name: faces[4].name,
          position: Vector3(0, -radius, 0),
          rotation: Vector3(90, 0, 0),
          width: size,
          height: size,
          widget: faces[4].widget,
          children: faces[4].children),
      Actor(
          name: faces[5].name,
          position: Vector3(0, radius, 0),
          rotation: Vector3(270, 0, 0),
          width: size,
          height: size,
          widget: faces[5].widget,
          children: faces[5].children),
    ]);
  }

  Widget makeBlockFace(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(77, 77, 77, 1.0), width: size * 0.005),
        gradient: LinearGradient(
          colors: [Color.fromRGBO(25, 25, 25, 1.0), Color.fromRGBO(86, 86, 21, 1), Color.fromRGBO(25, 25, 25, 1.0)],
          stops: [0.1, 0.5, 0.9],
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomLeft,
          tileMode: TileMode.repeated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blockSize = 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World!'),
      ),
      body: Stage(
        onSceneCreated: _onSceneCreated,
        children: [
          makeBlock(
            name: 'block',
            position: Vector3(0, 0, 0),
            size: blockSize * 1.1,
            faces: [
              // Front face - Watch
              Actor(
                name: 'front',
                widget: makeBlockFace(blockSize),
                children: [
                  Actor(
                    position: Vector3(0, 0, blockSize * 0.06),
                    width: blockSize,
                    height: blockSize,
                    widget: Container(
                        key: ValueKey('hour'),
                        child: FlareActor('assets/clock/hour.flr', animation: 'idle', controller: _clockControl)),
                  ),
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize,
                    height: blockSize,
                    widget: Container(key: ValueKey('minute'), child: FlareActor('assets/clock/minute.flr')),
                  ),
                  Actor(
                    position: Vector3(0, 0, blockSize * 0.068),
                    width: blockSize,
                    height: blockSize,
                    widget: Container(
                        key: ValueKey('hour_hand'),
                        child: FlareActor('assets/clock/hand.flr', controller: _clockHandControl)),
                  ),
                ],
              ),
              // Right face - Month, Date, Day
              Actor(
                name: 'right',
                widget: makeBlockFace(blockSize),
                children: [
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize,
                    height: blockSize * 0.85,
                    widget: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            DateFormat('MMMM').format(DateTime.now()),
                            style: TextStyle(fontSize: blockSize * 0.15, color: Color.fromARGB(255, 125, 166, 255)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            DateFormat('EEEE').format(DateTime.now()),
                            style: TextStyle(fontSize: blockSize * 0.13, color: Color.fromARGB(255, 125, 166, 255)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Actor(
                    position: Vector3(0, 0, blockSize * 0.02),
                    width: blockSize,
                    height: blockSize,
                    widget: Center(
                      child: Text(
                        DateFormat('d').format(DateTime.now()),
                        style: TextStyle(
                            fontSize: blockSize * 0.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize,
                    height: blockSize,
                    widget: Center(
                      child: Text(
                        DateFormat('d').format(DateTime.now()),
                        style: TextStyle(
                            fontSize: blockSize * 0.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ],
              ),
              // Back Face - Rhinoceros Image
              Actor(
                name: 'back',
                widget: makeBlockFace(blockSize),
                children: [
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize * 1.0,
                    height: blockSize * 1.0,
                    widget: Image(
                      image: AssetImage('assets/rhinoceros.png'),
                    ),
                  ),
                ],
              ),
              // Left Face - Location, Temperture
              Actor(
                name: 'left',
                widget: makeBlockFace(blockSize),
                children: [
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize,
                    height: blockSize * 0.85,
                    widget: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: FittedBox(
                              child: Text(
                            _location,
                            style: TextStyle(
                              fontSize: blockSize * 0.09,
                              color: Colors.white.withOpacity(0.35),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                  Actor(
                    position: Vector3(0, 0, blockSize * 0.12),
                    width: blockSize,
                    height: blockSize,
                    widget: Center(
                      child: Text(
                        _convertFromCelsius(_temperature).toStringAsFixed(0) + unitString,
                        style: TextStyle(fontSize: blockSize / 3, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize,
                    height: blockSize,
                    widget: Center(
                      child: Text(
                        _convertFromCelsius(_temperature).toStringAsFixed(0) + unitString,
                        style: TextStyle(fontSize: blockSize / 3, color: Colors.black.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ],
              ),
              // Top Face - Cow Image
              Actor(
                name: 'top',
                widget: makeBlockFace(blockSize),
                children: [
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize * 1.0,
                    height: blockSize * 1.0,
                    widget: Opacity(
                      opacity: 0.5,
                      child: Image(
                        image: AssetImage('assets/cow.png'),
                      ),
                    ),
                  ),
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize,
                    height: blockSize,
                    widget: Center(
                      child: Text(
                        'Highland Cow',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                          fontSize: blockSize / 5,
                          color: Color.fromARGB(128, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Actor(
                    position: Vector3(0, 0, blockSize * 0.04),
                    width: blockSize,
                    height: blockSize,
                    widget: Center(
                      child: Text(
                        'Highland Cow',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: blockSize / 5,
                            letterSpacing: 0.5,
                          ),
                        ),
                        // style: TextStyle(
                        //   fontSize: blockSize / 5,
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom Face - Dragon Image
              Actor(
                name: 'bottom',
                widget: makeBlockFace(blockSize),
                children: [
                  Actor(
                    position: Vector3(0, 0, 0),
                    width: blockSize * 1.0,
                    height: blockSize * 1.0,
                    widget: Image(
                      image: AssetImage('assets/dragon.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
