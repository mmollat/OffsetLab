-- Offset Lab Torque Hub
-- Pack 007: Infiniti V36 G37 hierarchy and wheel torque.
--
-- Plain SQL only. Safe to re-run.
-- Existing matching rows are retained.

with make_row as (
  insert into public.torque_vehicle_makes (name, slug)
  values ('Infiniti', 'infiniti')
  on conflict (slug) do update set name = excluded.name
  returning id
),
selected_make as (
  select id from make_row
  union all
  select id from public.torque_vehicle_makes where slug = 'infiniti'
  limit 1
),
model_row as (
  insert into public.torque_vehicle_models (make_id, name, slug)
  select id, 'G37', 'g37' from selected_make
  where not exists (
    select 1
    from public.torque_vehicle_models existing
    where existing.make_id = selected_make.id
      and existing.slug = 'g37'
  )
  returning id
),
selected_model as (
  select id from model_row
  union all
  select existing.id
  from public.torque_vehicle_models existing
  join selected_make on selected_make.id = existing.make_id
  where existing.slug = 'g37'
  limit 1
),
generation_row as (
  insert into public.torque_vehicle_generations (
    model_id,
    name,
    slug,
    start_year,
    end_year
  )
  select id, 'V36 - G37', 'v36-g37', 2008, 2013
  from selected_model
  where not exists (
    select 1
    from public.torque_vehicle_generations existing
    where existing.model_id = selected_model.id
      and existing.slug = 'v36-g37'
  )
  returning id
),
selected_generation as (
  select id from generation_row
  union all
  select existing.id
  from public.torque_vehicle_generations existing
  join selected_model on selected_model.id = existing.model_id
  where existing.slug = 'v36-g37'
  limit 1
)
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
  selected_generation.id,
  category.id,
  'Wheels',
  'Wheel lug nuts',
  80::numeric,
  108::numeric,
  null::numeric,
  'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.',
  'Verify against the exact model-year owner manual before using on customer vehicles.',
  'needs_review',
  'Infiniti G37 owner manual / Nissan platform service reference',
  null,
  'Initial V36 G37 wheel torque seed. Attach an exact model-year Infiniti manual URL before marking verified.',
  now()
from selected_generation
join public.torque_categories category on category.slug = 'wheels'
where not exists (
  select 1
  from public.torque_specs existing
  where existing.generation_id = selected_generation.id
    and existing.category_id = category.id
    and lower(existing.component) = lower('Wheels')
    and lower(existing.fastener) = lower('Wheel lug nuts')
);
