import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/air_quality.dart';
import '../models/home_data.dart';
import '../models/wildfire_event.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  // Open-Meteo Air Quality API (koordinat sekitar Palangka Raya / Kalteng)
  static const String _airQualityUrl =
      'https://air-quality-api.open-meteo.com/v1/air-quality'
      '?latitude=-2.21&longitude=113.92'
      '&current=pm2_5,pm10,us_aqi';

  // NASA EONET Wildfire Events (bbox Kalimantan)
  static const String _wildfireUrl =
      'https://eonet.gsfc.nasa.gov/api/v3/events'
      '?category=wildfires'
      '&bbox=108,5,119,-4.5'
      '&status=all'
      '&limit=50';

  static const Duration _timeout = Duration(seconds: 15);

  Future<http.Response> _get(String url) async {
    try {
      return await http.get(Uri.parse(url)).timeout(_timeout);
    } on TimeoutException {
      throw ApiException(
          'Permintaan melebihi batas waktu. Periksa koneksi internet Anda.');
    } catch (_) {
      throw ApiException(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  Future<AirQuality> fetchAirQuality() async {
    final response = await _get(_airQualityUrl);

    if (response.statusCode != 200) {
      throw ApiException(
          'Gagal mengambil data kualitas udara (kode ${response.statusCode}).');
    }

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AirQuality.fromJson(data);
    } catch (_) {
      throw ApiException('Data kualitas udara tidak dapat diproses.');
    }
  }

  Future<List<WildfireEvent>> fetchWildfires() async {
    final response = await _get(_wildfireUrl);

    if (response.statusCode != 200) {
      throw ApiException(
          'Gagal mengambil data kebakaran hutan (kode ${response.statusCode}).');
    }

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final events = data['events'] as List<dynamic>? ?? [];
      return events
          .map((e) => WildfireEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw ApiException('Data kebakaran hutan tidak dapat diproses.');
    }
  }

  /// Mengambil kedua data sekaligus (paralel).
  Future<HomeData> fetchHomeData() async {
    final results = await Future.wait([fetchAirQuality(), fetchWildfires()]);
    return HomeData(
      airQuality: results[0] as AirQuality,
      wildfires: results[1] as List<WildfireEvent>,
    );
  }
}