-- Offset Lab Torque Hub
-- Pack 002a: canary pack for Toyota GR86 wheel lug torque.
--
-- Plain SQL only. Safe to re-run.
-- Existing matching Torque Hub specs are retained and not overwritten.

insert into public.torque_vehicle_makes (name, slug)
select 'Toyota', 'toyota'
where not exists (
  select 1 from public.torque_vehicle_makes where slug = 'toyota'
);

insert into public.torque_vehicle_models (make_id, name, slug)
select make_row.id, 'GR86', 'gr86'
from public.torque_vehicle_makes make_row
where make_row.slug = 'toyota'
  and not exists (
    select 1
    from public.torque_vehicle_models model_row
    where model_row.make_id = make_row.id
      and model_row.slug = 'gr86'
  );

insert into public.torque_vehicle_generations (
  model_id,
  name,
  slug,
  start_year,
  end_year
)
select model_row.id, 'ZN8 GR86', 'zn8-gr86', 2022, null
from public.torque_vehicle_models model_row
join public.torque_vehicle_makes make_row on make_row.id = model_row.make_id
where make_row.slug = 'toyota'
  and model_row.slug = 'gr86'
  and not exists (
    select 1
    from public.torque_vehicle_generations generation_row
    where generation_row.model_id = model_row.id
      and generation_row.slug = 'zn8-gr86'
  );

insert into public.torque_specs (
  generation_id,
  category_id,
  component,
  fastener,
  torque_ft_lb,
  torque_nm,
  angle_degrees,
  notes,
  warning,
  source_status,
  source_name,
  source_url,
  source_note,
  source_checked_at
)
select
  generation_row.id,
  category_row.id,
  'Wheels',
  'Wheel lug nuts',
  89,
  120,
  null,
  'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.',
  null,
  'needs_review',
  'Toyota GR86 owner manual / service reference',
  null,
  'Initial seed value. Attach model-year manual URL before marking verified.',
  now()
from public.torque_vehicle_generations generation_row
join public.torque_vehicle_models model_row on model_row.id = generation_row.model_id
join public.torque_vehicle_makes make_row on make_row.id = model_row.make_id
join public.torque_categories category_row on category_row.slug = 'wheels'
where make_row.slug = 'toyota'
  and model_row.slug = 'gr86'
  and generation_row.slug = 'zn8-gr86'
  and not exists (
    select 1
    from public.torque_specs existing
    where existing.generation_id = generation_row.id
      and existing.category_id = category_row.id
      and lower(existing.component) = lower('Wheels')
      and lower(existing.fastener) = lower('Wheel lug nuts')
  );

