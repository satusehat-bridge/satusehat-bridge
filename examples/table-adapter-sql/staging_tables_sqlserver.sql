-- ==============================================================================
-- SATUSEHAT Bridge — Table Adapter Staging Schema (Microsoft SQL Server)
-- Jalankan skrip ini pada basis data SIMRS Anda untuk mengaktifkan Table Adapter.
-- ==============================================================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[satusehat_bridge_staging_envelope]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[satusehat_bridge_staging_envelope] (
        [id] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [entity_type] VARCHAR(64) NOT NULL,
        [source_record_id] VARCHAR(128) NOT NULL,
        [payload_json] NVARCHAR(MAX) NOT NULL,
        [status] VARCHAR(32) DEFAULT 'PENDING',
        [error_message] NVARCHAR(MAX) NULL,
        [created_at] DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET(),
        [processed_at] DATETIMEOFFSET NULL
    );

    CREATE NONCLUSTERED INDEX [idx_sb_staging_status] ON [dbo].[satusehat_bridge_staging_envelope] ([status], [id]);
    CREATE NONCLUSTERED INDEX [idx_sb_staging_entity] ON [dbo].[satusehat_bridge_staging_envelope] ([entity_type], [source_record_id]);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[satusehat_bridge_cursor]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[satusehat_bridge_cursor] (
        [sumber] VARCHAR(64) NOT NULL PRIMARY KEY,
        [nilai_cursor] BIGINT NOT NULL DEFAULT 0,
        [terakhir_sinkron] DATETIMEOFFSET DEFAULT SYSDATETIMEOFFSET()
    );
END;
