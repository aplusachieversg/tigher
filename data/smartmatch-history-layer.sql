-- APLUS PSLE SmartMatch
-- Historical COP + Affiliation unified data layer
-- Updated 2026-09-22: complete 17-school IP master audit.
--
-- PROGRAMME RULE:
-- IP is a programme-level matching path. IP COP rows must not be filtered out
-- by ordinary PG1/PG2/PG3 eligibility. MAINSTREAM remains a separate path.
--
-- Complete Singapore IP master:
-- 1 ACS (Independent)
-- 2 Catholic High
-- 3 Cedar Girls' Secondary
-- 4 CHIJ St. Nicholas Girls'
-- 5 Dunman High
-- 6 Hwa Chong Institution
-- 7 Methodist Girls' School (Secondary)
-- 8 Nanyang Girls' High
-- 9 National Junior College
-- 10 NUS High School of Mathematics and Science
-- 11 Raffles Girls' School (Secondary)
-- 12 Raffles Institution
-- 13 River Valley High
-- 14 Singapore Chinese Girls' School
-- 15 St. Joseph's Institution
-- 16 Temasek Junior College
-- 17 Victoria School
--
-- Historical IP COP rows use programme_type='IP' and PG3 only for schema
-- compatibility; engine eligibility for IP is programme-independent.
-- HCL D/M is retained where the published COP is HCL-qualified.
--
-- NUS High is connected as an IP school but deliberately has no ordinary
-- PSLE COP row here; its admission route is not represented by a conventional
-- PSLE posting COP. Do not invent a COP.
--
-- Existing historical affiliation table remains:
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

-- Reference sources:
-- MOE Education Statistics Digest 2024:
-- https://www.moe.gov.sg/-/media/files/about-us/education-statistics-digest-2024.pdf
-- 2024 COP:
-- https://www.cutoffpoint.sg/secondary-school-cut-off-point-2024/
-- 2025 IP COP:
-- https://www.sgexams.com/secondary/ipcop/y2025
-- 2024 cross-check:
-- https://www.sgschooling.com/secondary/cop/2024/
-- 2025 cross-check:
-- https://www.sgschooling.com/secondary/cop/2025/ip
