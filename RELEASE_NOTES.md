# Release Notes — SATUSEHAT Bridge v2.2.0

**Versi Rilis:** v2.2.0  
**Tanggal Rilis:** 2026-10-15  
**Status:** General Availability Release  

---

## 🌟 Sorotan Rilis v2.2.0

1. **Dual Ingestion Engine:**
   - Dukungan penuh REST API JSON dengan header `Idempotency-Key`.
   - Shared Table Adapter (Staging Envelope) untuk PostgreSQL, MySQL, dan Microsoft SQL Server.
2. **Cakupan Total 47 Profil Playbook Kemenkes DTO & BPJS E-Klaim:**
   - 29 Resource Inti Kanonikal FHIR R4 terverifikasi end-to-end pada pipeline simulasi lokal (Patient, Encounter, Condition, Medication, Procedure, Observation, DiagnosticReport, Composition, dll.).
   - 18 Profil Spesialisasi & Finansial Playbook terverifikasi struktur & staging ingestion (Triase IGD, Kamar Operasi OK, Bersalin VK, Anestesi, Lab LOINC, Radiologi DICOM, Alkes, Billing/Klaim, dan TTE Provenance/Task).
   - Pengujian transmisi langsung ke server SATUSEHAT Kemenkes live sandbox ditandai terpisah menunggu kredensial resmi institusi fasyankes.
3. **Pipeline Upgrade Aman Tanpa Kehilangan Data (ADR-035):**
   - Skrip `scripts/upgrade.sh` dengan worker drainage aman (Docker & non-Docker).
   - Verifikasi integritas 49 tabel internal migrasi.
   - Deteksi otomatis regresi cursor Table Adapter watermark.
   - Prosedur rollback manual teruji (`scripts/restore.sh`) dengan validasi checksum SHA-256 dan pelestarian berkas `.env` berizin `600`.
4. **Keamanan & Otorisasi Ketat:**
   - Enkripsi at rest AES-256-CBC untuk kredensial client secret Kemenkes.
   - Hashing SHA-256 untuk API Key ingestion.
   - Isolasi tenant mutlak per rumah sakit (`rumah_sakit_id`).
   - Zero phone-home, zero DRM, runtime independence 100%.
