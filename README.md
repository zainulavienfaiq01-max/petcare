# petcare_apk
# 🐾 Pet Care Reminder

Pet Care Reminder adalah aplikasi berbasis Flutter yang dirancang untuk membantu pemilik hewan peliharaan dalam mengelola jadwal perawatan, kesehatan, dan aktivitas hewan secara efektif melalui sistem pengingat otomatis.

---

## 📖 Latar Belakang

Banyak pemilik hewan peliharaan mengalami kesulitan dalam mengatur jadwal pemberian makan, vaksinasi, pemberian vitamin, serta pemeriksaan kesehatan rutin karena aktivitas sehari-hari yang padat. Akibatnya, jadwal perawatan sering terlupakan dan dapat berdampak pada kesehatan hewan.

Selain itu, pencatatan kesehatan hewan masih banyak dilakukan secara manual sehingga informasi mudah hilang. Oleh karena itu, dibutuhkan sebuah aplikasi yang mampu membantu pengguna dalam mengelola seluruh aktivitas perawatan hewan secara terstruktur dan mudah digunakan.

---

## 🎯 Tujuan

* Membantu pengguna mengelola jadwal perawatan hewan.
* Memberikan pengingat otomatis melalui notifikasi.
* Menyimpan riwayat kesehatan hewan.
* Memudahkan pemantauan aktivitas hewan peliharaan.

---

## ✨ Fitur Utama

### 🐶 Manajemen Hewan

* Menambahkan data hewan
* Mengubah data hewan
* Menghapus data hewan
* Menambahkan foto hewan

### ⏰ Pengingat Jadwal

* Jadwal makan
* Jadwal minum
* Jadwal vaksin
* Jadwal vitamin
* Jadwal grooming
* Notifikasi dan getaran otomatis

### 🩺 Riwayat Kesehatan

* Riwayat vaksin
* Riwayat penyakit
* Catatan kesehatan
* Riwayat pengobatan

### 📚 Pet Library

* Informasi ras hewan
* Deskripsi hewan
* Dukungan multi bahasa

### 📊 Statistik

* Total aktivitas
* Jadwal selesai
* Jadwal terlewat

---

## 🏗️ Blueprint Sistem

### Struktur Halaman

```text
Splash Screen
     ↓
Home Screen
     ↓
Pet List
     ↓
Pet Detail
     ↓
Schedule
     ↓
Health Record
     ↓
Pet Library
     ↓
Statistics
```

### Arsitektur Aplikasi

```text
UI Layer
    ↓
Controller/Provider
    ↓
Service Layer
    ↓
Local Database
```

### Struktur Data

#### Pet

* id
* name
* species
* breed
* age
* gender
* weight

#### Schedule

* id
* petId
* type
* dateTime
* repeat
* isCompleted

#### Health Record

* id
* petId
* title
* description
* date

---

## 🛠️ Teknologi

* Flutter
* Dart
* ObjectBox/Hive
* Local Notifications
* Shared Preferences

---

## 🚀 Future Development

* Cloud synchronization
* Backup and restore
* AI recommendation
* Home screen widget
* Calendar integration

```
```


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
