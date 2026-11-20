-- Offset Lab Fitment
-- Pack 019: verified current-generation Acura Integra factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- The earlier needs-review rows were copied from OEM+ recommendations and
-- must not be treated as factory data. In particular, A-Spec is 18x8 ET50
-- with a 5x114.3 hub, while Type S is 19x9.5 ET60 with a 5x120 hub.

update public.fitment_presets
set
  bolt_pattern = case trim
    when 'Integra A-Spec' then '5x114.3'
    when 'Integra Type S' then '5x120'
  end,
  center_bore = '64.1mm',
  factory_front = case trim
    when 'Integra A-Spec' then '18x8 ET50'
    when 'Integra Type S' then '19x9.5 ET60'
  end,
  factory_rear = case trim
    when 'Integra A-Spec' then '18x8 ET50'
    when 'Integra Type S' then '19x9.5 ET60'
  end,
  factory_tire = case trim
    when 'Integra A-Spec' then '235/40R18'
    when 'Integra Type S' then '265/30ZR19'
  end
where make = 'Acura'
  and model = 'DE4'
  and trim in ('Integra A-Spec', 'Integra Type S')
  and active is not false;

create temp table if not exists acura_integra_verified_baselines (
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

truncate table acura_integra_verified_baselines;

insert into acura_integra_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Acura', 'DE4', 'Integra A-Spec', 2023, null,
    'A-Spec 18-inch factory package', 'US', true,
    '18x8 ET50', '18x8 ET50',
    '235/40R18 front / 235/40R18 rear',
    '5x114.3', '64.1mm', 'verified',
    'Acura 2023-2024 US specifications list the A-Spec factory wheel as 18x8 with 235/40R18 tires. Honda/Acura DreamShop identifies the genuine wheel as part 42700-3S5-A81; OEM replacement records for that part specify ET50, 5x114.3, and a 64.1 mm center bore. Sources: https://www.acura.com/-/media/Files/Vehicles/INTEGRA/2023/acura_2023_integra_fact_sheet.pdf ; https://acuranews.com/en-US/releases/release-13f25e90cfe47cd58453f1f7100e339f-2024-integra-type-s-press-kit ; https://dreamshop.honda.com/s/model-product/a26UT000002e11CYAQ/a26ut000002e11c ; https://www.finishlinewheels.com/collections/acura-integra-genuine-wheels'
  ),
  (
    'Acura', 'DE4', 'Integra Type S', 2024, null,
    'Type S 19-inch factory package', 'US', true,
    '19x9.5 ET60', '19x9.5 ET60',
    '265/30ZR19 front / 265/30ZR19 rear',
    '5x120', '64.1mm', 'verified',
    'Acura US Type S specifications list the factory wheel as 19x9.5 with 265/30ZR19 Michelin Pilot Sport 4 S tires. Genuine wheel 42700-31M-A91 carries the OEM size markings and replacement-wheel records specify ET60; Type S uses the distinct 5x120 / 64.1 mm hub. Sources: https://acuranews.com/en-US/releases/release-13f25e90cfe47cd58453f1f7100e339f-2024-integra-type-s-press-kit ; https://www.acura.com/-/media/Files/Vehicles/INTEGRA/2024/Type-S/Acura_2024_Integra_Fact-Sheet.pdf ; https://www.hubcaphaven.com/p/28729/alyae047u35-acura-integra-type-s-wheel-rim-charcoal-painted-4270031ma91.html'
  );

update public.fitment_factory_baselines existing
set
  year_start = source.year_start,
  year_end = source.year_end,
  package_name = source.package_name,
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
from acura_integra_verified_baselines source
where existing.make = source.make
  and existing.model = source.model
  and existing.trim = source.trim
  and existing.market = source.market
  and existing.is_default = true;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  source.make, source.model, source.trim, source.year_start, source.year_end,
  source.package_name, source.market, source.is_default, source.front,
  source.rear, source.tire, source.bolt_pattern, source.center_bore,
  source.source_status, source.source_note
from acura_integra_verified_baselines source
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = source.make
    and existing.model = source.model
    and existing.trim = source.trim
    and existing.market = source.market
    and existing.is_default = true
);

select trim, front, rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Acura'
  and model = 'DE4'
  and trim in ('Integra A-Spec', 'Integra Type S')
  and active
  and is_default
order by trim;
