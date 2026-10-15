# Model Keamanan & Isolasi Data — SATUSEHAT Bridge

SATUSEHAT Bridge memprioritaskan keamanan data medis pasien dan kerahasiaan fasyankes:

## 1. Enkripsi Kredensial at Rest
Kredensial institusi Kemenkes (`client_secret`) dienkripsi pada tingkat kolom basis data menggunakan algoritma standar industri **AES-256-CBC** dengan otentikasi MAC. Kunci enkripsi tersimpan eksklusif di server fasyankes Anda pada parameter `APP_KEY`.

## 2. Isolasi Tenant Tunggal
Setiap instalasi terikat secara mutlak ke satu `rumah_sakit_id`. Ingestion API secara ketat menolak setiap upaya penyusupan atau manipulasi ID fasyankes dengan HTTP 403 Forbidden.

## 3. Autentikasi Ingestion Berbasis Hashing
Kunci API (`api_key`) untuk SIMRS hanya disimpan dalam basis data Bridge dalam format hash aman SHA-256 (`key_hash`). Plaintext kunci tidak pernah disimpan dalam basis data atau dicetak ke log.

## 4. Perlindungan Basis Data SIMRS (Customer Boundary)
Modul migrasi Bridge (`MigrationSafetyGuard`) memverifikasi target database sebelum menjalankan migrasi. Jika terdeteksi koneksi mengarah ke database milik SIMRS, proses migrasi langsung dibatalkan demi melindungi data rumah sakit.

## 5. Zero Telemetry & Zero DRM
Bridge beroperasi secara mandiri tanpa dependensi panggilan balik (*phone-home*) atau pengiriman telemetri rahasia ke server pengembang.
