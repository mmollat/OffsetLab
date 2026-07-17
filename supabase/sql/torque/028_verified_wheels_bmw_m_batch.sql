-- Offset Lab Torque Hub
-- Pack 028: verified BMW M wheel lug bolt torque batch.
--
-- Plain SQL only. Safe to re-run.
-- BMW owner manual wheel-change guidance for these M models specifies
-- wheel lug bolt tightening torque as 101 lb-ft / 140 N-m.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'bmw',
      'm2',
      'f87-m2',
      'Wheel lug bolts',
      101,
      140,
      'BMW M2 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/bmw-m2-2017-owners-manual/18',
      'Verified from BMW M2 owner manual wheel-change guidance: wheel lug bolt tightening torque is 101 lb-ft / 140 N-m.'
    ),
    (
      'bmw',
      'm3',
      'f80-m3',
      'Wheel lug bolts',
      101,
      140,
      'BMW M3 owner manual and BMW parts torque reference',
      'https://www.bmwpartsdeal.com/parts-list/2017-bmw-m3-sedan_f80/wheels/torque_wrench.html',
      'Verified from BMW M3 owner manual family guidance and BMW parts torque reference listing the wheel torque wrench specification at 140 N-m; BMW publishes this wheel torque as 101 lb-ft / 140 N-m.'
    ),
    (
      'bmw',
      'm3',
      'g80-m3',
      'Wheel lug bolts',
      101,
      140,
      'BMW M3 owner manual wheel-change guidance',
      'https://ownersmanuals2.com/bmw-auto/m3-2022-owners-manual-83680/page-346',
      'Verified from BMW M3 owner manual wheel-change guidance: wheel lug bolt tightening torque is 101 lb-ft / 140 N-m.'
    ),
    (
      'bmw',
      'm4',
      'f82-m4',
      'Wheel lug bolts',
      101,
      140,
      'BMW M4 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/bmw-m4-2018-owners-manual/22',
      'Verified from BMW M4 owner manual wheel-change guidance: wheel lug bolt tightening torque is 101 lb-ft / 140 N-m.'
    ),
    (
      'bmw',
      'm4',
      'g82-m4',
      'Wheel lug bolts',
      101,
      140,
      'BMW M4 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/bmw-m4-2022-owners-manual/35',
      'Verified from BMW M4 owner manual wheel-change guidance: wheel lug bolt tightening torque is 101 lb-ft / 140 N-m.'
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
    notes = 'BMW owner manual wheel-change guidance specifies this wheel lug bolt torque. Tighten in a diagonal/star pattern with clean, dry threads and a calibrated torque wrench.',
    warning = 'Use the correct BMW lug bolts for the wheel. Never use oil, grease, or anti-seize on wheel bolts, wheel hub threads, or wheel mounting surfaces unless the service manual explicitly instructs it.',
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
)
select count(*) as updated_verified_bmw_m_wheel_rows
from updated_primary;
