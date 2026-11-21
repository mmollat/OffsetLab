-- Offset Lab Fitment
-- Pack 043: verified sixth-generation Ford Bronco factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set year_start = case when model = 'U725 Raptor' then 2022 else 2021 end,
    year_end = 2026
where make = 'Ford' and model in ('U725','U725 Raptor');

-- Combined UI labels cover more than one Ford series. The displayed factory
-- fields use the named default below; the alternatives are retained as
-- separate verified baseline rows with their exact package names.
update public.fitment_presets
set factory_front = '17x7.5 ET55', factory_rear = '17x7.5 ET55',
    factory_tire = '255/75R17 front / 255/75R17 rear',
    bolt_pattern = '6x139.7', center_bore = '93.1mm'
where make = 'Ford' and model = 'U725' and trim = 'Base / Big Bend'
  and active is not false;

update public.fitment_presets
set factory_front = '17x8 ET55', factory_rear = '17x8 ET55',
    factory_tire = '285/70R17 front / 285/70R17 rear',
    bolt_pattern = '6x139.7', center_bore = '93.1mm'
where make = 'Ford' and model = 'U725' and trim = 'Badlands / Wildtrak'
  and active is not false;

update public.fitment_presets
set factory_front = '17x8.5 ET30', factory_rear = '17x8.5 ET30',
    factory_tire = '315/70R17 front / 315/70R17 rear',
    bolt_pattern = '6x139.7', center_bore = '93.1mm'
where make = 'Ford' and model = 'U725' and trim = 'Sasquatch'
  and active is not false;

update public.fitment_presets
set factory_front = '17x8.5 ET34', factory_rear = '17x8.5 ET34',
    factory_tire = '37x12.50R17 front / 37x12.50R17 rear',
    bolt_pattern = '6x135', center_bore = '87.1mm'
where make = 'Ford' and model = 'U725 Raptor' and trim = 'Bronco Raptor'
  and active is not false;

-- OEM+ preserves each factory tire and square layout with a 6 mm outward move.
update public.fitment_presets set
  front = '17x7.5 +49', rear = '17x7.5 +49',
  front_tire = '255/75R17', rear_tire = '255/75R17'
where make = 'Ford' and model = 'U725' and trim = 'Base / Big Bend'
  and style = 'oemplus' and active is not false;

update public.fitment_presets set
  front = '17x8 +49', rear = '17x8 +49',
  front_tire = '285/70R17', rear_tire = '285/70R17'
where make = 'Ford' and model = 'U725' and trim = 'Badlands / Wildtrak'
  and style = 'oemplus' and active is not false;

update public.fitment_presets set
  front = '17x8.5 +24', rear = '17x8.5 +24',
  front_tire = '315/70R17', rear_tire = '315/70R17'
where make = 'Ford' and model = 'U725' and trim = 'Sasquatch'
  and style = 'oemplus' and active is not false;

update public.fitment_presets set
  front = '17x8.5 +28', rear = '17x8.5 +28',
  front_tire = '37x12.50R17', rear_tire = '37x12.50R17'
where make = 'Ford' and model = 'U725 Raptor' and trim = 'Bronco Raptor'
  and style = 'oemplus' and active is not false;

create temp table if not exists ford_bronco_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;
truncate table ford_bronco_verified_baselines;

insert into ford_bronco_verified_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
values
 ('Ford','U725','Base / Big Bend',2021,2026,'Big Bend 17-inch production package','US',true,
  '17x7.5 ET55','17x7.5 ET55','255/75R17 front / 255/75R17 rear','6x139.7','93.1mm','verified',
  'Ford Bronco technical specifications identify the Big Bend 17x7.5 wheel and 255/75R17 Bridgestone Dueler A/T package. Ford body-builder documentation gives ET55; genuine Ford production wheels corroborate 6x139.7 and the 93.1 mm hub with M12x1.5 lug nuts. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/bronco/pdf/21_Bronco_TechSpecs.pdf ; https://fordauthority.com/wp-content/uploads/2021/10/downloadable-2021-Ford-Bronco-installation-guide.pdf'),
 ('Ford','U725','Base / Big Bend',2021,2026,'Base 16-inch production package','US',false,
  '16x7 ET55','16x7 ET55','255/70R16 front / 255/70R16 rear','6x139.7','93.1mm','verified',
  'Ford Bronco technical specifications identify the Base-series 16x7 wheel with 255/70R16 Bridgestone Dueler H/T tires. The standard non-Sasquatch Bronco wheel position is ET55, with 6x139.7, 93.1 mm hardware and M12x1.5 lug nuts. Source: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/bronco/pdf/21_Bronco_TechSpecs.pdf'),
 ('Ford','U725','Badlands / Wildtrak',2021,2026,'Badlands 33-inch production package','US',true,
  '17x8 ET55','17x8 ET55','285/70R17 front / 285/70R17 rear','6x139.7','93.1mm','verified',
  'Ford Bronco technical specifications identify the Badlands 17x8 wheel with 285/70R17 BFGoodrich or Goodyear 33-inch tires. Ford body-builder data establishes ET55 for the non-Sasquatch package; hardware is 6x139.7, 93.1 mm and M12x1.5. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/bronco/pdf/21_Bronco_TechSpecs.pdf ; https://fordauthority.com/wp-content/uploads/2021/10/downloadable-2021-Ford-Bronco-installation-guide.pdf'),
 ('Ford','U725','Badlands / Wildtrak',2021,2026,'Wildtrak Sasquatch 35-inch production package','US',false,
  '17x8.5 ET30','17x8.5 ET30','315/70R17 front / 315/70R17 rear','6x139.7','93.1mm','verified',
  'Ford technical specifications identify Wildtrak with the Sasquatch 17x8.5 beadlock-capable wheel and 315/70R17 Goodyear Territory 35-inch tires. Ford body-builder documentation and genuine M2DZ/N2DZ production wheels specify ET30; hardware is 6x139.7, 93.1 mm and M12x1.5. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/bronco/pdf/21_Bronco_TechSpecs.pdf ; https://fordauthority.com/wp-content/uploads/2021/10/downloadable-2021-Ford-Bronco-installation-guide.pdf'),
 ('Ford','U725','Sasquatch',2021,2026,'Sasquatch 35-inch production package','US',true,
  '17x8.5 ET30','17x8.5 ET30','315/70R17 front / 315/70R17 rear','6x139.7','93.1mm','verified',
  'Ford Bronco technical specifications specify the Sasquatch 17x8.5 beadlock-capable wheel with 315/70R17 Goodyear Territory tires. Ford body-builder documentation and genuine M2DZ/N2DZ wheel listings identify ET30; hardware is 6x139.7, 93.1 mm and M12x1.5. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/bronco/pdf/21_Bronco_TechSpecs.pdf ; https://wheelworksdetroit.com/17x8-5-ford-bronco-m2dz1007a-m2dz1007b-n2dz1007c-n2dz1007d/'),
 ('Ford','U725 Raptor','Bronco Raptor',2022,2026,'Bronco Raptor 37-inch production package','US',true,
  '17x8.5 ET34','17x8.5 ET34','37x12.50R17 front / 37x12.50R17 rear','6x135','87.1mm','verified',
  'Ford Bronco Raptor technical specifications identify 17-inch production wheels with standard 37x12.50R17 BFGoodrich all-terrain tires. Genuine Ford NB3Z-1007 Raptor wheels document 17x8.5 ET34, 6x135 and 87.1 mm hardware with M14x1.5 lug nuts. Sources: https://www.ford.com/cmslibs/content/dam/brand_ford/en_us/brand/suvs/bronco/2021/pdf/2022-Ford-Bronco-Raptor-Tech-Specs.pdf ; https://www.wheelsmartrims.com/17-ford-bronco-oem-rim-466/');

delete from public.fitment_factory_baselines existing
where existing.make = 'Ford'
  and existing.model in ('U725','U725 Raptor');

insert into public.fitment_factory_baselines (
 make,model,trim,year_start,year_end,package_name,market,is_default,
 front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
select make,model,trim,year_start,year_end,package_name,market,is_default,
 front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from ford_bronco_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
 bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make = 'Ford' and model in ('U725','U725 Raptor') and active
order by model,trim,is_default desc,package_name;
