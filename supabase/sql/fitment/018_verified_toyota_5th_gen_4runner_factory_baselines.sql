-- Offset Lab Fitment
-- Pack 018: verified Toyota 5th-generation 4Runner factory wheel baselines.
--
-- Plain SQL only. Safe to re-run.
-- Sources:
-- - Toyota 2024 4Runner eBrochure (grade-specific wheel diameters and tires)
-- - Toyota Genuine Parts TRD Pro service wheel listing (17x7J ET4, 106 mm hub)
-- - Toyota EPC wheel listings (SR5, TRD Off-Road, and Limited wheel widths/offsets)

update public.vehicle_models
set
  display_name = '5th Gen 4Runner',
  year_start = 2010,
  year_end = 2024
where make = 'Toyota'
  and model = '5th Gen';

-- The old combined choice cannot represent both the SR5 17-inch package and
-- the Limited-exclusive 20-inch package accurately.
update public.vehicle_trims
set active = false
where make = 'Toyota'
  and model = '5th Gen'
  and trim = 'SR5 / Limited';

insert into public.vehicle_trims (make, model, trim, display_name, active, sort_order)
select 'Toyota', '5th Gen', source.trim, source.display_name, true, source.sort_order
from (
  values
    ('SR5', 'SR5 / SR5 Premium', 1400),
    ('Limited', 'Limited', 1401)
) as source(trim, display_name, sort_order)
where not exists (
  select 1
  from public.vehicle_trims existing
  where existing.make = 'Toyota'
    and existing.model = '5th Gen'
    and existing.trim = source.trim
);

update public.vehicle_trims
set active = true
where make = 'Toyota'
  and model = '5th Gen'
  and trim in ('SR5', 'Limited');

update public.vehicle_trims
set sort_order = case trim
  when 'SR5' then 1400
  when 'Limited' then 1401
  when 'TRD Off-Road' then 1402
  when 'TRD Pro' then 1403
  else sort_order
end
where make = 'Toyota'
  and model = '5th Gen';

-- Clone the existing aftermarket recommendations. Factory references are
-- applied separately below, so this does not reinterpret OEM+ as stock.
insert into public.fitment_presets (
  make, model, trim, style, title, subtitle, front, rear, front_tire, rear_tire,
  poke_front, poke_rear, inner_front, inner_rear, diameter, aggression, daily,
  risk, verdict, warnings, alternate, active, sort_order, bolt_pattern,
  center_bore, factory_front, factory_rear, factory_tire
)
select
  source.make, source.model, target.trim, source.style, source.title,
  source.subtitle, source.front, source.rear, source.front_tire,
  source.rear_tire, source.poke_front, source.poke_rear, source.inner_front,
  source.inner_rear, source.diameter, source.aggression, source.daily,
  source.risk, source.verdict, source.warnings, source.alternate, true,
  source.sort_order, '6x139.7', '106mm',
  case target.trim when 'SR5' then '17x7 ET15' else '20x7 ET15' end,
  case target.trim when 'SR5' then '17x7 ET15' else '20x7 ET15' end,
  case target.trim when 'SR5' then '265/70R17' else '245/60R20' end
from public.fitment_presets source
cross join (values ('SR5'), ('Limited')) as target(trim)
where source.make = 'Toyota'
  and source.model = '5th Gen'
  and source.trim = 'SR5 / Limited'
  and source.active is not false
  and not exists (
    select 1
    from public.fitment_presets existing
    where existing.make = source.make
      and existing.model = source.model
      and existing.trim = target.trim
      and existing.style = source.style
  );

update public.fitment_presets
set active = false
where make = 'Toyota'
  and model = '5th Gen'
  and trim = 'SR5 / Limited';

update public.fitment_presets
set
  bolt_pattern = '6x139.7',
  center_bore = '106mm',
  factory_front = case trim
    when 'SR5' then '17x7 ET15'
    when 'Limited' then '20x7 ET15'
    when 'TRD Off-Road' then '17x7.5 ET15'
    when 'TRD Pro' then '17x7 ET4'
  end,
  factory_rear = case trim
    when 'SR5' then '17x7 ET15'
    when 'Limited' then '20x7 ET15'
    when 'TRD Off-Road' then '17x7.5 ET15'
    when 'TRD Pro' then '17x7 ET4'
  end,
  factory_tire = case trim
    when 'Limited' then '245/60R20'
    else '265/70R17'
  end
where make = 'Toyota'
  and model = '5th Gen'
  and trim in ('SR5', 'Limited', 'TRD Off-Road', 'TRD Pro')
  and active is not false;

create temp table if not exists toyota_5th_gen_verified_baselines (
  make text,
  model text,
  trim text,
  year_start int,
  year_end int,
  package_name text,
  market text,
  is_default boolean,
  front text,
  rear text,
  tire text,
  bolt_pattern text,
  center_bore text,
  source_status text,
  source_note text
) on commit drop;

truncate table toyota_5th_gen_verified_baselines;

insert into toyota_5th_gen_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Toyota', '5th Gen', 'SR5', 2010, 2024,
    'SR5 17-inch factory package', 'US', true,
    '17x7 ET15', '17x7 ET15',
    '265/70R17 front / 265/70R17 rear',
    '6x139.7', '106mm', 'verified',
    'Toyota 2024 4Runner eBrochure lists the SR5/SR5 Premium 17-inch 6-spoke wheel with P265/70R17 tires. Wheel width, ET15 offset, 6x139.7 bolt circle, and 106 mm hub were cross-checked against Toyota EPC wheel records for the GRN280/285 5th-generation 4Runner. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/4runner_ebrochure.pdf ; https://toyotaepc.com/toyota/4runner/US/disc-wheel-wheel-cap'
  ),
  (
    'Toyota', '5th Gen', 'Limited', 2010, 2024,
    'Limited 20-inch factory package', 'US', true,
    '20x7 ET15', '20x7 ET15',
    '245/60R20 front / 245/60R20 rear',
    '6x139.7', '106mm', 'verified',
    'Toyota 2019-2024 4Runner publications identify the Limited-exclusive 20-inch wheel with P245/60R20 tires. Wheel width and ET15 offset were cross-checked against Toyota EPC record 42611-35550; the 5th-generation hub uses 6x139.7 and 106 mm. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/4runner_ebrochure.pdf ; https://pressroom.toyota.com/2019-toyota-4runner-strengthens-legacy-35-year/ ; https://toyotaepc.com/toyota/4runner/US/disc-wheel-wheel-cap'
  ),
  (
    'Toyota', '5th Gen', 'TRD Off-Road', 2017, 2024,
    'TRD Off-Road 17-inch factory package', 'US', true,
    '17x7.5 ET15', '17x7.5 ET15',
    '265/70R17 front / 265/70R17 rear',
    '6x139.7', '106mm', 'verified',
    'Toyota 2024 4Runner eBrochure lists the TRD Off-Road/TRD Off-Road Premium 17-inch 7-spoke wheel with P265/70R17 tires. Toyota EPC record 42611-35410 lists 17x7.5J with ET15; hub metadata is 6x139.7 and 106 mm. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/4runner_ebrochure.pdf ; https://cruisin4parts.com/parts/toyota/4runner/catalog/disc-wheel-wheel-cap'
  ),
  (
    'Toyota', '5th Gen', 'TRD Pro', 2015, 2024,
    'TRD Pro 17-inch factory package', 'US', true,
    '17x7 ET4', '17x7 ET4',
    '265/70R17 front / 265/70R17 rear',
    '6x139.7', '106mm', 'verified',
    'Toyota 2024 4Runner eBrochure lists the TRD Pro 17-inch wheel with P265/70R17 A/T tires. Toyota Genuine Parts service replacement PTR56-89210-F2 specifies 17x7J ET4, 6x139.7, and 106 mm hub diameter. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/4runner_ebrochure.pdf ; https://autoparts.toyota.com/products/product/4run-trd-pro-wheel-flat-black-ptr5689210f2'
  );

update public.fitment_factory_baselines existing
set
  year_start = source.year_start,
  year_end = source.year_end,
  front = source.front,
  rear = source.rear,
  tire = source.tire,
  bolt_pattern = source.bolt_pattern,
  center_bore = source.center_bore,
  source_status = source.source_status,
  source_note = source.source_note,
  is_default = true,
  active = true,
  updated_at = now()
from toyota_5th_gen_verified_baselines source
where existing.make = source.make
  and existing.model = source.model
  and existing.trim = source.trim
  and existing.market = source.market
  and coalesce(existing.package_name, 'Default') = source.package_name;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  source.make, source.model, source.trim, source.year_start, source.year_end,
  source.package_name, source.market, source.is_default, source.front,
  source.rear, source.tire, source.bolt_pattern, source.center_bore,
  source.source_status, source.source_note
from toyota_5th_gen_verified_baselines source
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = source.make
    and existing.model = source.model
    and existing.trim = source.trim
    and existing.market = source.market
    and coalesce(existing.package_name, 'Default') = source.package_name
);

select trim, front, rear, tire, source_status
from public.fitment_factory_baselines
where make = 'Toyota'
  and model = '5th Gen'
  and active
  and is_default
order by trim;
