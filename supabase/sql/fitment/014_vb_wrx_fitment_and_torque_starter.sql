-- VB WRX fitment coverage and Torque Hub starter pack.
--
-- Plain SQL only. Safe to re-run.
-- Fitment rows are enthusiast recommendations; factory baseline remains in
-- fitment/013 as needs_review until checked against OEM-grade sources.

insert into public.vehicle_models (make, model, active, sort_order, display_name, year_start, year_end)
select 'Subaru', 'VB', true, 0, 'VB - WRX', 2022, null
where not exists (
  select 1 from public.vehicle_models where make = 'Subaru' and model = 'VB'
);

create temp table if not exists vb_wrx_fitment_rows (
  style text,
  title text,
  subtitle text,
  front text,
  rear text,
  front_tire text,
  rear_tire text,
  poke_front text,
  poke_rear text,
  inner_front text,
  inner_rear text,
  diameter text,
  aggression int,
  daily int,
  risk text,
  verdict text,
  warnings text[],
  alternate text,
  sort_order int
) on commit drop;

truncate table vb_wrx_fitment_rows;

insert into vb_wrx_fitment_rows (
  style, title, subtitle, front, rear, front_tire, rear_tire, poke_front, poke_rear,
  inner_front, inner_rear, diameter, aggression, daily, risk, verdict, warnings, alternate, sort_order
)
values
  ('oemplus', 'OEM+ Setup', 'Clean daily fitment', '18x8.5 +45', '18x8.5 +45', '245/40R18', '245/40R18', 'Clean', 'Clean', 'Safe', 'Safe', '+0.0%', 5, 9, 'Low', 'Clean VB WRX daily fitment with a fuller stance and low compromise.', array[]::text[], '18x9 +45 with 255/35R18', 0),
  ('flush', 'Flush Setup', 'Balanced street stance', '18x9.5 +38', '18x9.5 +38', '255/35R18', '255/35R18', 'Flush', 'Flush', 'Tight', 'Tight', '-1.3%', 7, 8, 'Low / Moderate', 'Popular VB WRX flush setup with strong street presence. Verify tire shoulder and ride height before ordering.', array[]::text[], '18x9.5 +40 with 245/40R18', 0),
  ('aggressive', 'Aggressive Setup', 'Wide square stance', '18x9.5 +35', '18x9.5 +35', '265/35R18', '265/35R18', 'Aggressive', 'Aggressive', 'Tight', 'Very tight', '-0.2%', 8, 7, 'Moderate', 'Aggressive VB WRX square fitment. Lowered cars may need alignment and rear clearance work.', array['TR/tS Brembo cars need spoke-clearance verification before ordering.']::text[], '18x9.5 +38 with 255/35R18', 0);

update public.fitment_presets fp
set
  title = src.title,
  subtitle = src.subtitle,
  front = src.front,
  rear = src.rear,
  front_tire = src.front_tire,
  rear_tire = src.rear_tire,
  poke_front = src.poke_front,
  poke_rear = src.poke_rear,
  inner_front = src.inner_front,
  inner_rear = src.inner_rear,
  diameter = src.diameter,
  aggression = src.aggression,
  daily = src.daily,
  risk = src.risk,
  verdict = src.verdict,
  warnings = src.warnings,
  alternate = src.alternate,
  active = true,
  sort_order = src.sort_order,
  bolt_pattern = '5x114.3',
  center_bore = '56.1mm'
from vb_wrx_fitment_rows src
where fp.make = 'Subaru'
  and fp.model = 'VB'
  and fp.trim = 'WRX'
  and fp.style = src.style;

insert into public.fitment_presets (
  make, model, trim, style, title, subtitle, front, rear, front_tire, rear_tire,
  poke_front, poke_rear, inner_front, inner_rear, diameter, aggression, daily,
  risk, verdict, warnings, alternate, active, sort_order, bolt_pattern, center_bore
)
select
  'Subaru', 'VB', 'WRX', src.style, src.title, src.subtitle, src.front, src.rear, src.front_tire, src.rear_tire,
  src.poke_front, src.poke_rear, src.inner_front, src.inner_rear, src.diameter, src.aggression, src.daily,
  src.risk, src.verdict, src.warnings, src.alternate, true, src.sort_order, '5x114.3', '56.1mm'
from vb_wrx_fitment_rows src
where not exists (
  select 1 from public.fitment_presets fp
  where fp.make = 'Subaru'
    and fp.model = 'VB'
    and fp.trim = 'WRX'
    and fp.style = src.style
);

insert into public.torque_vehicle_models (make_id, name, slug)
select m.id, 'WRX', 'wrx'
from public.torque_vehicle_makes m
where m.slug = 'subaru'
  and not exists (
    select 1 from public.torque_vehicle_models existing
    where existing.make_id = m.id and existing.slug = 'wrx'
  );

insert into public.torque_vehicle_generations (model_id, name, slug, start_year, end_year)
select vm.id, 'VB - WRX', 'vb-wrx', 2022, null
from public.torque_vehicle_makes m
join public.torque_vehicle_models vm on vm.make_id = m.id and vm.slug = 'wrx'
where m.slug = 'subaru'
  and not exists (
    select 1 from public.torque_vehicle_generations existing
    where existing.model_id = vm.id and existing.slug = 'vb-wrx'
  );

with target as (
  select g.id as generation_id, c.id as category_id
  from public.torque_vehicle_makes m
  join public.torque_vehicle_models vm on vm.make_id = m.id and vm.slug = 'wrx'
  join public.torque_vehicle_generations g on g.model_id = vm.id and g.slug = 'vb-wrx'
  join public.torque_categories c on c.slug = 'wheels'
  where m.slug = 'subaru'
)
insert into public.torque_specs (
  generation_id, category_id, component, fastener, torque_ft_lb, torque_nm, angle_degrees,
  notes, warning, source_status, source_name, source_url, source_note, source_checked_at
)
select
  target.generation_id, target.category_id, 'Wheels', 'Wheel lug nuts', 89, 120, null,
  'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.',
  'Use only vehicle-specific wheel fasteners. Do not oil or grease wheel studs, bolts, or nuts unless the service manual explicitly instructs it.',
  'verified',
  'Subaru WRX owner manual tire specifications',
  'https://ownersmanuals2.com/subaru/wrx-2022-owners-manual-90860/page-477',
  'Verified from Subaru WRX owner manual tire specifications listing wheel nut tightening torque as 89 lbf-ft / 120 N-m.',
  now()
from target
where not exists (
  select 1 from public.torque_specs spec
  where spec.generation_id = target.generation_id
    and spec.category_id = target.category_id
    and lower(spec.component) = lower('Wheels')
    and lower(spec.fastener) = lower('Wheel lug nuts')
);
