-- Offset Lab Torque Hub
-- Pack 013: starter Fluids coverage for partial active Fitment vehicles.
--
-- Plain SQL only. Safe to re-run.
-- Adds a clearly labeled needs_review Fluids starter row only when an active
-- fitment generation has no Fluids specs. Numeric torque and capacity values
-- are left null on purpose: drain/fill plugs, fluid types, and service
-- quantities vary too much by chassis, powertrain, transmission, and market
-- for a broad default.

with targets as (
  select
    coverage.make,
    coverage.model,
    coverage.display_name,
    coverage.torque_generation_id
  from public.torque_fitment_coverage coverage
  where coverage.coverage_status = 'partial'
    and 'fluids' = any(coverage.categories_missing)
    and coverage.torque_generation_id is not null
    and not exists (
      select 1
      from public.torque_specs spec
      join public.torque_categories category
        on category.id = spec.category_id
      where spec.generation_id = coverage.torque_generation_id
        and category.slug = 'fluids'
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
  targets.torque_generation_id,
  category.id,
  'Fluids Starter Reference',
  'Exact fluid service item, capacity, type, or plug torque pending',
  null::numeric,
  null::numeric,
  null::numeric,
  'Starter coverage row for TorqueHub navigation. Attach exact service-manual fluid capacities, specifications, intervals, and plug fastener torques before using this category for repair work.',
  'Fluid service details are platform, powertrain, transmission, and market-specific. This row intentionally has no torque or capacity value until an exact source is attached.',
  'needs_review',
  targets.make || ' fluids service reference',
  null,
  'Fitment-driven starter Fluids coverage for ' || targets.display_name || '. Placeholder only; replace with exact service-manual fluid data before marking verified.',
  now()
from targets
join public.torque_categories category
  on category.slug = 'fluids';
