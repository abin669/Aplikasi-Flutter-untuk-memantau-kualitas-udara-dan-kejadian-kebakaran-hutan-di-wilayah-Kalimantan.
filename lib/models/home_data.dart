import 'air_quality.dart';
import 'wildfire_event.dart';

class HomeData {
  final AirQuality airQuality;
  final List<WildfireEvent> wildfires;

  HomeData({required this.airQuality, required this.wildfires});
}