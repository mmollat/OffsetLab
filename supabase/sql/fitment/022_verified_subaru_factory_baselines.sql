-- Offset Lab Fitment
-- Pack 022: verified US-market Subaru VA WRX/STI and ZD8 BRZ baselines.
--
-- Plain SQL only. Safe to re-run.
-- Package and model-year alternatives are retained instead of blending
-- multiple factory configurations into a single false baseline.

update public.vehicle_models
set year_start = 2015, year_end = 2021
where make = 'Subaru' and model = 'VA';

update public.vehicle_models
set year_start = 2022, year_end = null
where make = 'Subaru' and model = 'ZD8';

update public.fitment_presets
set
  bolt_pattern = case when model = 'ZD8' then '5x100' else '5x114.3' end,
  center_bore = '56.1mm',
  factory_front = case
    when model = 'VA' and trim = 'WRX' then '18x8.5 ET55'
    when model = 'VA' and trim = 'STI' then '19x8.5 ET55'
    when model = 'ZD8' and trim = 'BRZ' then '18x7.5 ET48'
  end,
  factory_rear = case
    when model = 'VA' and trim = 'WRX' then '18x8.5 ET55'
    when model = 'VA' and trim = 'STI' then '19x8.5 ET55'
    when model = 'ZD8' and trim = 'BRZ' then '18x7.5 ET48'
  end,
  factory_tire = case
    when model = 'VA' and trim = 'WRX' then '245/40R18'
    when model = 'VA' and trim = 'STI' then '245/35R19'
    when model = 'ZD8' and trim = 'BRZ' then '215/40R18'
  end
where make = 'Subaru'
  and ((model = 'VA' and trim in ('WRX', 'STI'))
    or (model = 'ZD8' and trim = 'BRZ'))
  and active is not false;

create temp table if not exists subaru_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table subaru_verified_baselines;

insert into subaru_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Subaru', 'VA', 'WRX', 2015, 2021,
    'Premium/Limited 18-inch factory package', 'US', true,
    '18x8.5 ET55', '18x8.5 ET55',
    '245/40R18 front / 245/40R18 rear',
    '5x114.3', '56.1mm', 'verified',
    'Subaru of America 2021 WRX brochure lists the WRX Premium/Limited 18x8.5 wheel with 245/40R18 tires. OEM wheel catalogs and wheel markings specify ET55; VA hardware is 5x114.3, 56.1 mm, and M12x1.25. Sources: https://www.subaru.com/content/dam/subaru/downloads/pdf/brochures/2021/wrx/2021_WRX_Brochure.pdf ; https://www.subaru.com/owners/vehicle-resources.html?model=2017-WRX-HUQ ; https://wheel-it-fit.com/cars/subaru-wrx-sti-va-gen1/'
  ),
  (
    'Subaru', 'VA', 'WRX', 2015, 2021,
    'Base 17-inch factory package', 'US', false,
    '17x8 ET55', '17x8 ET55',
    '235/45R17 front / 235/45R17 rear',
    '5x114.3', '56.1mm', 'verified',
    'Subaru of America 2021 WRX brochure lists the base WRX 17x8 wheel with 235/45R17 tires. OEM fitment records specify ET55; VA hardware is 5x114.3, 56.1 mm, and M12x1.25. Sources: https://www.subaru.com/content/dam/subaru/downloads/pdf/brochures/2021/wrx/2021_WRX_Brochure.pdf ; https://wheel-it-fit.com/cars/subaru-wrx-sti-va-gen1/'
  ),
  (
    'Subaru', 'VA', 'STI', 2018, 2021,
    'Facelift 19-inch factory package', 'US', true,
    '19x8.5 ET55', '19x8.5 ET55',
    '245/35R19 front / 245/35R19 rear',
    '5x114.3', '56.1mm', 'verified',
    'Subaru of America 2021 WRX/STI brochure lists STI and STI Limited 19x8.5 wheels with 245/35R19 tires. OEM wheel markings and catalogs specify ET55; VA hardware is 5x114.3, 56.1 mm, and M12x1.25. Sources: https://www.subaru.com/content/dam/subaru/downloads/pdf/brochures/2021/wrx/2021_WRX_Brochure.pdf ; https://www.subaru.com/owners/vehicle-resources.html?model=2018-WRX-JUS ; https://fmbwheels.com/subaru-wrx-sti-va-2015-2021-wheel-fitment-guide/'
  ),
  (
    'Subaru', 'VA', 'STI', 2015, 2017,
    'Pre-facelift 18-inch factory package', 'US', false,
    '18x8.5 ET55', '18x8.5 ET55',
    '245/40R18 front / 245/40R18 rear',
    '5x114.3', '56.1mm', 'verified',
    'Subaru owner documentation and the OEM wheel catalog specify the 2015-2017 STI 18x8.5 wheel, 245/40R18 tire, and ET55. VA hardware is 5x114.3, 56.1 mm, and M12x1.25. Sources: https://fmbwheels.com/subaru-wrx-sti-va-2015-2021-wheel-fitment-guide/ ; https://sizemywheels.com/pcd/subaru-wrx-sti/25t-va/2016'
  ),
  (
    'Subaru', 'ZD8', 'BRZ', 2022, null,
    'Limited/tS 18-inch factory package', 'US', true,
    '18x7.5 ET48', '18x7.5 ET48',
    '215/40R18 front / 215/40R18 rear',
    '5x100', '56.1mm', 'verified',
    'Subaru of America trim specifications list the BRZ Limited/tS 18x7.5 wheel with 215/40R18 tires. Subaru Tecnica International catalog ST28100MF250 specifies 18x7.5J ET48 and 5x100; ZD8 uses a 56.1 mm hub and M12x1.25 fasteners. Sources: https://www.subaru.com/services/vehicles/pdf/trimComparison/2024/BRZ ; https://www.sti.jp/en/parts/catalog/subarubrz_zd'
  ),
  (
    'Subaru', 'ZD8', 'BRZ', 2022, null,
    'Premium 17-inch factory package', 'US', false,
    '17x7.5 ET48', '17x7.5 ET48',
    '215/45R17 front / 215/45R17 rear',
    '5x100', '56.1mm', 'verified',
    'Subaru of America trim specifications list the BRZ Premium 17x7.5 wheel with 215/45R17 tires. OEM matching catalogs specify ET48 and 5x100; ZD8 uses a 56.1 mm hub and M12x1.25 fasteners. Sources: https://www.subaru.com/services/vehicles/pdf/trimComparison/2024/BRZ ; https://www.rd-tanabe.com/ssr/_include/pdf/2023WheelMatching_SUBARU_1.pdf'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Subaru'
  and existing.model in ('VA', 'ZD8')
  and existing.source_status = 'needs_review';

update public.fitment_factory_baselines existing
set year_start = source.year_start, year_end = source.year_end,
  front = source.front, rear = source.rear, tire = source.tire,
  bolt_pattern = source.bolt_pattern, center_bore = source.center_bore,
  source_status = source.source_status, source_note = source.source_note,
  is_default = source.is_default, active = true, updated_at = now()
from subaru_verified_baselines source
where existing.make = source.make and existing.model = source.model
  and existing.trim = source.trim and existing.market = source.market
  and existing.package_name = source.package_name;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from subaru_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines existing
  where existing.make = source.make and existing.model = source.model
    and existing.trim = source.trim and existing.market = source.market
    and existing.package_name = source.package_name
);

select model, trim, year_start, year_end, package_name, is_default, front,
  tire, source_status
from public.fitment_factory_baselines
where make = 'Subaru' and active
order by model, trim, is_default desc, year_start;
