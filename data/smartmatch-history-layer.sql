-- APLUS PSLE SmartMatch
-- Historical COP + Affiliation unified data layer
-- Updated 2026-09-22.
--
-- PROGRAMME RULE:
-- IP is a programme-level matching path. IP COP rows must not be filtered out
-- by ordinary PG1/PG2/PG3 eligibility. MAINSTREAM remains a separate path.
--
-- Complete Singapore IP master (17):
-- ACS (Independent); Catholic High; Cedar Girls'; CHIJ St. Nicholas Girls';
-- Dunman High; Hwa Chong Institution; Methodist Girls' School (Secondary);
-- Nanyang Girls' High; National Junior College; NUS High School of Mathematics
-- and Science; Raffles Girls'; Raffles Institution; River Valley High;
-- Singapore Chinese Girls'; St. Joseph's Institution; Temasek Junior College;
-- Victoria School.
--
-- NUS High is connected as an IP school but deliberately has no conventional
-- PSLE COP row. Do not invent a COP for it.
--
-- Historical IP COP rows use programme_type='IP' and posting_group=NULL.
-- IP is not a PG1/PG2/PG3 posting-group path. Engine eligibility for IP is
-- programme-independent; MAINSTREAM rows retain PG1/PG2/PG3.
--
-- Historical affiliation table:
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

-- Data-completeness audit views are deployed in Supabase:
-- public.sm_smartmatch_data_completeness_audit
-- public.sm_smartmatch_programme_audit
--
-- The audit distinguishes:
-- OK
-- MISSING_IP_COP
-- MISSING_AFFILIATION_DIMENSION
-- NO_COP_DATA
--
-- NO_COP_DATA is not automatically treated as an error: specialised schools
-- and schools without a conventional S1 posting COP must remain explicitly
-- non-COP rather than receiving fabricated values.
--
-- Verified 2025 mainstream COP gaps restored:
-- Chung Cheng High School (Main): PG3 COP 10M
-- Hougang Secondary School: PG3 20, PG2 24, PG1 27
-- Nan Chiau High School: PG3 11M
-- Nan Hua High School: PG3 10M
-- Source cross-check:
-- https://sgschoolkaki.com/rankings/secondary-schools-2025
--
-- Outram Secondary School has 2025 COP data but no 2024 COP because its
-- S1 intake timing does not provide a comparable 2024 COP record.
--
-- Crest, Spectra, Assumption Pathway and NorthLight are specialised pathways
-- and are not assigned ordinary mainstream COPs merely to fill the database.
--
-- Reference sources:
-- MOE Education Statistics Digest 2024:
-- https://www.moe.gov.sg/-/media/files/about-us/education-statistics-digest-2024.pdf
-- MOE PSLE score-range explanation:
-- https://www.moe.gov.sg/-/media/files/secondary/understanding-psle-score-range.ashx
-- 2025 COP cross-check:
-- https://sgschoolkaki.com/rankings/secondary-schools-2025
-- 2025 IP COP:
-- https://www.sgexams.com/secondary/ipcop/y2025
