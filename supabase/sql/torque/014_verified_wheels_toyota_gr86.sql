-- Offset Lab Torque Hub
-- Pack 014: verified Toyota GR86 wheel lug torque.
--
-- Plain SQL only. Safe to re-run.
-- Updates the existing Toyota ZN8 GR86 wheel lug row from needs_review to
-- verified after checking Toyota's official 2024 86 Owner's Manual
-- (OM18155U), tire-change instructions and specifications.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'toyota',
      'gr86',
      'zn8-gr86',
      'Wheel lug nuts',
      89,
      120,
      'Toyota 2024 86 Owner''s Manual USA and Canada Only (OM18155U)',
      'https://assets.sipb.toyota.com/publications/en/om-s/OM18155U/pdf/OM18155U.pdf',
      'Verified from Toyota owner manual OM18155U: tire-change instructions and specifications list wheel nut torque as 89 ft-lbf / 120 N-m.'
    )
)
update public.torque_specs spec
set
  torque_ft_lb = seed.torque_ft_lb::numeric,
  torque_nm = seed.torque_nm::numeric,
  angle_degrees = null,
  notes = 'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.',
  warning = 'Use only the vehicle-specific wheel fasteners and do not oil or grease wheel studs, bolts, or nuts unless the service manual explicitly instructs it.',
  source_status = 'verified',
  source_name = seed.source_name,
  source_url = seed.source_url,
  source_note = seed.source_note,
  source_checked_at = now()
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
where spec.generation_id = generation_row.id
  and spec.category_id = category_row.id
  and lower(spec.component) = lower('Wheels')
  and lower(spec.fastener) = lower(seed.fastener)
  and spec.source_status <> 'verified';
