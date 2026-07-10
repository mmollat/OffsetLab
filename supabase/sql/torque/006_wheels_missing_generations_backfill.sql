-- Offset Lab Torque Hub
-- Pack 006: fill Wheels coverage for generations with no wheel specs.
--
-- Plain SQL only. Safe to re-run.
-- Existing Wheels rows are retained and not overwritten.
-- Values are marked needs_review until exact model-year sources are attached.

with targets as (
  select
    generation_row.id as generation_id,
    make_row.name as make,
    generation_row.slug as generation_slug,
    case
      when make_row.name = 'Audi' then 89
      when make_row.name = 'BMW' and generation_row.slug ~ '^(e46|e82|e90|e92)' then 88.5
      when make_row.name = 'BMW' then 103.3
      when make_row.name = 'Chevrolet' and generation_row.slug in ('c5-corvette','c6-corvette','c7-corvette') then 100
      when make_row.name = 'Chevrolet' then 103
      when make_row.name = 'Ford' then 150
      when make_row.name = 'Jeep' and generation_row.slug = 'jk-wrangler' then 95
      when make_row.name = 'Jeep' then 130
      when make_row.name = 'Mazda' then 80
      when make_row.name = 'Mercedes-Benz' then 95
      when make_row.name = 'Porsche' and generation_row.slug ~ '^(997|991-1)' then 96
      when make_row.name = 'Porsche' then 118
      when make_row.name = 'Subaru' then 89
      when make_row.name = 'Tesla' then 129
      when make_row.name = 'Toyota' and generation_row.slug like '%supra%' then 103
      when make_row.name = 'Toyota' and generation_row.slug like '%4runner%' then 80
      when make_row.name = 'Toyota' then 97
      else null
    end as torque_ft_lb,
    case
      when make_row.name = 'Audi' then 120
      when make_row.name = 'BMW' and generation_row.slug ~ '^(e46|e82|e90|e92)' then 120
      when make_row.name = 'BMW' then 140
      when make_row.name = 'Chevrolet' then 140
      when make_row.name = 'Ford' then 203
      when make_row.name = 'Jeep' and generation_row.slug = 'jk-wrangler' then 129
      when make_row.name = 'Jeep' then 176
      when make_row.name = 'Mazda' then 108
      when make_row.name = 'Mercedes-Benz' then 130
      when make_row.name = 'Porsche' and generation_row.slug ~ '^(997|991-1)' then 130
      when make_row.name = 'Porsche' then 160
      when make_row.name = 'Subaru' then 120
      when make_row.name = 'Tesla' then 175
      when make_row.name = 'Toyota' and generation_row.slug like '%supra%' then 140
      when make_row.name = 'Toyota' and generation_row.slug like '%4runner%' then 108
      when make_row.name = 'Toyota' then 131
      else null
    end as torque_nm,
    case
      when make_row.name in ('Audi','BMW','Mercedes-Benz','Porsche') then 'Wheel lug bolts'
      when make_row.name = 'Toyota' and generation_row.slug like '%supra%' then 'Wheel lug bolts'
      else 'Wheel lug nuts'
    end as fastener
  from public.torque_vehicle_generations generation_row
  join public.torque_vehicle_models model_row on model_row.id = generation_row.model_id
  join public.torque_vehicle_makes make_row on make_row.id = model_row.make_id
  where not exists (
    select 1
    from public.torque_specs spec
    join public.torque_categories category on category.id = spec.category_id
    where spec.generation_id = generation_row.id
      and category.slug = 'wheels'
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
  'Wheels',
  targets.fastener,
  targets.torque_ft_lb::numeric,
  targets.torque_nm::numeric,
  null::numeric,
  'Tighten in a criss-cross/star pattern with a calibrated torque wrench. Re-check after wheel service.',
  'Wheel torque varies by model year, wheel type, and fastener style. Verify against the exact owner manual or service manual before using on customer vehicles.',
  'needs_review',
  targets.make || ' wheel torque reference',
  null,
  'Broad wheel torque backfill seeded by make/platform. Attach exact model-year source before marking verified.',
  now()
from targets
join public.torque_categories category on category.slug = 'wheels'
where targets.torque_ft_lb is not null
  and targets.torque_nm is not null
  and not exists (
    select 1
    from public.torque_specs existing
    where existing.generation_id = targets.generation_id
      and existing.category_id = category.id
      and lower(existing.component) = lower('Wheels')
      and lower(existing.fastener) = lower(targets.fastener)
  );
