-- APLUS PSLE SmartMatch
-- Historical COP + Affiliation unified data layer
-- Deployed to Supabase project mktszwqyklmrxzynzmtv on 2026-09-22.
-- 2024 affiliation rows are explicitly marked INFERRED_CONTINUITY until archival
-- primary-secondary affiliation evidence is verified. They remain queryable by year.
--
-- IMPORTANT PROGRAMME RULE:
-- IP is a programme-level matching path. IP COP rows must not be filtered out
-- by the student's ordinary PG1/PG2/PG3 eligibility calculation.
-- IP and MAINSTREAM remain separate programme_type values.

create table if not exists public.sm_affiliation_history (
  id uuid primary key default gen_random_uuid(),
  year smallint not null check (year between 2021 and 2100),
  primary_school_id uuid not null references public.sm_primary_schools(primary_school_id),
  secondary_school_id uuid not null references public.sm_schools(school_id),
  affiliation_type text not null default 'AFFILIATED',
  verification_status text not null default 'VERIFIED'
    check (verification_status in ('VERIFIED','INFERRED_CONTINUITY','PENDING','REJECTED')),
  source text,
  source_url text,
  verified_at timestamptz,
  notes text,
  created_at timestamptz not null default now(),
  unique(year, primary_school_id, secondary_school_id)
);

-- Unified callable layer:
-- sm_historical_smartmatch_data(year, school, posting group, COPs, affiliation mapping)
-- sm_get_student_affiliation_year(primary, secondary, year)
--
-- The live database contains:
-- 2024 COP: 421 rows / 127 schools after restoring missing IP programme rows
-- 2025 COP: 416 rows / 124 schools after restoring missing IP programme rows
-- 2024 affiliation mappings: 31 (INFERRED_CONTINUITY)
-- 2025 affiliation mappings: 31 (VERIFIED)
--
-- Restored historical IP COP rows:
-- Raffles Girls' School (Secondary): 2024 COP 6; 2025 COP 5
-- Nanyang Girls' High School: 2024 non-affiliated 7D / affiliated 8M;
-- 2025 non-affiliated 6M / affiliated 8M.
--
-- These are stored as programme_type='IP' with posting_group='PG3'.
-- The PG label is retained for compatibility with the existing COP schema;
-- the matching engine separately admits IP programmes regardless of ordinary
-- posting-group eligibility.

-- Reference sources used for the restored IP rows:
-- 2024:
-- https://www.cutoffpoint.sg/wp-content/uploads/2025/07/2024_Secondary_School_Cut-Off_Point.pdf
-- 2025:
-- https://www.sgexams.com/secondary/ipcop/y2025
