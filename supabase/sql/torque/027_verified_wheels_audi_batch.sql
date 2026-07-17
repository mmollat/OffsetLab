-- Offset Lab Torque Hub
-- Pack 027: verified Audi wheel lug bolt torque batch.
--
-- Plain SQL only. Safe to re-run.
-- Audi owner manual excerpts and Audi wheel-bolt torque references confirm
-- most passenger-car wheel bolt rows at 120 N-m / 89 ft-lb. The FY Q5/SQ5
-- owner manual family uses 140 N-m / 100 ft-lb instead.
--
-- The mixed 8Y A3/S3/RS3 generation is intentionally excluded from this pack:
-- available owner-manual data can split A3/S3 and RS models, so it needs a
-- more granular data model or model-specific row before marking verified.

with seed(make_slug, model_slug, generation_slug, fastener, torque_ft_lb, torque_nm, source_name, source_url, source_note) as (
  values
    (
      'audi',
      'a3-s3-rs3',
      '8v-a3-s3-rs3',
      'Wheel lug bolts',
      89,
      120,
      'Audi A3/S3 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-a3-sedan-2018-owners-manual/?srch=wheel+bolts',
      'Verified from Audi A3/S3 owner manual wheel-change guidance: steel and alloy wheel rims are tightened to 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      'a4-s4-rs4',
      'b8-5-a4-s4-rs4',
      'Wheel lug bolts',
      89,
      120,
      'Audi A4 and RS5 owner manual wheel-bolt guidance',
      'https://www.carmanualsonline.info/audi-a4-2015-owners-manual/?srch=wheel+bolts',
      'Verified from Audi owner manual wheel-change guidance: steel and alloy wheel rims are tightened to 90 ft-lb / 120 N-m. Audi wheel-bolt torque references also list A4/S4/RS4 B8 family at 120 N-m.'
    ),
    (
      'audi',
      'a4-s4-s5-rs5',
      'b9-a4-s4-s5-rs5',
      'Wheel lug bolts',
      89,
      120,
      'Audi A4/A5 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-a4-2020-owners-manual/?srch=torque',
      'Verified from Audi A4/A5 owner manual wheel-change guidance: wheel bolt tightening specification is 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      'r8',
      '42-r8',
      'Wheel lug bolts',
      89,
      120,
      'Audi R8 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-r8-2007-owners-manual/?srch=wheel+bolts',
      'Verified from Audi R8 owner manual wheel-change guidance: wheel bolt tightening torque is 120 N-m.'
    ),
    (
      'audi',
      'r8',
      '4s-r8',
      'Wheel lug bolts',
      89,
      120,
      'Audi R8 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-r8-coupe-2020-owners-manual/?srch=wheel+bolt+torque',
      'Verified from Audi R8 owner manual wheel-change guidance: wheel bolt tightening specification is 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      'rs5',
      'b9-5-rs5',
      'Wheel lug bolts',
      89,
      120,
      'Audi A5/S5/RS5 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-a5-2020-owners-manual/?srch=wheel+bolt+torque',
      'Verified from Audi A5/S5/RS5 owner manual wheel-change guidance: wheel bolt tightening specification is 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      'rs6-avant',
      'c8-rs6-avant',
      'Wheel lug bolts',
      89,
      120,
      'Audi online owner manual wheel-change guidance',
      'https://ownersmanual.audi.com/home/en_US',
      'Verified from Audi online owner manual wheel-change guidance for C8 RS6: wheel bolts are tightened to 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      'rs7',
      'c7-rs7',
      'Wheel lug bolts',
      89,
      120,
      'Audi RS7 owner manual wheel-bolt guidance',
      'https://www.carmanualsonline.info/audi-rs7-sportback-2015-owners-manual/?srch=wheel+bolts',
      'Verified from Audi RS7 owner manual wheel-bolt guidance: specified wheel bolt torque is 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      's4-s5',
      'b8-s4-s5',
      'Wheel lug bolts',
      89,
      120,
      'Audi A4/A5 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-a5-coupe-2014-owners-manual/?srch=wheel+bolts',
      'Verified from Audi A4/A5 owner manual wheel-change guidance: steel and alloy wheel rims are tightened to 90 ft-lb / 120 N-m.'
    ),
    (
      'audi',
      'sq5',
      'fy-sq5',
      'Wheel lug bolts',
      100,
      140,
      'Audi Q5/SQ5 owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-q5-2021-owner/?srch=torque',
      'Verified from Audi Q5/SQ5 owner manual wheel-change guidance: wheel bolt tightening specification is 100 ft-lb / 140 N-m.'
    ),
    (
      'audi',
      'tt-tts-tt-rs',
      '8s-tt-tts-tt-rs',
      'Wheel lug bolts',
      89,
      120,
      'Audi TT owner manual wheel-change guidance',
      'https://www.carmanualsonline.info/audi-tt-coupe-2020-owners-manual/?srch=wheel+torque',
      'Verified from Audi TT owner manual wheel-change guidance: wheel bolt tightening specification is 90 ft-lb / 120 N-m.'
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
    notes = 'Audi owner manual guidance specifies this wheel bolt torque. Tighten in a diagonal/star pattern with clean, dry threads and a calibrated torque wrench.',
    warning = 'Use the correct Audi wheel bolts for the wheel. Never use oil, grease, or anti-seize on wheel bolts, wheel hub threads, or wheel mounting surfaces unless the service manual explicitly instructs it.',
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
select count(*) as updated_verified_audi_wheel_rows
from updated_primary;
