# Gambaran Arsitektur Sistem — SATUSEHAT Bridge

SATUSEHAT Bridge dirancang dengan arsitektur tri-layer yang memisahkan ingestion SIMRS dari konektivitas SATUSEHAT Kemenkes:

```
┌─────────────────────────────────────────────────────────┐
│                 1. INGESTION LAYER                      │
│   • REST API Ingestion (/api/v1/*)                      │
│   • Shared Table Adapter Poller                         │
│   • Proteksi Idempotensi Transaksi                      │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                 2. CANONICAL DOMAIN LAYER               │
│   • Model Data Kanonikal Terstandarisasi                │
│   • Validasi Terminologi (ICD-10, SNOMED, LOINC, KFA)   │
│   • Prerequisite Clinical Dependency Guard              │
│   • Database Internal Relasional (PostgreSQL 15)        │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                 3. DELIVERY ENGINE                      │
│   • Antrean Redis Asinkron & Lease Recovery             │
│   • Serializer Standar FHIR R4 Kemenkes                 │
│   • HTTP Client dengan Otentikasi OAuth2 Terenkripsi    │
│   • Bounded Retry Exponential Backoff (Maks 5x)         │
└─────────────────────────────────────────────────────────┘
```

## Keunggulan Desain
1. **Decoupled Architecture:** SIMRS Anda tidak pernah terikat langsung ke API Kemenkes.
2. **Reliable Buffer:** Lonjakan pasien di rumah sakit ditampung secara aman oleh antrean Redis.
3. **Audit Trail Lengkap:** Seluruh riwayat pengiriman, respons Kemenkes, dan ID eksternal tercatat secara transparan.
