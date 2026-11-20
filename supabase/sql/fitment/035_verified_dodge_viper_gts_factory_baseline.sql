-- Offset Lab Fitment
-- Pack 035: verified US-market Gen V Dodge Viper GTS baseline.
--
-- Plain SQL only. Safe to re-run.
-- The ACR has a distinct 19x11 front wheel, but the accessible Mopar feature
-- sheet does not publish its offset. Clear the old unverified fallback rather
-- than displaying it as factory data.

update public.vehicle_models
set year_start = 2013, year_end = 2017
where make = 'Dodge' and model = 'VX';

update public.fitment_presets
set factory_front = '18x10.5 ET42.5',
    factory_rear = '19x13 ET71.1',
    factory_tire = '295/30R18 front / 355/30R19 rear',
    bolt_pattern = '6x114.3',
    center_bore = '71.5mm'
where make = 'Dodge' and model = 'VX' and trim = 'Viper GTS'
  and active is not false;

-- Correct Gen V hardware and suppress the old 18x10 +50 / 19x13 +68 fallback
-- on ACR. Its verified factory front is 19x11, not the prior displayed wheel.
update public.fitment_presets
set factory_front = null,
    factory_rear = null,
    factory_tire = null,
    bolt_pattern = '6x114.3',
    center_bore = '71.5mm'
where make = 'Dodge' and model = 'VX' and trim = 'Viper ACR'
  and active is not false;

-- GTS OEM+ retains the original tire diameters and widths while moving the
-- verified factory wheels 5.5/6.1 mm outward.
update public.fitment_presets
set front = '18x10.5 +37', rear = '19x13 +65',
    front_tire = '295/30R18', rear_tire = '355/30R19'
where make = 'Dodge' and model = 'VX' and trim = 'Viper GTS'
  and style = 'oemplus' and active is not false;

create temp table if not exists dodge_viper_gts_verified_baseline (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table dodge_viper_gts_verified_baseline;

insert into dodge_viper_gts_verified_baseline (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values (
  'Dodge', 'VX', 'Viper GTS', 2013, 2017,
  '18/19-inch GTS standard package', 'US', true,
  '18x10.5 ET42.5', '19x13 ET71.1',
  '295/30R18 front / 355/30R19 rear', '6x114.3', '71.5mm', 'verified',
  'FCA/Dodge Viper specifications identify 18x10.5 front and 19x13 rear forged wheels with 295/30ZR18 and 355/30ZR19 tires for the Gen V GTS. Mopar''s factory accessories data book specifies the GTS production-equivalent offsets: 42.5 mm front and 71.1 mm rear. Gen V hardware is 6x114.3 with 71.5 mm center bore and 1/2-20 wheel nuts; the Dodge owner manual specifies 107 ft-lb/145 Nm torque. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2017_DG_Viper_SPfla4qp9pu01chim5ofhl9bmqdd.pdf ; https://wk2jeeps.knoxgeex.com/pdf/2015_Mopar_Accessories_May_2015.pdf ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2017/Viper/1955.pdf'
);

delete from public.fitment_factory_baselines existing
where existing.make = 'Dodge' and existing.model = 'VX'
  and existing.trim in ('Viper GTS', 'Viper ACR');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from dodge_viper_gts_verified_baseline;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Dodge' and model = 'VX' and active
order by trim, is_default desc, year_start desc;
