# 🥗 NutriSport — Aplikasi Nutrisi & Recovery Atlet

![Flutter](https://img.shields.io/badge/Flutter-Mobile%20App-02569B?logo=flutter)
![Hive](https://img.shields.io/badge/Hive-Local%20Database-F7CD46?logo=hive)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Android](https://img.shields.io/badge/Platform-Android-green?logo=android)
![VSCode](https://img.shields.io/badge/VSCode-Dev%20Environment-007ACC?logo=visualstudiocode)

---

## 📋 Deskripsi
**NutriSport** adalah aplikasi mobile yang membantu atlet, pelatih, dan individu aktif dalam mengatur **kebutuhan nutrisi harian, hidrasi, serta jadwal suplemen** guna mendukung performa dan pemulihan tubuh.  
Aplikasi ini dapat digunakan secara **offline** dengan penyimpanan data lokal.

---

## ⚙️ Teknologi yang Digunakan

| Komponen | Teknologi |
|---------|-----------|
| 🎨 Framework UI | **Flutter** |
| 🧠 Perhitungan Gizi | Rumus TDEE + Distribusi Makro (Dart) |
| 💾 Penyimpanan Data Offline | **Hive** + Shared Preferences |
| 🔔 Notifikasi Pengingat | **Flutter Local Notifications** |
| 🧰 Development Tools | VS Code / Android Studio |

---

## 🚀 Fitur Utama

- 🔢 **Kalkulator Kebutuhan Gizi**
  - Menghitung TDEE & makronutrien (protein, karbo, lemak)
  - Berdasarkan data tubuh, intensitas olahraga, dan tujuan (cutting/bulking/maintenance)

- 💧 **Pemantauan Hidrasi**
  - Mencatat konsumsi air harian
  - Rekomendasi volume hidrasi

- 🍱 **Rekomendasi Menu**
  - Disesuaikan dengan jenis olahraga (endurance, strength, mix)
  - Dibagi fase: pre-workout, intra-workout, post-workout

- ⏰ **Reminder Makan & Suplemen**
  - Notifikasi terjadwal harian

- 📈 **Tracking Harian**
  - Logging berat badan dan catatan latihan
  - Grafik progres
