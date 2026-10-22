class WildfireEvent {
  final String id;
  final String title;
  final String? closed;
  final DateTime? date;
  final double? magnitudeValue;
  final String? magnitudeUnit;
  final double? latitude;
  final double? longitude;
  final String? sourceUrl;

  WildfireEvent({
    required this.id,
    required this.title,
    this.closed,
    this.date,
    this.magnitudeValue,
    this.magnitudeUnit,
    this.latitude,
    this.longitude,
    this.sourceUrl,
  });

  factory WildfireEvent.fromJson(Map<String, dynamic> json) {
    DateTime? eventDate;
    double? lat;
    double? lon;
    double? magValue;
    String? magUnit;

    final geometries = json['geometry'] as List<dynamic>?;
    if (geometries != null && geometries.isNotEmpty) {
      final geo = geometries.first as Map<String, dynamic>;
      if (geo['date'] != null) {
        eventDate = DateTime.tryParse(geo['date'] as String);
      }
      magValue = (geo['magnitudeValue'] as num?)?.toDouble();
      magUnit = geo['magnitudeUnit'] as String?;

      final coords = geo['coordinates'] as List<dynamic>?;
      if (coords != null && coords.length >= 2) {
        lon = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    }

    String? sourceUrl;
    final sources = json['sources'] as List<dynamic>?;
    if (sources != null && sources.isNotEmpty) {
      sourceUrl = (sources.first as Map<String, dynamic>)['url'] as String?;
    }

    return WildfireEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      closed: json['closed'] as String?,
      date: eventDate,
      magnitudeValue: magValue,
      magnitudeUnit: magUnit,
      latitude: lat,
      longitude: lon,
      sourceUrl: sourceUrl,
    );
  }

  /// Event dianggap selesai jika EONET mengisi field "closed".
  bool get isClosed => closed != null;

  String get formattedDate {
    if (date == null) return '-';
    return '${date!.day.toString().padLeft(2, '0')}/'
        '${date!.month.toString().padLeft(2, '0')}/'
        '${date!.year}';
  }

  /// Contoh: "120 acres". Jika tidak ada data, tampil "-".
  String get magnitudeText {
    final value = magnitudeValue;
    if (value == null) return '-';
    final angka = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
    final unit = magnitudeUnit;
    return unit == null || unit.isEmpty ? angka : '$angka $unit';
  }
}