# SATUSEHAT Bridge — Universal SIMRS Integration Layer

[![Lisensi](https://img.shields.io/badge/License-Commercial%20Perpetual%20(Single%20Facility)-blue.svg)](#lisensi--model-komersial)
[![Basis Data](https://img.shields.io/badge/Database-PostgreSQL%2015%20%7C%20Redis%207-green.svg)](#persyaratan-sistem)
[![Arsitektur](https://img.shields.io/badge/Architecture-Dual--Adapter%20%2B%20Queue%20Worker-orange.svg)](#arsitektur-sistem)
[![SATUSEHAT](https://img.shields.io/badge/FHIR%20R4-29%20Resources%20Parity-red.svg)](#katalog-29-resource-terverifikasi)

> 🌐 **Kunjungi Web Portal Interaktif & Live Technical AI Agent:**  
> 👉 **[https://satusehat-bridge.github.io/satusehat-bridge/](https://satusehat-bridge.github.io/satusehat-bridge/)** *(Eksplorasi 47 Profil Playbook, Pencarian LOINC/SNOMED, Komparasi TCO, dan Form Pemesanan Lisensi)*

**SATUSEHAT Bridge** adalah lapisan integrasi universal (*Universal Integration Bridge*) mandiri (*self-hosted*) yang dirancang khusus untuk menghubungkan Sistem Informasi Manajemen Rumah Sakit (SIMRS) dengan platform **Kemenkes SATUSEHAT (FHIR R4)** tanpa perlu merombak basis data atau arsitektur inti SIMRS Anda.

Disediakan dalam bentuk **Full Source Code** mandiri, SATUSEHAT Bridge memberikan kendali penuh, keamanan data fasyankes maksimal, dan kebebasan operasional tanpa biaya bulanan wajib serta tanpa penguncian vendor (*no vendor lock-in*).

---

## 🌟 Mengapa Memilih SATUSEHAT Bridge?

1. **Dual Ingestion Engine (Pilihan Fleksibel untuk Segala SIMRS):**
   - **REST API JSON Adapter:** Endpoint HTTP modern dengan autentikasi API Key terisolasi server-side dan proteksi idempotensi per transaksi.
   - **Shared Table Adapter:** Pola integrasi non-intrusif untuk SIMRS legacy berbasis **Microsoft SQL Server, MySQL, atau PostgreSQL**. SIMRS cukup menulis ke 1 tabel staging envelope tanpa akses langsung ke basis data internal Bridge.
2. **Kemandirian Operasional 100% (True Self-Hosted):**
   - Berjalan di server atau cloud milik rumah sakit sendiri.
   - **ZERO Phone-Home & ZERO DRM:** Tidak ada ketergantungan runtime ke server luar, tidak ada validasi lisensi online, dan sistem tidak akan mati mendadak karena masalah koneksi internet vendor.
3. **Piagam Keselamatan Data (Zero Data Loss):**
   - Didukung antrean Redis asinkron, retry eksponensial berbatas, dead-letter queue, dan lease recovery untuk menjamin tidak ada transaksi rekam medis yang hilang.
   - Guard keamanan migrasi (`MigrationSafetyGuard`) yang secara ketat memblokir perubahan tidak sah pada tabel SIMRS klien.
4. **Paritas Penuh 29 Entitas Resource Kanonikal & 47 Profil Playbook Kemenkes:**
   - Seluruh 29 resource terverifikasi didukung secara identik baik melalui REST API maupun Table Adapter.

---

## 🏗️ Arsitektur Sistem

```
┌────────────────────────────────────────────────────────────────────────┐
│                        LINGKUNGAN SIMRS FASYANKES                      │
│                                                                        │
│   ┌───────────────────────────┐      ┌─────────────────────────────┐   │
│   │    SIMRS Modern (REST)    │      │    SIMRS Legacy (DB SQL)    │   │
│   └─────────────┬─────────────┘      └──────────────┬──────────────┘   │
└─────────────────┼───────────────────────────────────┼──────────────────┘
                  │ HTTP POST JSON                    │ INSERT Staging Row
                  ▼                                   ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   SATUSEHAT BRIDGE (SELF-HOSTED ENGINE)                │
│                                                                        │
│   ┌───────────────────────────┐      ┌─────────────────────────────┐   │
│   │     REST Ingestion API    │      │   Table Adapter Poller      │   │
│   └─────────────┬─────────────┘      └──────────────┬──────────────┘   │
│                 │                                   │                  │
│                 └─────────────────┬─────────────────┘                  │
│                                   ▼                                    │
│                 ┌───────────────────────────────────┐                  │
│                 │      Model Kanonikal Domain       │                  │
│                 └─────────────────┬─────────────────┘                  │
│                                   ▼                                    │
│                 ┌───────────────────────────────────┐                  │
│                 │     Antrean Pengiriman (Redis)    │                  │
│                 └─────────────────┬─────────────────┘                  │
│                                   ▼                                    │
│                 ┌───────────────────────────────────┐                  │
│                 │      Worker & Retry State Machine │                  │
│                 └─────────────────┬─────────────────┘                  │
│                                   ▼                                    │
│                 ┌───────────────────────────────────┐                  │
│                 │     FHIR R4 Serializer & OAuth2   │                  │
│                 └─────────────────┬─────────────────┘                  │
└───────────────────────────────────┼────────────────────────────────────┘
                                    │ HTTPS (TLS 1.2 / 1.3)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│               KEMENTERIAN KESEHATAN RI (SATUSEHAT PLATFORM)            │
│               Sandbox & Production Environment (FHIR R4)               │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Cakupan Total 47 Resource Playbook & 29 Entitas Inti Kanonikal

Implementasi data pada SATUSEHAT Bridge mencakup total **47 Resource / Profil Alur Kerja Klinis Kemenkes DTO & BPJS E-Klaim**, yang dibagi menjadi dua tingkat kesiapan teknis berdasarkan bukti pengujian nyata:

### A. 29 Resource Kanonikal (End-to-End Terverifikasi Penuh)
Didukung oleh skema basis data internal terdedikasi, endpoint REST API, serializer standar FHIR R4 Kemenkes, dan antrean pengiriman teruji offline:

| No | Profil Resource | Standar FHIR R4 | REST API Endpoint | Dukungan Table Adapter | Status Verifikasi |
|:---:|:---|:---|:---|:---:|:---:|
| 1 | **Pasien** | `Patient` | `POST /api/v1/pasien` | ✅ Didukung | E2E Verified |
| 2 | **Praktisi / Dokter** | `Practitioner` | Reference Master | ✅ Didukung | E2E Verified |
| 3 | **Lokasi Ruangan / Fasyankes** | `Location` | Reference Master | ✅ Didukung | E2E Verified |
| 4 | **Kunjungan / Rawat Jalan / Inap** | `Encounter` | `POST /api/v1/kunjungan` | ✅ Didukung | E2E Verified |
| 5 | **Diagnosis Primer & Sekunder** | `Condition` | `POST /api/v1/diagnosis` | ✅ Didukung | E2E Verified |
| 6 | **Tanda-Tanda Vital & Fisik** | `Observation` | `POST /api/v1/tanda-vital` | ✅ Didukung | E2E Verified |
| 7 | **Tindakan Medis & Operasi** | `Procedure` | `POST /api/v1/tindakan` | ✅ Didukung | E2E Verified |
| 8 | **Katalog & Master Obat** | `Medication` | `POST /api/v1/obat` | ✅ Didukung | E2E Verified |
| 9 | **Resep Dokter (Prescription)** | `MedicationRequest` | `POST /api/v1/resep` | ✅ Didukung | E2E Verified |
| 10 | **Dispensing Obat Farmasi** | `MedicationDispense` | `POST /api/v1/dispense` | ✅ Didukung | E2E Verified |
| 11 | **Pemberian Obat (Rawat Inap)** | `MedicationAdministration` | `POST /api/v1/pemberian-obat` | ✅ Didukung | E2E Verified |
| 12 | **Order Penunjang Medis** | `ServiceRequest` | `POST /api/v1/order-penunjang` | ✅ Didukung | E2E Verified |
| 13 | **Pengambilan Spesimen Lab** | `Specimen` | `POST /api/v1/spesimen` | ✅ Didukung | E2E Verified |
| 14 | **Laporan Hasil Lab / Patologi** | `DiagnosticReport` | `POST /api/v1/hasil-penunjang` | ✅ Didukung | E2E Verified |
| 15 | **Studi Radiologi / Imaging** | `ImagingStudy` | `POST /api/v1/studi-radiologi` | ✅ Didukung | E2E Verified |
| 16 | **Riwayat Alergi Pasien** | `AllergyIntolerance` | `POST /api/v1/alergi` | ✅ Didukung | E2E Verified |
| 17 | **Rencana Asuhan Medis** | `CarePlan` | `POST /api/v1/rencana-asuhan` | ✅ Didukung | E2E Verified |
| 18 | **Layanan Fasyankes / Poliklinik** | `HealthcareService` | `POST /api/v1/layanan-fasyankes` | ✅ Didukung | E2E Verified |
| 19 | **Peran Praktisi & Spesialisasi** | `PractitionerRole` | `POST /api/v1/peran-praktisi` | ✅ Didukung | E2E Verified |
| 20 | **Slot Jadwal Janji Temu** | `Slot` | `POST /api/v1/slot-jadwal` | ✅ Didukung | E2E Verified |
| 21 | **Janji Temu Pasien** | `Appointment` | `POST /api/v1/janji-temu` | ✅ Didukung | E2E Verified |
| 22 | **Respon Status Janji Temu** | `AppointmentResponse` | `POST /api/v1/respon-janji-temu` | ✅ Didukung | E2E Verified |
| 23 | **Pemberian Imunisasi / Vaksin** | `Immunization` | `POST /api/v1/imunisasi` | ✅ Didukung | E2E Verified |
| 24 | **Episode Perawatan Kronis / TB** | `EpisodeOfCare` | `POST /api/v1/episode-perawatan` | ✅ Didukung | E2E Verified |
| 25 | **Riwayat Penyakit Keluarga** | `FamilyMemberHistory` | `POST /api/v1/riwayat-penyakit-keluarga` | ✅ Didukung | E2E Verified |
| 26 | **Respon Kuesioner Skrining** | `QuestionnaireResponse` | `POST /api/v1/respon-kuesioner` | ✅ Didukung | E2E Verified |
| 27 | **Asesmen & Resume Klinis** | `ClinicalImpression` | `POST /api/v1/asesmen-klinis` | ✅ Didukung | E2E Verified |
| 28 | **Keluarga / Penanggung Jawab** | `RelatedPerson` | `POST /api/v1/penanggung-jawab` | ✅ Didukung | E2E Verified |
| 29 | **Resume Medis Pelepasan Pasien** | `Composition` | `POST /api/v1/resume-medis` | ✅ Didukung | E2E Verified |

### B. 18 Profil Spesialisasi Playbook Kemenkes DTO & BPJS E-Klaim (Lolos Uji Struktur & Ingestion)
Spesialisasi alur kerja klinis berikut telah teruji validasi struktur JSON dan alur *staging envelope ingestion*:
- **Triase Kegawatdaruratan IGD:** Skor ATS/ESI (`Observation`), tindakan resusitasi (`Procedure`), dan formulir triase terstruktur (`Composition`).
- **Bedah & Operasi (OK):** Laporan pembedahan, resume anestesi pra/pasca-operasi, dan laporan tindakan invasif (`Composition`).
- **Kebidanan & Persalinan (VK):** Lembar partograf, catatan persalinan, dan pemantauan bayi baru lahir (`Composition`).
- **Penunjang Diagnostik Lengkap:** Order spesimen, hasil patologi klinik LOINC (`DiagnosticReport`), dan metadata citra DICOM (`ImagingStudy`).
- **Rujukan & Finansial:** Surat Perintah Rawat Inap (SPRI), tarif tindakan (`ChargeItem`), tagihan (`Invoice`), penjaminan (`Coverage`), dan berkas e-Klaim INA-CBG.
- **Integritas Legal Tanda Tangan Elektronik (TTE):** Penandatanganan digital rekam medis via FHIR `Provenance` & `Task` terintegrasi SATUSEHAT Mobile (SSM) & BSrE.

> *Catatan Pengujian Live:* Transmisi langsung ke endpoint server Kemenkes DTO secara operasional memerlukan kredensial institusi fasyankes Anda sendiri (`organization_id`, `client_id`, `client_secret`).

---

## 💻 Persyaratan Sistem

SATUSEHAT Bridge berjalan di lingkungan container Docker standar atau bare-metal Linux/Windows:

- **Sistem Operasi:** Linux (Ubuntu 22.04 LTS / Debian 12 direkomendasikan), Windows Server 2019+, atau macOS.
- **Runtime:** Docker Engine 24+ & Docker Compose v2, atau PHP 8.2+ CLI.
- **Basis Data Internal:** PostgreSQL versi 15+ (dikelola mandiri di dalam container Bridge).
- **Antrean & Cache:** Redis versi 7+ (persistence AOF/RDB aktif).
- **Hardware Minimum:** 2 vCPU, 4 GB RAM, 20 GB SSD storage.

---

## 📜 Lisensi & Model Komersial

1. **Format Distribusi:** Full Source Code mandiri (*self-hosted*).
2. **Cakupan Lisensi:** Lisensi Penggunaan Permanen (*Perpetual Usage Right*) untuk **1 (satu) Fasilitas Kesehatan**.
3. **Harga Dasar Acuan:** **Promo Peluncuran US$ 299 (Harga Normal US$ 500)** — atau setara mata uang lokal (IDR) berdasarkan kurs konversi live valas saat penagihan/pembayaran.
4. **Multi-Environment Diperbolehkan:** Lisensi mengizinkan penggunaan pada beberapa server/environment (Development, Staging, Production, Disaster Recovery, Backup) sepanjang berada dalam naungan fasilitas kesehatan yang sama.
5. **Tanpa Biaya Berulang Wajib:** Tidak ada biaya bulanan atau tahunan wajib hanya untuk terus menjalankan versi yang telah dibeli secara sah.
6. **Kebijakan Upgrade:** Hak penggunaan permanen melekat pada versi produk yang dibeli. Upgrade ke rilis versi minor atau mayor baru yang dirilis di masa depan diatur melalui transaksi upgrade terpisah.
7. **Larangan Redistribusi:** Pembeli dilarang menjual kembali, membagikan source code ke pihak ketiga, atau menggunakannya untuk multi-fasilitas tanpa lisensi tambahan.

---

## 🛒 Cara Pembelian & Pengiriman

1. Ajukan formulir pemesanan dengan mencantumkan nama fasilitas kesehatan dan alamat email teknis fasyankes.
2. Dapatkan lembar tagihan (*Invoice*) resmi dengan Order ID unik dan rincian pembayaran.
3. Lakukan pembayaran melalui QRIS Statis DANA Bisnis resmi (dapat di-scan menggunakan seluruh m-Banking dan e-Wallet berlogo QRIS).
4. Verifikasi transaksi dilakukan secara otomatis/manual melalui mutasi settlement merchant (kode RRN / Reference ID).
5. Paket rilis full source code terverifikasi (beserta berkas checksum SHA-256 dan sertifikat lisensi atas nama fasilitas) dikirimkan melalui jalur privat terenkripsi.

---

## 📞 Kontak & Informasi Pembelian

Untuk pemesanan lisensi fasyankes atau kemitraan vendor SIMRS:
- **Email:** `satusehatbridge@gmail.com`
- **Dokumentasi Publik:** [docs/architecture/system-overview.md](docs/architecture/system-overview.md)
- **Spesifikasi Resource:** [docs/integration/supported-resources.md](docs/integration/supported-resources.md)

---

## ⚠️ Batasan & Pernyataan Kepatuhan

- **Kepatuhan Teknis vs Klinis:** SATUSEHAT Bridge menyediakan serializer, validasi skema FHIR R4, dan pipeline pengiriman yang teruji. Kelengkapan data klinis, keabsahan nomor IHS/NIK pasien, serta verifikasi kredensial OAuth fasyankes di platform SATUSEHAT tetap menjadi tanggung jawab operasional masing-masing fasyankes.
- **Kemandirian dari Kemenkes RI:** SATUSEHAT Bridge adalah produk perangkat lunak independen dan tidak berafiliasi secara resmi dengan Kementerian Kesehatan RI selain menggunakan spesifikasi standar terbuka FHIR R4 dan API publik SATUSEHAT Kemenkes.

