-- Offset Lab Fitment
-- Pack 039: verified US-market Gen V Dodge Viper ACR baseline.
--
-- Plain SQL only. Safe to re-run. This replaces the intentionally suppressed
-- legacy GTS fallback with the ACR's distinct factory 19-inch front package.

update public.vehicle_models
set year_start = 2013, year_end = 2017
where make = 'Dodge' and model = 'VX';

update public.fitment_presets
set factory_front = '19x11 ET42.5',
    factory_rear = '19x13 ET71.1',
    factory_tire = '295/25R19 front / 355/30R19 rear',
    bolt_pattern = '6x114.3',
    center_bore = '71.5mm'
where make = 'Dodge' and model = 'VX' and trim = 'Viper ACR'
  and active is not false;

-- OEM+ keeps the ACR's factory diameters, widths, and tire package while
-- moving each wheel roughly 6 mm outward. It is deliberately distinct from
-- both the factory baseline and the more aggressive presets.
update public.fitment_presets
set front = '19x11 +37', rear = '19x13 +65',
    front_tire = '295/25R19', rear_tire = '355/30R19'
where make = 'Dodge' and model = 'VX' and trim = 'Viper ACR'
  and style = 'oemplus' and active is not false;

create temp table if not exists dodge_viper_acr_verified_baseline (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table dodge_viper_acr_verified_baseline;

insert into dodge_viper_acr_verified_baseline (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values (
  'Dodge', 'VX', 'Viper ACR', 2016, 2017,
  '19-inch ACR standard package', 'US', true,
  '19x11 ET42.5', '19x13 ET71.1',
  '295/25R19 front / 355/30R19 rear', '6x114.3', '71.5mm', 'verified',
  'FCA/Dodge 2016 Viper specifications and feature-availability sheets identify the ACR standard forged package as 19x11 front and 19x13 rear with 295/25R19 and 355/30R19 Kumho Ecsta V720 tires. Genuine Mopar ACR wheel markings identify the production offsets as 42.5 mm front and 71.1 mm rear. Gen V hardware is 6x114.3 with a 71.5 mm center bore and 1/2-20 wheel nuts; the Dodge owner manual specifies 107 ft-lb/145 Nm torque. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/attachments/2016_Dodge_Viper_Specs8p8494relih5em1i7jbcj7sinc.pdf ; https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/attachments/2016_Dodge_Viper_Features9rgu4obs3j99st8pmnohq94mqe.pdf ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2016/Viper/4407.pdf ; https://store.mopar.com/v-2016-dodge-viper--acr--8-4l-v10-gas/wheels--wheels-tires-and-hardware ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2016/Viper/72.pdf'
);

delete from public.fitment_factory_baselines existing
where existing.make = 'Dodge' and existing.model = 'VX'
  and existing.trim = 'Viper ACR';

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from dodge_viper_acr_verified_baseline;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Dodge' and model = 'VX' and trim = 'Viper ACR' and active
order by is_default desc, year_start desc;
