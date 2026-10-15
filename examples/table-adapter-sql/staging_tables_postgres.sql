-- ==============================================================================
-- SATUSEHAT Bridge — Table Adapter Staging Schema (PostgreSQL)
-- Jalankan skrip ini pada basis data SIMRS Anda untuk mengaktifkan Table Adapter.
-- ==============================================================================

CREATE TABLE IF NOT EXISTS satusehat_bridge_staging_envelope (
    id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(64) NOT NULL,
    source_record_id VARCHAR(128) NOT NULL,
    payload_json JSONB NOT NULL,
    status VARCHAR(32) DEFAULT 'PENDING',
    error_message TEXT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP WITH TIME ZONE NULL
);

CREATE INDEX IF NOT EXISTS idx_sb_staging_status ON satusehat_bridge_staging_envelope (status, id);
CREATE INDEX IF NOT EXISTS idx_sb_staging_entity ON satusehat_bridge_staging_envelope (entity_type, source_record_id);

CREATE TABLE IF NOT EXISTS satusehat_bridge_cursor (
    sumber VARCHAR(64) PRIMARY KEY,
    nilai_cursor BIGINT NOT NULL DEFAULT 0,
    terakhir_sinkron TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
