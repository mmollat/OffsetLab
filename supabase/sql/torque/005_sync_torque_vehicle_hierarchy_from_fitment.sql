-- Offset Lab Torque Hub
-- Pack 005: sync Torque Hub vehicle hierarchy from active Fitment vehicles.
--
-- Plain SQL only. Safe to re-run.
-- This creates missing torque_vehicle_makes, torque_vehicle_models, and
-- torque_vehicle_generations rows so specs can be attached later.
-- It does not insert torque spec values.

with fitment as (
  select distinct
    make,
    model,
    coalesce(display_name, model) as generation_name,
    case
      when coalesce(display_name, model) like '% - %' then nullif(trim(split_part(coalesce(display_name, model), ' - ', 2)), '')
      else coalesce(display_name, model)
    end as model_name,
    year_start,
    year_end,
    trim(both '-' from regexp_replace(lower(make), '[^a-z0-9]+', '-', 'g')) as make_slug,
    trim(both '-' from regexp_replace(lower(
      case
        when coalesce(display_name, model) like '% - %' then nullif(trim(split_part(coalesce(display_name, model), ' - ', 2)), '')
        else coalesce(display_name, model)
      end
    ), '[^a-z0-9]+', '-', 'g')) as model_slug,
    trim(both '-' from regexp_replace(lower(coalesce(display_name, model)), '[^a-z0-9]+', '-', 'g')) as generation_slug
  from public.vehicle_models
  where active = true
),
inserted_makes as (
  insert into public.torque_vehicle_makes (name, slug)
  select distinct f.make, f.make_slug
  from fitment f
  where not exists (
    select 1
    from public.torque_vehicle_makes existing
    where existing.slug = f.make_slug
  )
  returning id
),
inserted_models as (
  insert into public.torque_vehicle_models (make_id, name, slug)
  select distinct make_row.id, f.model_name, f.model_slug
  from fitment f
  join public.torque_vehicle_makes make_row on make_row.slug = f.make_slug
  where f.model_name is not null
    and f.model_slug is not null
    and f.model_slug <> ''
    and not exists (
      select 1
      from public.torque_vehicle_models existing
      where existing.make_id = make_row.id
        and existing.slug = f.model_slug
    )
  returning id
)
insert into public.torque_vehicle_generations (
  model_id,
  name,
  slug,
  start_year,
  end_year
)
select distinct
  model_row.id,
  f.generation_name,
  f.generation_slug,
  coalesce(f.year_start, 0),
  f.year_end
from fitment f
join public.torque_vehicle_makes make_row on make_row.slug = f.make_slug
join public.torque_vehicle_models model_row on model_row.make_id = make_row.id and model_row.slug = f.model_slug
where f.generation_slug is not null
  and f.generation_slug <> ''
  and not exists (
    select 1
    from public.torque_vehicle_generations existing
    where existing.model_id = model_row.id
      and existing.slug = f.generation_slug
  );
