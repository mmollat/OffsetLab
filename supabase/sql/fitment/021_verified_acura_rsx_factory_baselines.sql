-- Offset Lab Fitment
-- Pack 021: verified US-market Acura RSX factory baselines by model year.
--
-- Plain SQL only. Safe to re-run.
-- The Type-S changed from 16 inches (2002-2004) to 17 inches (2005-2006),
-- so both factory packages are retained and the final-year package is the
-- default shown on the non-year-specific fitment page.

update public.fitment_presets
set
  bolt_pattern = '5x114.3',
  center_bore = '64.1mm',
  factory_front = case trim
    when 'RSX Base' then '16x6.5 ET45'
    when 'RSX Type S' then '17x7 ET45'
  end,
  factory_rear = case trim
    when 'RSX Base' then '16x6.5 ET45'
    when 'RSX Type S' then '17x7 ET45'
  end,
  factory_tire = case trim
    when 'RSX Base' then '205/55R16'
    when 'RSX Type S' then '215/45R17'
  end
where make = 'Acura'
  and model = 'DC5'
  and trim in ('RSX Base', 'RSX Type S')
  and active is not false;

create temp table if not exists acura_rsx_verified_baselines (
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

truncate table acura_rsx_verified_baselines;

insert into acura_rsx_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Acura', 'DC5', 'RSX Base', 2002, 2006,
    'Base 16-inch factory package', 'US', true,
    '16x6.5 ET45', '16x6.5 ET45',
    '205/55R16 front / 205/55R16 rear',
    '5x114.3', '64.1mm', 'verified',
    'Acura owner-manual wheel specifications and the 2002 MVMA vehicle technical sheet specify the 16x6.5J wheel, P205/55R16 tire, ET45 offset, 5x114.3 attachment, and M12x1.5 hardware. The DC5 hub is 64.1 mm. Sources: https://techinfo.honda.com/rjanisis/pubs/OM/AH/BRS0404OM/enu/RS0404OM.pdf ; https://crbscca.com/uploadedFiles/mvmaVTS/Acura_Integra_2002_17.PDF'
  ),
  (
    'Acura', 'DC5', 'RSX Type S', 2005, 2006,
    'Type-S 17-inch facelift factory package', 'US', true,
    '17x7 ET45', '17x7 ET45',
    '215/45R17 front / 215/45R17 rear',
    '5x114.3', '64.1mm', 'verified',
    'Acura 2005 chassis documentation and owner manual specify the Type-S 17x7J wheel with 215/45R17 tires. Genuine Enkei wheel 42700-S6M-A82/A83 replacement records specify ET45; DC5 uses 5x114.3, M12x1.5, and a 64.1 mm hub. Sources: https://acuranews.com/en-US/releases/release-cf65b2cae93bb406a2e0ea004c34c389-2005-acura-rsx-chassis ; https://techinfo.honda.com/rjanisis/pubs/OM/AH/BRS0505OM/enu/RS0505OM.pdf ; https://www.acurapartswarehouse.com/parts-list/2005-acura-rsx--3dr_type_s-ka6mt/chassis/wheel.html ; https://allusedrims.com/collections/2005-acura-rsx-wheels/products/afwrac511417u20-0049-acura-wheels'
  ),
  (
    'Acura', 'DC5', 'RSX Type S', 2002, 2004,
    'Type-S 16-inch pre-facelift factory package', 'US', false,
    '16x6.5 ET45', '16x6.5 ET45',
    '205/55R16 front / 205/55R16 rear',
    '5x114.3', '64.1mm', 'verified',
    'The 2002 MVMA vehicle technical sheet specifies P205/55R16 tires on 16x6.5JJ wheels at ET45 with 5x114.3 and M12x1.5 hardware; the 2004 Acura owner manual retains the 16x6.5J package. Sources: https://crbscca.com/uploadedFiles/mvmaVTS/Acura_Integra_2002_17.PDF ; https://techinfo.honda.com/rjanisis/pubs/OM/AH/BRS0404OM/enu/RS0404OM.pdf'
  );

-- Remove the former OEM+-derived review rows so each package has one
-- authoritative baseline row after this pack is applied.
delete from public.fitment_factory_baselines existing
where existing.make = 'Acura'
  and existing.model = 'DC5'
  and existing.trim in ('RSX Base', 'RSX Type S')
  and existing.source_status = 'needs_review';

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
  is_default = source.is_default,
  active = true,
  updated_at = now()
from acura_rsx_verified_baselines source
where existing.make = source.make
  and existing.model = source.model
  and existing.trim = source.trim
  and existing.market = source.market
  and existing.package_name = source.package_name;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  source.make, source.model, source.trim, source.year_start, source.year_end,
  source.package_name, source.market, source.is_default, source.front,
  source.rear, source.tire, source.bolt_pattern, source.center_bore,
  source.source_status, source.source_note
from acura_rsx_verified_baselines source
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = source.make
    and existing.model = source.model
    and existing.trim = source.trim
    and existing.market = source.market
    and existing.package_name = source.package_name
);

select trim, year_start, year_end, package_name, is_default, front, tire,
  source_status
from public.fitment_factory_baselines
where make = 'Acura'
  and model = 'DC5'
  and trim in ('RSX Base', 'RSX Type S')
  and active
order by trim, year_start;
