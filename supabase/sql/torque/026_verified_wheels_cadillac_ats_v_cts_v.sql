-- Offset Lab Torque Hub
-- Pack 026: verified Cadillac ATS-V / CTS-V wheel lug torque.
--
-- Plain SQL only. Safe to re-run.
-- 2016 Cadillac owner manuals confirm these are not Blackwing 140 lb-ft cars:
-- - 2016 ATS/ATS-V Owner Manual lists ATS-V (Blue Tint Nut) wheel nut torque
--   as 150 N-m / 110 lb-ft.
-- - 2016 CTS/CTS-V Owner Manual lists wheel nut torque as 150 N-m / 110 lb-ft.
--
-- This pack verifies the primary Cadillac ATS-V and CTS-V wheel rows and
-- removes older Chevrolet Alpha Camaro donor rows that incorrectly carried
-- 103 ft-lb / 140 N-m into these Cadillac cards.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'cadillac',
      'ats-v',
      'alpha-ats-v',
      'Wheel lug nuts',
      110,
      150,
      'Cadillac 2016 ATS/ATS-V Owner Manual',
      'https://cdn.dealereprocess.org/cdn/servicemanuals/cadillac/2016-ats.pdf',
      'Verified from 2016 Cadillac ATS/ATS-V owner manual: Capacities and Specifications lists Wheel Nut Torque - ATS-V (Blue Tint Nut) as 150 N-m / 110 lb-ft.'
    ),
    (
      'cadillac',
      'cts-v',
      'v3-cts-v',
      'Wheel lug nuts',
      110,
      150,
      'Cadillac 2016 CTS/CTS-V Owner Manual',
      'https://cdn.dealereprocess.org/cdn/servicemanuals/cadillac/2016-cts.pdf',
      'Verified from 2016 Cadillac CTS/CTS-V owner manual: Capacities and Specifications lists wheel nut torque as 150 N-m / 110 lb-ft.'
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
    notes = 'Cadillac owner manual specifies 150 N-m / 110 lb-ft for wheel nuts. Tighten evenly in a criss-cross/star pattern with a calibrated torque wrench.',
    warning = 'Use the correct GM wheel nuts for the vehicle. Never use oil or grease on wheel studs, wheel nuts, or wheel mounting surfaces unless the service manual explicitly instructs it.',
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
      lower(spec.component) like '%chevrolet alpha camaro%'
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
