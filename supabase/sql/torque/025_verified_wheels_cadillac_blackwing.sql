-- Offset Lab Torque Hub
-- Pack 025: verified Cadillac CT4-V / CT5-V Blackwing wheel lug torque.
--
-- Plain SQL only. Safe to re-run.
-- Official Cadillac owner manuals confirm the Blackwing wheel nut torque:
-- - 2022 CT4 Owner's Manual: V-Series Blackwing M14 wheel nut torque is
--   190 N-m / 140 lb-ft.
-- - 2022 CT5 Owner's Manual: wheel nut torque is 190 N-m / 140 lb-ft.
--
-- This pack verifies the combined CT4-V / CT5-V Blackwing generation and
-- removes the older GM Alpha donor row that incorrectly carried 103 ft-lb /
-- 140 N-m into the Blackwing card.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'cadillac',
      'ct4-v-ct5-v-blackwing',
      'alpha2-ct4-v-ct5-v-blackwing',
      'Wheel lug nuts',
      140,
      190,
      'Cadillac 2022 CT4 and CT5 Owner''s Manuals',
      'https://www.gmc.com/ownercenter/content/dam/gmownercenter/gmna/dynamic/manuals/2022/cadillac/ct5/2022-cadillac-ct5-owners-manual.pdf',
      'Verified from official Cadillac owner manuals: 2022 CT5 manual lists wheel nut torque as 190 N-m / 140 lb-ft; 2022 CT4 manual lists V-Series Blackwing M14 wheel nut torque as 190 N-m / 140 lb-ft. CT4 manual URL: https://www.gmc.com/ownercenter/content/dam/gmownercenter/gmna/dynamic/manuals/2022/cadillac/ct4/2022-cadillac-ct4-owners-manual.pdf'
    )
),
target as (
  select
    generation_row.id as generation_id,
    category_row.id as category_id,
    seed.fastener,
    seed.torque_ft_lb,
    seed.torque_nm,
    seed.source_name,
    seed.source_url,
    seed.source_note
  from seed
  join public.torque_vehicle_makes make_row
    on make_row.slug = seed.make_slug
  join public.torque_vehicle_models model_row
    on model_row.make_id = make_row.id
   and model_row.slug = seed.model_slug
  join public.torque_vehicle_generations generation_row
    on generation_row.model_id = model_row.id
   and generation_row.slug = seed.generation_slug
  join public.torque_categories category_row
    on category_row.slug = 'wheels'
),
updated_primary as (
  update public.torque_specs spec
  set
    component = 'Wheels',
    fastener = target.fastener,
    torque_ft_lb = target.torque_ft_lb::numeric,
    torque_nm = target.torque_nm::numeric,
    angle_degrees = null,
    notes = 'Cadillac owner manuals specify 190 N-m / 140 lb-ft for Blackwing wheel nuts. Tighten evenly in a criss-cross/star pattern with a calibrated torque wrench.',
    warning = 'Use the correct wheel nuts for the vehicle. Never use oil or grease on wheel bolts, wheel nuts, or wheel mounting surfaces unless the service manual explicitly instructs it.',
    source_status = 'verified',
    source_name = target.source_name,
    source_url = target.source_url,
    source_note = target.source_note,
    source_checked_at = now()
  from target
  where spec.generation_id = target.generation_id
    and spec.category_id = target.category_id
    and lower(spec.component) = lower('Wheels')
    and lower(spec.fastener) = lower(target.fastener)
  returning spec.id
),
conflicting_donor_rows as (
  select spec.id
  from public.torque_specs spec
  join target
    on target.generation_id = spec.generation_id
   and target.category_id = spec.category_id
  where exists (select 1 from updated_primary)
    and spec.id not in (select id from updated_primary)
    and spec.source_status in ('community', 'needs_review')
    and (
      lower(spec.component) like '%cadillac alpha2%'
      or (
        lower(spec.fastener) = lower('Wheel lug nuts')
        and spec.torque_ft_lb = 103
        and spec.torque_nm = 140
      )
    )
)
delete from public.torque_specs spec
using conflicting_donor_rows donor
where spec.id = donor.id;
