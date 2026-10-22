# Kalimantan Air & Fire Monitor

Aplikasi Flutter untuk memantau **kualitas udara** dan **kejadian kebakaran hutan** di wilayah Kalimantan.

## Fitur

- Menampilkan data kualitas udara terkini (PM2.5, PM10, US AQI) dari Open-Meteo Air Quality API
- Menampilkan daftar kejadian kebakaran hutan dari NASA EONET API
- UI berwarna sesuai level AQI (hijau → kuning → oranye → merah → ungu → maroon)
- Pull-to-refresh & tombol refresh
- Loading indicator & error handling

## API yang Digunakan

1. **Open-Meteo Air Quality**  
   `https://air-quality-api.open-meteo.com/v1/air-quality?latitude=-2.21&longitude=113.92&current=pm2_5,pm10,us_aqi`

2. **NASA EONET Events (Wildfires)**  
   `https://eonet.gsfc.nasa.gov/api/v3/events?category=wildfires&bbox=108,5,119,-4.5&status=all&limit=50`

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terinstall (`flutter doctor`)
2. Clone atau unduh project ini
3. Jalankan perintah berikut di terminal:

```bash
flutter pub get
flutter run
```
