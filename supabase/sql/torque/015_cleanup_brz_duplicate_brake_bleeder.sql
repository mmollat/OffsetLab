-- Offset Lab Torque Hub
-- Pack 015: remove duplicate Subaru BRZ brake bleeder community row.
--
-- Plain SQL only. Safe to re-run.
-- The ZN8/ZD8 BRZ generation had both a newer needs_review brake bleeder row
-- and an older community twin-platform import for the same fastener/value. Keep
-- the newer needs_review row and remove only the older community duplicate.

with target_generation as (
  select generation_row.id
  from public.torque_vehicle_makes make_row
  join public.torque_vehicle_models model_row
    on model_row.make_id = make_row.id
   and model_row.slug = 'brz'
  join public.torque_vehicle_generations generation_row
    on generation_row.model_id = model_row.id
   and generation_row.slug = 'zn8-zd8-brz'
  where make_row.slug = 'subaru'
),
keeper as (
  select 1
  from public.torque_specs spec
  join public.torque_categories category
    on category.id = spec.category_id
   and category.slug = 'brakes'
  join target_generation generation
    on generation.id = spec.generation_id
  where lower(spec.component) = lower('Brake Bleeder')
    and lower(spec.fastener) = lower('Brake bleeder screw')
    and spec.torque_ft_lb = 8
    and spec.torque_nm = 11
    and spec.source_status = 'needs_review'
  limit 1
)
delete from public.torque_specs spec
using public.torque_categories category, target_generation generation
where exists (select 1 from keeper)
  and spec.category_id = category.id
  and category.slug = 'brakes'
  and spec.generation_id = generation.id
  and lower(spec.component) = lower('Brake Bleeder [Subaru ZD8 BRZ / Toyota ZN8 twin]')
  and lower(spec.fastener) = lower('Brake bleeder screw')
  and spec.torque_ft_lb = 8
  and spec.torque_nm = 11
  and spec.source_status = 'community';
