# Panduan Shared Table Adapter (Staging Envelope)

Shared Table Adapter adalah metode integrasi non-intrusif bagi SIMRS berbasis desktop atau database langsung (SQL Server, MySQL, PostgreSQL) yang tidak memiliki modul REST API.

## 1. Konsep Kerja
1. Administrator fasyankes membuat 1 tabel staging (`satusehat_bridge_staging_envelope`) dan 1 tabel cursor (`satusehat_bridge_cursor`) di database SIMRS.
2. SIMRS melakukan `INSERT` data rekam medis dalam format JSON ke tabel staging.
3. Worker Bridge secara berkala membaca data baru berdasarkan cursor, memvalidasi, memproses ke model kanonikal, dan memperbarui status staging.
4. **Keamanan:** Bridge hanya membaca/memperbarui tabel staging ini, tanpa pernah memodifikasi tabel operasional SIMRS Anda.

---

## 2. Struktur Kolom Staging Envelope

| Kolom | Tipe Data | Keterangan |
|:---|:---|:---|
| `id` | BIGINT AUTO_INCREMENT / IDENTITY | Primary Key unik staging |
| `entity_type` | VARCHAR(64) | Jenis data (`kunjungan`, `diagnosis`, `tindakan`, dll.) |
| `source_record_id` | VARCHAR(128) | ID unik rekam medis di SIMRS |
| `payload_json` | TEXT / JSON | Data klinis lengkap dalam format JSON |
| `status` | VARCHAR(32) | Status pemrosesan (`PENDING`, `PROCESSED`, `FAILED`) |
| `error_message` | TEXT | Pesan error jika format tidak sesuai |
| `created_at` | TIMESTAMP | Waktu pencatatan rekam medis |
| `processed_at` | TIMESTAMP | Waktu penarikan oleh Bridge |
