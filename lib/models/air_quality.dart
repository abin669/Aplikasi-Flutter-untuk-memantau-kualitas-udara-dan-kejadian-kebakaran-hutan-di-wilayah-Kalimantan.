class AirQuality {
  final double pm25;
  final double pm10;
  final int usAqi;
  final String time;
  final double latitude;
  final double longitude;

  AirQuality({
    required this.pm25,
    required this.pm10,
    required this.usAqi,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return AirQuality(
      pm25: (current['pm2_5'] as num).toDouble(),
      pm10: (current['pm10'] as num).toDouble(),
      usAqi: (current['us_aqi'] as num).toInt(),
      time: current['time'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Kategori AQI berdasarkan standar US EPA
  String get category {
    if (usAqi <= 50) return 'Baik';
    if (usAqi <= 100) return 'Sedang';
    if (usAqi <= 150) return 'Tidak Sehat bagi Kelompok Sensitif';
    if (usAqi <= 200) return 'Tidak Sehat';
    if (usAqi <= 300) return 'Sangat Tidak Sehat';
    return 'Berbahaya';
  }

  /// Warna berdasarkan kategori AQI
  int get colorValue {
    if (usAqi <= 50) return 0xFF00E400; // Hijau
    if (usAqi <= 100) return 0xFFFFFF00; // Kuning
    if (usAqi <= 150) return 0xFFFF7E00; // Oranye
    if (usAqi <= 200) return 0xFFFF0000; // Merah
    if (usAqi <= 300) return 0xFF8F3F97; // Ungu
    return 0xFF7E0023; // Maroon (Berbahaya)
  }

    /// Waktu data dalam WIB, contoh: 22 Okt 2026, 18.00 WIB
  String get formattedTimeWib {
    final utc = DateTime.tryParse('${time}Z');
    if (utc == null) return time;
    final wib = utc.add(const Duration(hours: 7));
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final jam = wib.hour.toString().padLeft(2, '0');
    final menit = wib.minute.toString().padLeft(2, '0');
    return '${wib.day} ${bulan[wib.month - 1]} ${wib.year}, $jam.$menit WIB';
  }
}