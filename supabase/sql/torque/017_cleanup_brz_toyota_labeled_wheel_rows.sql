-- Offset Lab Torque Hub
-- Pack 017: remove confusing Toyota-labeled Subaru BRZ wheel community rows.
--
-- Plain SQL only. Safe to re-run.
-- The canonical ZN8/ZD8 BRZ generation had a clean Subaru wheel lug row plus
-- two older community rows imported with Toyota donor/baseline labels. Keep the
-- clean Subaru row and remove only those community donor-label rows.

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
   and category.slug = 'wheels'
  join target_generation generation
    on generation.id = spec.generation_id
  where lower(spec.component) = lower('Wheels')
    and lower(spec.fastener) = lower('Wheel lug nuts')
    and spec.torque_ft_lb = 89
    and spec.torque_nm = 120
    and spec.source_status <> 'community'
  limit 1
)
delete from public.torque_specs spec
using public.torque_categories category, target_generation generation
where exists (select 1 from keeper)
  and spec.category_id = category.id
  and category.slug = 'wheels'
  and spec.generation_id = generation.id
  and lower(spec.component) = lower('Wheel [Subaru ZD8 BRZ / Toyota ZN8 twin]')
  and spec.source_status = 'community'
  and (
    lower(spec.fastener) = lower('Wheel lug nuts - GR86/Supra baseline')
    or lower(spec.fastener) = lower('Wheel lug nuts - Toyota truck/SUV baseline')
  );
