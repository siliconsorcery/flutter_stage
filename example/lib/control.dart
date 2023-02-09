import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';

class ClockTimeControl extends FlareControls {
  ActorAnimation? hourAnimation;
  ActorAnimation? minuteAnimation;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    final DateTime dateTime = DateTime.now();

    if (hourAnimation != null) {
      hourAnimation!.apply((hourAnimation!.duration * (dateTime.hour % 12) / 12).truncateToDouble(), artboard, 1.0);
    }
    if (minuteAnimation != null) {
      minuteAnimation!.apply((minuteAnimation!.duration * dateTime.minute / 60).truncateToDouble(), artboard, 1.0);
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    hourAnimation = artboard.getAnimation('hour');
    minuteAnimation = artboard.getAnimation('minute');
  }
}

class ClockHandControl extends FlareControls {
  ActorAnimation? hourAnimation;
  ActorAnimation? minuteAnimation;
  ActorAnimation? secondAnimation;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    final DateTime dateTime = DateTime.now();
    final double second = dateTime.second + dateTime.millisecond / 1000;
    final double minute = dateTime.minute + second / 60;
    final double hour = dateTime.hour % 12 + minute / 60;

    if (hourAnimation != null) {
      hourAnimation!.apply(hourAnimation!.duration * hour / 12, artboard, 1.0);
    }

    if (minuteAnimation != null) {
      minuteAnimation!.apply(minuteAnimation!.duration * minute / 60, artboard, 1.0);
    }
    if (secondAnimation != null) {
      secondAnimation!.apply(secondAnimation!.duration * second / 60, artboard, 1.0);
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    hourAnimation = artboard.getAnimation('hour');
    minuteAnimation = artboard.getAnimation('minute');
    secondAnimation = artboard.getAnimation('second');
  }
}
