-- ============================================
-- PostgreSQL Initialization Script
-- For n8n and LibreChat with Supabase
-- ============================================
-- Place this file in: ./init-scripts/01-init-apps.sql

-- Create schemas for applications
CREATE SCHEMA IF NOT EXISTS n8n;
CREATE SCHEMA IF NOT EXISTS librechat;

-- ============================================
-- n8n User and Permissions
-- ============================================

-- Create n8n user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'n8n_user') THEN
        CREATE USER n8n_user WITH PASSWORD :'N8N_DB_PASSWORD';
    END IF;
END
$$;

-- Grant permissions to n8n user
GRANT CREATE, USAGE ON SCHEMA n8n TO n8n_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA n8n TO n8n_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA n8n TO n8n_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA n8n GRANT ALL ON TABLES TO n8n_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA n8n GRANT ALL ON SEQUENCES TO n8n_user;

-- ============================================
-- LibreChat User and Permissions
-- ============================================

-- Create librechat user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'librechat_user') THEN
        CREATE USER librechat_user WITH PASSWORD :'LIBRECHAT_DB_PASSWORD';
    END IF;
END
$$;

-- Grant permissions to librechat user
GRANT CREATE, USAGE ON SCHEMA librechat TO librechat_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA librechat TO librechat_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA librechat TO librechat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA librechat GRANT ALL ON TABLES TO librechat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA librechat GRANT ALL ON SEQUENCES TO librechat_user;

-- ============================================
-- Enable Required Extensions
-- ============================================

-- Enable pgvector for vector similarity search (optional - for future use)
CREATE EXTENSION IF NOT EXISTS vector;

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable pgcrypto for encryption functions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================
-- Create Storage Bucket for LibreChat
-- ============================================

-- This will be managed by Supabase Storage API
-- But we prepare the bucket configuration
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'librechat-files',
    'librechat-files',
    false,
    52428800, -- 50MB
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf', 'text/plain', 'text/markdown', 'application/json', 'text/csv']::text[]
)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Row Level Security Policies (Optional)
-- ============================================

-- Enable RLS on the storage objects table for the librechat bucket
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Create a policy for authenticated users to manage their own files
CREATE POLICY "Users can upload their own files" ON storage.objects
    FOR INSERT TO authenticated
    WITH CHECK (bucket_id = 'librechat-files');

CREATE POLICY "Users can view their own files" ON storage.objects
    FOR SELECT TO authenticated
    USING (bucket_id = 'librechat-files');

CREATE POLICY "Users can delete their own files" ON storage.objects
    FOR DELETE TO authenticated
    USING (bucket_id = 'librechat-files');

-- ============================================
-- Create Helper Functions (Optional)
-- ============================================

-- Function to generate API keys (useful for testing)
CREATE OR REPLACE FUNCTION generate_api_key(length INTEGER DEFAULT 32)
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    result TEXT := '';
    i INTEGER;
BEGIN
    FOR i IN 1..length LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::INTEGER, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Indexes for Performance
-- ============================================

-- These will be created by n8n and LibreChat automatically
-- but you can add custom indexes here if needed

COMMENT ON SCHEMA n8n IS 'Schema for n8n workflow automation data';
COMMENT ON SCHEMA librechat IS 'Schema for LibreChat conversation and user data';
