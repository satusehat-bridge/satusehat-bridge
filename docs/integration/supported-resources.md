# Spesifikasi Lengkap Resource Terverifikasi

SATUSEHAT Bridge menyediakan cakupan komprehensif dua lapis: **29 Entitas Kanonikal Inti** dan **47 Profil Alur Kerja Klinis Kemenkes Playbook & BPJS E-Klaim**.

---

## 1. 29 Entitas Resource Kanonikal (Core Engine)

| No | Kode | Standar FHIR R4 | Cakupan Use-Case |
|:---:|:---|:---|:---|
| 1 | `pasien` | `Patient` | Identifikasi NIK Dukcapil & Nomor IHS Pasien |
| 2 | `dokter` | `Practitioner` | Pemetaan STR Tenaga Medis SISDMK |
| 3 | `lokasi` | `Location` | Poliklinik, Bangsal, Laboratorium, Kamar Operasi |
| 4 | `kunjungan` | `Encounter` | Registrasi Rawat Jalan, Inap, & IGD |
| 5 | `diagnosis` | `Condition` | Kodifikasi Diagnosis ICD-10 Primer & Sekunder |
| 6 | `tanda_vital` | `Observation` | Tekanan Darah, Nadi, Pernapasan, Suhu Tubuh (LOINC/UCUM) |
| 7 | `tindakan` | `Procedure` | Intervensi & Tindakan Operatif ICD-9-CM |
| 8 | `obat` | `Medication` | Master & Formulasi Obat Standar KFA Kemenkes |
| 9 | `resep` | `MedicationRequest` | Peresepan Elektronik oleh Dokter DPJP |
| 10 | `dispense` | `MedicationDispense` | Penyerahan Obat Farmasi ke Pasien |
| 11 | `pemberian_obat` | `MedicationAdministration` | Pencatatan Konsumsi Obat di Ruang Rawat |
| 12 | `order_penunjang` | `ServiceRequest` | Permintaan Uji Lab & Pemeriksaan Radiologi |
| 13 | `spesimen` | `Specimen` | Manajemen Sampel Biologis |
| 14 | `hasil_penunjang` | `DiagnosticReport` | Laporan Hasil Patologi Klinik & Ekspertise |
| 15 | `studi_radiologi` | `ImagingStudy` | Metadata DICOM, Series, & Modalitas Gambar |
| 16 | `alergi` | `AllergyIntolerance` | Alergi Obat, Makanan, & Zat Lingkungan |
| 17 | `rencana_asuhan` | `CarePlan` | Rencana Tindak Lanjut Medis & Keperawatan |
| 18 | `layanan_fasyankes` | `HealthcareService` | Poliklinik Spesialis & Unit Layanan |
| 19 | `peran_praktisi` | `PractitionerRole` | Hak Klinis & Penugasan Dokter |
| 20 | `slot_jadwal` | `Slot` | Ketersediaan Jadwal Praktek |
| 21 | `janji_temu` | `Appointment` | Reservasi / Antrean Online |
| 22 | `respon_janji_temu` | `AppointmentResponse` | Konfirmasi Kehadiran Pasien |
| 23 | `imunisasi` | `Immunization` | Catatan Vaksinasi Program & Pilihan |
| 24 | `episode_perawatan` | `EpisodeOfCare` | Perawatan Berkelanjutan (TB, HIV, PTM) |
| 25 | `riwayat_penyakit_keluarga` | `FamilyMemberHistory` | Riwayat Genetik & Keturunan Pasien |
| 26 | `respon_kuesioner` | `QuestionnaireResponse` | Formulir Skrining Kesehatan Terstandar |
| 27 | `asesmen_klinis` | `ClinicalImpression` | Pertimbangan & Prognosis Klinis |
| 28 | `penanggung_jawab_pasien` | `RelatedPerson` | Wali, Orang Tua, atau Penjamin Pasien |
| 29 | `resume_medis_dokumen` | `Composition` | Ringkasan Pulang (*Discharge Summary*) |

---

## 2. 47 Profil Alur Kerja Klinis Kemenkes Playbook & BPJS E-Klaim

Selain 29 resource dasar di atas, Bridge mengintegrasikan 47 profil spesialisasi:
1. **Kegawatdaruratan:** Triase Skor ATS/ESI, Tindakan Resusitasi, dan Lembar Asesmen IGD.
2. **Kamar Bedah & OK:** Laporan Operasi, Resume Anestesi, dan Laporan Tindakan Invasif.
3. **Kamar Bersalin & VK:** Laporan Persalinan Normal/SC dan Catatan Bayi Baru Lahir.
4. **Alat Kesehatan (Device):** Device, DeviceRequest, DeviceDispense, DeviceUseStatement.
5. **Rantai Pasok Medis:** SupplyRequest dan SupplyDelivery untuk BMHP.
6. **Finansial & E-Klaim:** ChargeItem, Invoice, Account, Coverage, Respon Eligibilitas, dan E-Klaim JKN.
7. **Tanda Tangan Elektronik (TTE):** Integritas legal dokumen via FHIR `Provenance` & `Task`.

---

## 3. Matriks Status Verifikasi Teknis

Untuk menjamin kepatuhan dan keterbukaan teknis:

- **29 Profil Kanonikal:** **VERIFIED E2E (OFFLINE & PIPELINE)**  
  Telah diverifikasi penuh end-to-end melalui automated test suite (248 tests), validasi skema 49 tabel migrasi, enkripsi credentials, serta safe upgrade pipeline.
- **18 Profil Spesialisasi Playbook:** **STRUCTURE & INGESTION VERIFIED**  
  Telah diverifikasi validasi struktur skema, ingestion REST API, dan Generic Staging Envelope (`Playbook47ResourcesFullParityTest`).
- **Konektivitas Live Sandbox Fasyankes:** **PENDING LIVE CREDENTIALS**  
  Telah diuji dengan simulasi HTTP Mock Sandbox. Transmisi langsung ke server Kemenkes DTO secara operasional memerlukan kredensial institusi mandiri (`organization_id`, `client_id`, `client_secret`) yang didaftarkan langsung oleh pihak rumah sakit/klinik pembeli.
