-- Offset Lab Torque Hub
-- Pack 021: attach official Mazda ND MX-5 wheel lug torque source.
--
-- Plain SQL only. Safe to re-run.
-- Mazda's official 2024 MX-5 Owner's Manual specifies a wheel lug nut torque
-- range: 108-147 N-m / 80-108 ft-lbf. Torque Hub currently stores one numeric
-- torque value, so this pack attaches the official source and keeps the row
-- needs_review until range display/storage is supported or a single shop policy
-- value is intentionally chosen.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'mazda',
      'mx-5-miata',
      'nd-mx-5-miata',
      'Wheel lug nuts',
      80,
      108,
      'Mazda 2024 MX-5 Miata Owner''s Manual',
      'https://www.mazdausa.com/siteassets/global-resources/vehicle-resources/owner-manuals/2024/mx-5/2024-mx-5-miata-owners-manual2.pdf',
      'Official Mazda owner manual lists lug nut tightening torque as 108-147 N-m / 80-108 ft-lbf. Current torque_specs schema stores one numeric value, so this row keeps the lower-bound seed and remains needs_review until range support or a deliberate canonical value is added.'
    )
)
update public.torque_specs spec
set
  torque_ft_lb = seed.torque_ft_lb::numeric,
  torque_nm = seed.torque_nm::numeric,
  angle_degrees = null,
  notes = 'Mazda owner manual specifies a lug nut torque range of 80-108 ft-lbf / 108-147 N-m. Tighten in a criss-cross/star pattern with a calibrated torque wrench.',
  warning = 'Do not apply oil or grease to lug nuts or wheel studs. Do not tighten beyond the recommended Mazda torque range.',
  source_status = 'needs_review',
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
