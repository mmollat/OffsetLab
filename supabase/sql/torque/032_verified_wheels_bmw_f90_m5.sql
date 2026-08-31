-- Offset Lab Torque Hub
-- Pack 032: verified BMW F90 M5 wheel lug bolt torque.
--
-- Plain SQL only. Safe to re-run.
-- BMW M5 owner manual wheel-change guidance specifies wheel lug bolt
-- tightening torque as 101 lb-ft / 140 Nm.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'bmw',
      'm5',
      'f90-m5',
      'Wheel lug bolts',
      101,
      140,
      'BMW M5 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/bmw-m5-2019-owners-manual/32',
      'Verified from BMW M5 owner manual wheel-change guidance: after wheel change, tighten lug bolts crosswise to 101 lb-ft / 140 Nm.'
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
    notes = 'BMW M5 owner manual wheel-change guidance specifies this wheel lug bolt torque. Tighten crosswise with clean, dry threads and a calibrated torque wrench.',
    warning = 'Use the correct BMW lug bolts for the wheel. Never use oil, grease, or anti-seize on wheel bolts, wheel hub threads, or wheel mounting surfaces unless the service manual explicitly instructs it.',
    source_status = 'verified',
    source_name = target.source_name,
    source_url = target.source_url,
    source_note = target.source_note,
    source_checked_at = now()
  from target
  where spec.generation_id = target.generation_id
    and spec.category_id = target.category_id
    and lower(spec.component) in (lower('Wheels'), lower('Wheel Lug Bolts'))
    and lower(spec.fastener) in (lower('Wheel lug bolts'), lower('Wheel Bolt'))
  returning spec.id
)
select count(*) as updated_verified_bmw_f90_m5_wheel_rows
from updated_primary;
