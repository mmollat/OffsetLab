-- Offset Lab Torque Hub
-- Pack 019: verified Subaru BRZ wheel lug torque.
--
-- Plain SQL only. Safe to re-run.
-- Updates both Subaru BRZ wheel lug rows from needs_review to verified after
-- checking Subaru's official 2024 BRZ Owner's Manual (MSA5M2406A), Flat Tires
-- instructions and Tires specifications.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'subaru',
      'brz',
      'zd8-brz',
      'Wheel lug nuts',
      89,
      120,
      'Subaru 2024 BRZ Owner''s Manual (MSA5M2406A)',
      'https://techinfo.subaru.com/stis/doc/ownerManual/MSA5M2406A_STIS-opt.pdf',
      'Verified from Subaru owner manual MSA5M2406A: Flat Tires directs final tightening to the Tires specification table, which lists wheel nut tightening torque as 88.5 lbf-ft / 120 N-m.'
    ),
    (
      'subaru',
      'brz',
      'zn8-zd8-brz',
      'Wheel lug nuts',
      89,
      120,
      'Subaru 2024 BRZ Owner''s Manual (MSA5M2406A)',
      'https://techinfo.subaru.com/stis/doc/ownerManual/MSA5M2406A_STIS-opt.pdf',
      'Verified from Subaru owner manual MSA5M2406A: Flat Tires directs final tightening to the Tires specification table, which lists wheel nut tightening torque as 88.5 lbf-ft / 120 N-m.'
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
  and spec.source_status is distinct from 'verified';
