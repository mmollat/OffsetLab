-- Offset Lab Torque Hub
-- Pack 008: starter Brakes coverage for active Fitment vehicles.
--
-- Plain SQL only. Safe to re-run.
-- Adds one brake bleeder screw row only when the exact Fitment generation has
-- no Brakes specs. These are baseline values marked needs_review, not complete
-- caliper/carrier/bracket specification sets.

with fitment_targets as (
  select
    vm.make,
    trim(both '-' from regexp_replace(lower(vm.make), '[^a-z0-9]+', '-', 'g')) as make_slug,
    trim(both '-' from regexp_replace(lower(
      case
        when coalesce(vm.display_name, vm.model) like '% - %'
          then nullif(trim(split_part(coalesce(vm.display_name, vm.model), ' - ', 2)), '')
        else coalesce(vm.display_name, vm.model)
      end
    ), '[^a-z0-9]+', '-', 'g')) as model_slug,
    trim(both '-' from regexp_replace(lower(coalesce(vm.display_name, vm.model)), '[^a-z0-9]+', '-', 'g')) as generation_slug
  from public.vehicle_models vm
  where vm.active = true
),
targets as (
  select
    fitment.make,
    generation_row.id as generation_id,
    case
      when fitment.make = 'Mercedes-Benz' then 5
      when fitment.make in (
        'Audi',
        'BMW',
        'Ferrari',
        'Lamborghini',
        'McLaren',
        'Porsche',
        'Volkswagen'
      ) then 7
      else 8
    end as torque_ft_lb,
    case
      when fitment.make = 'Mercedes-Benz' then 7
      when fitment.make in (
        'Audi',
        'BMW',
        'Ferrari',
        'Lamborghini',
        'McLaren',
        'Porsche',
        'Volkswagen'
      ) then 10
      else 11
    end as torque_nm
  from fitment_targets fitment
  join public.torque_vehicle_makes make_row
    on make_row.slug = fitment.make_slug
  join public.torque_vehicle_models model_row
    on model_row.make_id = make_row.id
   and model_row.slug = fitment.model_slug
  join public.torque_vehicle_generations generation_row
    on generation_row.model_id = model_row.id
   and generation_row.slug = fitment.generation_slug
  where not exists (
    select 1
    from public.torque_specs spec
    join public.torque_categories category
      on category.id = spec.category_id
    where spec.generation_id = generation_row.id
      and category.slug = 'brakes'
  )
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
  targets.generation_id,
  category.id,
  'Brake Bleeder',
  'Brake bleeder screw',
  targets.torque_ft_lb::numeric,
  targets.torque_nm::numeric,
  null::numeric,
  'Small fastener. Seat gently and do not over-tighten. Confirm the hydraulic system is leak-free after bleeding.',
  'Brake bleeder screws are safety-critical and easy to damage. Verify the exact caliper and model-year service manual before use.',
  'needs_review',
  targets.make || ' brake bleeder service reference',
  null,
  'Fitment-driven starter Brakes coverage. This is not a complete caliper/bracket specification set. Attach the exact model-year service source before marking verified.',
  now()
from targets
join public.torque_categories category
  on category.slug = 'brakes';
