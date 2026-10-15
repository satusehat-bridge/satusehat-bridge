# Frequently Asked Questions (FAQ) — SATUSEHAT Bridge

### 1. Apa itu SATUSEHAT Bridge?
SATUSEHAT Bridge adalah lapisan integrasi perantara (*universal integration bridge*) mandiri (*self-hosted*) yang menghubungkan SIMRS rumah sakit/klinik dengan ekosistem Kementerian Kesehatan RI SATUSEHAT (berbasis standar FHIR R4).

### 2. Bagaimana SATUSEHAT Bridge melindungi database SIMRS kami?
Bridge beroperasi dengan prinsip *customer isolation boundary*. Menggunakan **Table Adapter**, SIMRS Anda hanya perlu menulis rekaman data ke tabel staging envelope terpisah. Engine migrasi Bridge (`MigrationSafetyGuard`) secara ketat memblokir modifikasi atau eksekusi DDL terhadap database SIMRS Anda.

### 3. Apakah ada biaya bulanan atau langganan wajib?
**Tidak ada.** Lisensi standar SATUSEHAT Bridge adalah lisensi sekali bayar (*one-time perpetual purchase*) untuk versi yang dibeli. Tidak ada biaya bulanan atau tahunan wajib hanya untuk terus menjalankan versi tersebut.

### 4. Apakah sistem akan berhenti jika server kami terputus dari internet penjual?
**Tidak pernah.** SATUSEHAT Bridge 100% mandiri (*true self-hosted*). Sistem tidak memiliki mekanisme *phone-home*, DRM, atau pemeriksaan lisensi daring ke server penjual.

### 5. Bagaimana kebijakan upgrade jika ada versi baru di kemudian hari?
Anda memiliki hak penggunaan permanen atas versi yang Anda beli. Jika di kemudian hari Pemilik Produk merilis versi yang lebih baru (misalnya penambahan modul baru Kemenkes), Anda dapat memilih untuk tetap menjalankan versi lama atau membeli pembaruan melalui transaksi upgrade terpisah dengan harga diskon pelanggan.

### 6. Apakah kami boleh memasang di server Development dan Production sekaligus?
**Ya, diperbolehkan.** Lisensi 1 fasilitas kesehatan mencakup penggunaan beberapa environment (Development, Staging, Production, Disaster Recovery, Backup) sepanjang seluruhnya digunakan untuk melayani fasilitas kesehatan yang sama.

### 7. Database SIMRS apa saja yang didukung oleh Table Adapter?
Table Adapter mendukung basis data relasional populer:
- PostgreSQL (versi 11+)
- Microsoft SQL Server (versi 2012+)
- MySQL / MariaDB (versi 5.7+ / 10.3+)
- REST API Ingestion langsung (untuk SIMRS berbasis web/API modern)

### 8. Bagaimana prosedur backup dan restore jika terjadi insiden server?
SATUSEHAT Bridge dilengkapi skrip otomatis `./scripts/backup.sh` dan `./scripts/restore.sh` yang membungkus database snapshot, berkas `.env`, metadata versi, dan checksum integritas SHA-256 manifest.
