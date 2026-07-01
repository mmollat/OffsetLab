-- Offset Lab Torque Hub
-- Pack 010: starter Suspension coverage for partial active Fitment vehicles.
--
-- Plain SQL only. Safe to re-run.
-- Adds a small, explicitly needs_review suspension starter row only when an
-- active fitment generation has no Suspension specs. This is not a complete
-- suspension torque set and must not be marked verified until checked against
-- the exact chassis/model-year service manual.

with targets as (
  select
    coverage.make,
    coverage.model,
    coverage.display_name,
    coverage.torque_generation_id,
    case
      when coverage.make in ('Acura', 'Honda') then 47
      when coverage.make in ('Chevrolet', 'Cadillac', 'Dodge', 'Ford') then 59
      when coverage.make in ('Ferrari', 'Lamborghini', 'McLaren') then 52
      when coverage.make in ('Hyundai', 'Infiniti', 'Lexus', 'Mitsubishi', 'Nissan', 'Subaru', 'Toyota') then 52
      when coverage.make in ('Mercedes-Benz', 'Volkswagen') then 48
      else 52
    end as torque_ft_lb,
    case
      when coverage.make in ('Acura', 'Honda') then 64
      when coverage.make in ('Chevrolet', 'Cadillac', 'Dodge', 'Ford') then 80
      when coverage.make in ('Ferrari', 'Lamborghini', 'McLaren') then 70
      when coverage.make in ('Hyundai', 'Infiniti', 'Lexus', 'Mitsubishi', 'Nissan', 'Subaru', 'Toyota') then 70
      when coverage.make in ('Mercedes-Benz', 'Volkswagen') then 65
      else 70
    end as torque_nm
  from public.torque_fitment_coverage coverage
  where coverage.coverage_status = 'partial'
    and 'suspension' = any(coverage.categories_missing)
    and coverage.torque_generation_id is not null
    and not exists (
      select 1
      from public.torque_specs spec
      join public.torque_categories category
        on category.id = spec.category_id
      where spec.generation_id = coverage.torque_generation_id
        and category.slug = 'suspension'
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
  'Suspension Starter Reference',
  'Stabilizer end link / small suspension bracket fastener',
  targets.torque_ft_lb::numeric,
  targets.torque_nm::numeric,
  null::numeric,
  'Starter coverage row for TorqueHub navigation. Use only as a research placeholder until the exact chassis/model-year suspension service manual is attached.',
  'Suspension fasteners are safety-critical. Do not use this row for repair work without verifying the exact fastener, chassis, model year, and service procedure.',
  'needs_review',
  targets.make || ' suspension service reference',
  null,
  'Fitment-driven starter Suspension coverage for ' || targets.display_name || '. Generic make-family placeholder; replace with exact service-manual fasteners before marking verified.',
  now()
from targets
join public.torque_categories category
  on category.slug = 'suspension';
