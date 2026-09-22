-- APLUS PSLE SmartMatch
-- Historical COP + Affiliation unified data layer
-- Deployed to Supabase project mktszwqyklmrxzynzmtv on 2026-09-22.
-- 2024 affiliation rows are explicitly marked INFERRED_CONTINUITY until archival
-- primary-secondary affiliation evidence is verified. They remain queryable by year.

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
-- 2024 COP: 415 rows / 125 schools
-- 2025 COP: 410 rows / 122 schools
-- 2024 affiliation mappings: 31 (INFERRED_CONTINUITY)
-- 2025 affiliation mappings: 31 (VERIFIED)
