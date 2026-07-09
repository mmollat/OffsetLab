-- Offset Lab Torque Hub
-- Pack 024: verified Toyota 6th Gen 4Runner wheel lug torque.
--
-- Plain SQL only. Safe to re-run.
-- Toyota's official 2025 4Runner Owner's Manual (OM35B85U) lists wheel nut
-- torque as 97 ft-lbf / 131 N-m for aluminum wheels in the tire/wheel
-- specifications, and also calls out 97 ft-lbf / 131 N-m when installing an
-- aluminum wheel after a flat tire. The manual separately lists the steel spare
-- wheel torque as 154 ft-lbf / 209 N-m, so Torque Hub keeps the normal
-- aluminum wheel service card as the primary wheel lug row.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'toyota',
      '4runner',
      '6th-gen-4runner',
      'Wheel lug nuts',
      97,
      131,
      'Toyota 2025 4Runner Owner''s Manual USA and Canada Only (OM35B85U)',
      'https://assets.sipb.toyota.com/publications/en/om-s/OM35B85U/pdf/OM35B85U.pdf',
      'Verified from Toyota owner manual OM35B85U: tire/wheel specifications and flat-tire installation instructions list aluminum wheel nut torque as 97 ft-lbf / 131 N-m. Steel spare wheel torque is listed separately as 154 ft-lbf / 209 N-m.'
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
    notes = 'Toyota owner manual specifies 97 ft-lbf / 131 N-m for aluminum wheels. Tighten in a criss-cross/star pattern with a calibrated torque wrench and re-check after wheel service.',
    warning = 'Use only Toyota-specified wheel nuts for the wheel. Do not apply oil or grease to wheel nuts, wheel bolts, or wheel mounting surfaces.',
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
      lower(spec.component) like '%toyota 6th gen 4runner%'
      or lower(spec.fastener) in (
        lower('Wheel lug nuts - GR86/Supra baseline'),
        lower('Wheel lug nuts - Toyota truck/SUV baseline')
      )
    )
)
delete from public.torque_specs spec
using conflicting_donor_rows donor
where spec.id = donor.id;
