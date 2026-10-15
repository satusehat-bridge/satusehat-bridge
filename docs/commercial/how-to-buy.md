# Prosedur Pemesanan & Pengiriman Paket — SATUSEHAT Bridge

Prosedur pemesanan dirancang transparan, aman, dan mematuhi verifikasi anti-fraud:

## 1. Alur Pemesanan

```
┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
│  1. Formulir Pesanan   │ ───► │   2. Tagihan (Invoice) │ ───► │  3. Pembayaran QRIS    │
│  (Data Fasyankes & PIC)│      │   (Order ID & Invoice) │      │  (DANA Bisnis / Bank)  │
└────────────────────────┘      └────────────────────────┘      └───────────┬────────────┘
                                                                            │
                                                                            ▼
┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
│  6. Pengiriman Paket   │ ◄─── │  5. Build & Lisensi    │ ◄─── │  4. Verifikasi Mutasi  │
│  (Privat & Checksum)   │      │  (Injeksi Hak Fasyankes│      │  (Cek Settlement RRN)  │
└────────────────────────┘      └────────────────────────┘      └────────────────────────┘
```

1. **Pengajuan Formulir Pemesanan:**
   Fasyankes mengajukan permohonan lisensi dengan menyertakan nama fasyankes, alamat, dan email kontak PIC teknis.
2. **Penerbitan Invoice:**
   Tim penjualan menerbitkan Invoice resmi lengkap dengan Nomor Registrasi / Order ID (contoh: `SB-ORD-20261015-0001`).
3. **Pembayaran melalui QRIS Nasional:**
   Kanal pembayaran standar yang disiapkan adalah QRIS Nasional (DANA Bisnis / Transfer Bank). Kode QRIS resmi diterbitkan langsung pada lembar Invoice setelah kanal merchant resmi dikonfirmasi aktif oleh Pemilik Produk. Pembeli memindai QRIS menggunakan aplikasi perbankan atau dompet digital.
4. **Verifikasi Mutasi (Anti-Fraud Policy):**
   *Screenshot transfer TIDAK dianggap sebagai bukti pembayaran final.* Pembayaran hanya dinyatakan sah setelah dana masuk dan diverifikasi pada mutasi settlement merchant dengan nomor referensi (RRN) yang cocok.
5. **Pembuatan Paket Rilis Terlisensi:**
   Sistem pengemasan otomatis membuat paket rilis `.tar.gz` yang telah disanitasi dari dependensi pengembangan dan menginjeksi sertifikat lisensi atas nama fasyankes.
6. **Pengiriman & Verifikasi Checksum:**
   Paket rilis beserta berkas checksum SHA-256 dikirimkan melalui tautan aman privat ke email PIC fasyankes. Pembeli dapat memverifikasi integritas berkas menggunakan perintah `sha256sum -c`.

---

## 2. Batas Tanggung Jawab & Ketentuan Layanan

- **Tanggung Jawab Pembeli:** Pengadaan infrastruktur server, instalasi Docker/database, penyediaan kredensial resmi SATUSEHAT Kemenkes, serta pemeliharaan operasional runtime merupakan tanggung jawab penuh pihak pembeli (*self-hosted*).
- **Kebijakan Refund:** Mengingat produk diserahkan dalam bentuk *full source code* tanpa DRM dan hak penggunaan permanen, pembayaran yang telah terverifikasi dan paket yang telah dikirimkan bersifat final (*non-refundable*).
- **Dukungan Teknis:** Dokumentasi teknis, panduan instalasi, dan DDL staging disediakan lengkap dalam paket. Dukungan kustomisasi di luar cakupan standar atau asistensi implementasi langsung diatur melalui kesepakatan terpisah.
