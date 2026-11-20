-- Offset Lab Fitment
-- Pack 023: verified US-market Hyundai N factory baselines.
--
-- Plain SQL only. Safe to re-run.

update public.vehicle_models set year_start = 2022, year_end = null
where make = 'Hyundai' and model = 'CN7';

update public.vehicle_models set year_start = 2019, year_end = 2022
where make = 'Hyundai' and model = 'JS';

update public.vehicle_models set year_start = 2025, year_end = null
where make = 'Hyundai' and model = 'NE';

update public.fitment_presets
set
  bolt_pattern = '5x114.3',
  center_bore = '67.1mm',
  factory_front = case
    when model = 'CN7' then '19x8 ET55'
    when model = 'JS' then '19x8 ET55'
    when model = 'NE' then '21x9.5 ET45'
  end,
  factory_rear = case
    when model = 'CN7' then '19x8 ET55'
    when model = 'JS' then '19x8 ET55'
    when model = 'NE' then '21x9.5 ET45'
  end,
  factory_tire = case
    when model = 'CN7' then '245/35R19'
    when model = 'JS' then '235/35R19'
    when model = 'NE' then '275/35R21'
  end
where make = 'Hyundai'
  and ((model = 'CN7' and trim = 'Elantra N')
    or (model = 'JS' and trim = 'Veloster N')
    or (model = 'NE' and trim = 'Ioniq 5 N'))
  and active is not false;

create temp table if not exists hyundai_n_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table hyundai_n_verified_baselines;

insert into hyundai_n_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Hyundai', 'CN7', 'Elantra N', 2022, null,
    'N 19-inch factory package', 'US', true,
    '19x8 ET55', '19x8 ET55',
    '245/35R19 front / 245/35R19 rear',
    '5x114.3', '67.1mm', 'verified',
    'Hyundai Motor America Elantra N specifications list 19-inch wheels with 245/35R19 high-performance tires. Genuine wheel 52910-IB000/IB100 replacement records specify 19x8 ET55, 5x114.3, and 67.1 mm; fasteners are M12x1.5. Sources: https://www.hyundainews.com/releases/3367 ; https://www.hyundaipartsdeal.com/genuine/hyundai-wheel-assy-aluminium~52910-ib000.html ; https://www.finishlinewheels.com/collections/oem-hyundai-elantra-wheels'
  ),
  (
    'Hyundai', 'JS', 'Veloster N', 2019, 2022,
    'Performance Package 19-inch factory setup', 'US', true,
    '19x8 ET55', '19x8 ET55',
    '235/35R19 front / 235/35R19 rear',
    '5x114.3', '67.1mm', 'verified',
    'Hyundai Motor America documentation identifies the Veloster N Performance Package, standard from 2021, and its 19-inch wheel with 235/35R19 performance tire. Hyundai homologation document identifies OE wheel 52910-S0200 as 8Jx19 ET55; JS hardware is 5x114.3, 67.1 mm, M12x1.5. Sources: https://www.hyundainews.com/releases/3096 ; https://www.hyundainews.com/assets/documents/original/48076-2022MYVelosterNDealerPriceSheet27Aug2021.pdf ; https://www.h-r.com/bin/182XT0021.pdf'
  ),
  (
    'Hyundai', 'NE', 'Ioniq 5 N', 2025, null,
    'N 21-inch forged factory setup', 'US', true,
    '21x9.5 ET45', '21x9.5 ET45',
    '275/35R21 front / 275/35R21 rear',
    '5x114.3', '67.1mm', 'verified',
    'Hyundai Motor America technical specifications publish the IONIQ 5 N forged 9.5Jx21 wheel, 45 mm offset, and Pirelli P Zero 275/35R21 103Y XL tire. Genuine US wheel is 52905-NI100; NE hardware is 5x114.3, 67.1 mm, M14x1.5. Sources: https://www.hyundainews.com/assets/documents/original/64632-2025MYIONIQ5NPriceSheet20Dec2024.pdf ; https://device.report/m/bcae43e32fdc2e71c721b7d4792682a21d42797d13ac4ce317b84bae56f87cb4.pdf ; https://oemwheelexperts.com/catalog/2025-2026-hyundai-21x95-wheel-rim-52905ni100-oem-factory.php'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Hyundai'
  and existing.model in ('CN7', 'JS', 'NE')
  and existing.source_status = 'needs_review';

update public.fitment_factory_baselines existing
set year_start = source.year_start, year_end = source.year_end,
  front = source.front, rear = source.rear, tire = source.tire,
  bolt_pattern = source.bolt_pattern, center_bore = source.center_bore,
  source_status = source.source_status, source_note = source.source_note,
  is_default = source.is_default, active = true, updated_at = now()
from hyundai_n_verified_baselines source
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
from hyundai_n_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines existing
  where existing.make = source.make and existing.model = source.model
    and existing.trim = source.trim and existing.market = source.market
    and existing.package_name = source.package_name
);

select model, trim, year_start, year_end, front, tire, bolt_pattern,
  center_bore, source_status
from public.fitment_factory_baselines
where make = 'Hyundai' and model in ('CN7', 'JS', 'NE') and active
order by model;
