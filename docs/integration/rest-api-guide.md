# Panduan Integrasi REST API — SATUSEHAT Bridge

REST API Ingestion Adapter memungkinkan SIMRS berbasis web, microservices, atau aplikasi modern mengirimkan data secara langsung ke Bridge menggunakan HTTP POST JSON.

## 1. Otentikasi & Header Standar

Setiap permintaan ke REST API wajib menyertakan header:

```http
POST /api/v1/kunjungan HTTP/1.1
Host: satusehat-bridge.internal:8080
Authorization: Bearer <API_KEY_SIMRS>
Content-Type: application/json
Accept: application/json
Idempotency-Key: REG-20261015-00123
```

- **`Authorization`:** Kunci API yang diterbitkan melalui Dashboard Bridge.
- **`Idempotency-Key`:** Kunci unik dari SIMRS untuk mencegah duplikasi data jika terjadi retry jaringan.

---

## 2. Contoh Payload Ingestion: Kunjungan (Encounter)

**Endpoint:** `POST /api/v1/kunjungan`

```json
{
  "id_asal": "REG-20261015-001",
  "nomor_kunjungan": "REG-20261015-001",
  "pasien_id_asal": "PS-10001",
  "dokter_id_asal": "DR-20001",
  "lokasi_id_asal": "LOK-POLI-INT",
  "jenis_kunjungan": "RAWAT_JALAN",
  "tanggal_masuk": "2026-10-15T08:30:00+07:00",
  "status": "aktif"
}
```

**Respon Sukses (HTTP 201 Created):**

```json
{
  "success": true,
  "message": "Data kunjungan berhasil diterima dan masuk ke antrean pengiriman.",
  "data": {
    "id": "e9a1b2c3-4d5e-6f7a-8b9c-0d1e2f3a4b5c",
    "status": "MENUNGGU",
    "nomor_kunjungan": "REG-20261015-001"
  }
}
```

---

## 3. Respon Idempotensi & Konflik

- **Replay Identik:** Jika permintaan dikirim ulang dengan `Idempotency-Key` dan payload yang sama, Bridge mengembalikan respons yang sama (HTTP 200 OK) tanpa membuat duplikasi transaksi.
- **Konflik:** Jika `Idempotency-Key` sama dikirim dengan payload berbeda, Bridge menolak permintaan dengan **HTTP 409 Conflict**.
