-- Offset Lab Torque Hub
-- Pack 011: starter Engine coverage for partial active Fitment vehicles.
--
-- Plain SQL only. Safe to re-run.
-- Adds a clearly labeled needs_review Engine/Powertrain starter row only when
-- an active fitment generation has no Engine specs. Numeric torque is left null
-- on purpose: exact engine oil, accessory, mount, or EV drive-unit fasteners
-- vary too much by chassis and powertrain to use a broad default safely.

with targets as (
  select
    coverage.make,
    coverage.model,
    coverage.display_name,
    coverage.torque_generation_id
  from public.torque_fitment_coverage coverage
  where coverage.coverage_status = 'partial'
    and 'engine' = any(coverage.categories_missing)
    and coverage.torque_generation_id is not null
    and not exists (
      select 1
      from public.torque_specs spec
      join public.torque_categories category
        on category.id = spec.category_id
      where spec.generation_id = coverage.torque_generation_id
        and category.slug = 'engine'
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
  'Engine / Powertrain Starter Reference',
  'Exact engine or powertrain service fastener pending',
  null::numeric,
  null::numeric,
  null::numeric,
  'Starter coverage row for TorqueHub navigation. Attach exact engine oil, accessory, mount, or EV drive-unit service-manual fasteners before using this category for repair work.',
  'Engine and powertrain fasteners are safety-critical and highly platform-specific. This row intentionally has no torque value until an exact source is attached.',
  'needs_review',
  targets.make || ' engine or powertrain service reference',
  null,
  'Fitment-driven starter Engine coverage for ' || targets.display_name || '. Placeholder only; replace with exact service-manual fasteners before marking verified.',
  now()
from targets
join public.torque_categories category
  on category.slug = 'engine';
