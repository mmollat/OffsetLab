-- Offset Lab Fitment
-- Pack 038: verified US-market Volkswagen factory baselines.
--
-- Plain SQL only. Safe to re-run. Baselines use Volkswagen workshop
-- wheel-and-tire guides and Volkswagen of America technical specifications.

update public.vehicle_models
set year_start = case model
      when 'MK5' then 2006 when 'MK6' then 2010
      when 'MK7 / MK7.5' then 2015 when 'MK8' then 2022
      when 'A7 Jetta' then 2019 when 'Arteon' then 2019
      when 'CC' then 2009
    end,
    year_end = case model
      when 'MK5' then 2009 when 'MK6' then 2014
      when 'MK7 / MK7.5' then 2021 when 'MK8' then 2026
      when 'A7 Jetta' then 2025 when 'Arteon' then 2023
      when 'CC' then 2017
    end
where make = 'Volkswagen'
  and model in ('MK5','MK6','MK7 / MK7.5','MK8','A7 Jetta','Arteon','CC');

update public.fitment_presets
set factory_front = case trim
      when 'GTI' then '18x7.5 ET51'
      when 'R32' then '18x7.5 ET51'
    end,
    factory_rear = case trim
      when 'GTI' then '18x7.5 ET51'
      when 'R32' then '18x7.5 ET51'
    end,
    factory_tire = '225/40R18 front / 225/40R18 rear',
    bolt_pattern = '5x112', center_bore = '57.1mm'
where make='Volkswagen' and model='MK5'
  and trim in ('GTI','R32') and active is not false;

update public.fitment_presets
set factory_front = '18x7.5 ET51', factory_rear = '18x7.5 ET51',
    factory_tire = '225/40R18 front / 225/40R18 rear',
    bolt_pattern = '5x112', center_bore = '57.1mm'
where make='Volkswagen' and model='MK6'
  and trim in ('GTI','Golf R') and active is not false;

update public.fitment_presets
set factory_front = case trim
      when 'GTI' then '18x7.5 ET49'
      when 'Golf R' then '19x8 ET50'
    end,
    factory_rear = case trim
      when 'GTI' then '18x7.5 ET49'
      when 'Golf R' then '19x8 ET50'
    end,
    factory_tire = case trim
      when 'GTI' then '225/40R18 front / 225/40R18 rear'
      when 'Golf R' then '235/35R19 front / 235/35R19 rear'
    end,
    bolt_pattern = '5x112', center_bore = '57.1mm'
where make='Volkswagen' and model='MK7 / MK7.5'
  and trim in ('GTI','Golf R') and active is not false;

update public.fitment_presets
set factory_front = case trim
      when 'GTI' then '18x7.5 ET51'
      when 'Golf R' then '19x8 ET50'
    end,
    factory_rear = case trim
      when 'GTI' then '18x7.5 ET51'
      when 'Golf R' then '19x8 ET50'
    end,
    factory_tire = case trim
      when 'GTI' then '225/40R18 front / 225/40R18 rear'
      when 'Golf R' then '235/35R19 front / 235/35R19 rear'
    end,
    bolt_pattern = '5x112', center_bore = '57.1mm'
where make='Volkswagen' and model='MK8'
  and trim in ('GTI','Golf R') and active is not false;

update public.fitment_presets
set factory_front = case trim
      when 'Jetta' then '16x6.5 ET46'
      when 'GLI' then '18x7.5 ET49'
    end,
    factory_rear = case trim
      when 'Jetta' then '16x6.5 ET46'
      when 'GLI' then '18x7.5 ET49'
    end,
    factory_tire = case trim
      when 'Jetta' then '205/60R16 front / 205/60R16 rear'
      when 'GLI' then '225/45R18 front / 225/45R18 rear'
    end,
    bolt_pattern = '5x112', center_bore = '57.1mm'
where make='Volkswagen' and model='A7 Jetta'
  and trim in ('Jetta','GLI') and active is not false;

update public.fitment_presets
set factory_front='20x8 ET40', factory_rear='20x8 ET40',
    factory_tire='245/35R20 front / 245/35R20 rear',
    bolt_pattern='5x112', center_bore='57.1mm'
where make='Volkswagen' and model='Arteon'
  and trim='SEL Premium R-Line' and active is not false;

update public.fitment_presets
set factory_front='18x8 ET41', factory_rear='18x8 ET41',
    factory_tire='235/40R18 front / 235/40R18 rear',
    bolt_pattern='5x112', center_bore='57.1mm'
where make='Volkswagen' and model='CC'
  and trim='VR6 / R-Line' and active is not false;

create temp table if not exists volkswagen_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table volkswagen_verified_baselines;

insert into volkswagen_verified_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
values
 ('Volkswagen','MK5','GTI',2006,2009,'18-inch GTI factory package','US',true,
  '18x7.5 ET51','18x7.5 ET51','225/40R18 front / 225/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen Wheels and Tyres Guide identifies the Mk5 GTI genuine 18-inch package as 7.5Jx18 ET51 with 225/40R18 tires. The guide specifies five wheel-bolt holes on a 112 mm pitch circle; platform hardware is a 57.1 mm hub and M14x1.5 ball-seat bolts. Source: https://manuals.plus/m/2c0acfecb5ee34c5948d9eee2162adbbe84db3a416615bc76151fa2ccb6a8a44.pdf'),
 ('Volkswagen','MK5','R32',2008,2008,'18-inch R32 standard package','US',true,
  '18x7.5 ET51','18x7.5 ET51','225/40R18 front / 225/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen Wheels and Tyres Guide lists the R32 standard package as 7.5Jx18 ET51 with 225/40R18 tires and specifies five holes on a 112 mm pitch circle. US-market R32 applicability is model year 2008. Platform hardware is a 57.1 mm hub and M14x1.5 ball-seat bolts. Source: https://manuals.plus/m/2c0acfecb5ee34c5948d9eee2162adbbe84db3a416615bc76151fa2ccb6a8a44.pdf'),
 ('Volkswagen','MK6','GTI',2010,2014,'18-inch GTI factory package','US',true,
  '18x7.5 ET51','18x7.5 ET51','225/40R18 front / 225/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen Wheels and Tyres Guide lists the Mk6 GTI genuine 18-inch package as 7.5Jx18 ET51 with 225/40R18 tires and specifies five holes on a 112 mm pitch circle. Platform hardware is a 57.1 mm hub and M14x1.5 ball-seat bolts. Source: https://manuals.plus/m/7b66ad9600e932d9c373d84419d8db0a75ead9e25603f7fbfdc27ccfaea1d714.pdf'),
 ('Volkswagen','MK6','Golf R',2012,2013,'18-inch Golf R standard package','US',true,
  '18x7.5 ET51','18x7.5 ET51','225/40R18 front / 225/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen Wheels and Tyres Guide lists the Golf R standard package as 7.5Jx18 ET51 with 225/40R18 tires and specifies five holes on a 112 mm pitch circle. Platform hardware is a 57.1 mm hub and M14x1.5 ball-seat bolts. Source: https://manuals.plus/m/7b66ad9600e932d9c373d84419d8db0a75ead9e25603f7fbfdc27ccfaea1d714.pdf'),
 ('Volkswagen','MK7 / MK7.5','GTI',2015,2021,'18-inch GTI standard package','US',true,
  '18x7.5 ET49','18x7.5 ET49','225/40R18 front / 225/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen Golf workshop Wheel and Tire Guide lists the GTI 18-inch package as 7.5Jx18 ET49 with 225/40R18 tires; Volkswagen of America confirms 18-inch wheels and 225/40 tires as standard US GTI equipment. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://documents.cdn.ifixit.com/1HfUxUoBvAuYfUUa.pdf ; https://newspress-vwusamedia.s3.amazonaws.com/documents%2Foriginal%2F8228-2018VolkswagenGolfGTIRelease.pdf'),
 ('Volkswagen','MK7 / MK7.5','Golf R',2015,2019,'19-inch Golf R package','US',true,
  '19x8 ET50','19x8 ET50','235/35R19 front / 235/35R19 rear','5x112','57.1mm','verified',
  'Volkswagen of America technical specifications list the US Golf R 19x8 package with 235/35R19 tires; Volkswagen wheel-allocation data specifies ET50 for the 8Jx19 wheel. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://newspress-vwusamedia.s3.amazonaws.com/documents%2Foriginal%2F8730-2019GolfRTechnicalSpecifications.pdf ; https://documents.cdn.ifixit.com/1HfUxUoBvAuYfUUa.pdf'),
 ('Volkswagen','MK8','GTI',2022,2024,'18-inch GTI standard package','US',true,
  '18x7.5 ET51','18x7.5 ET51','225/40R18 front / 225/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen Mk8 Golf Wheel and Tire Guide specifies 7.5Jx18 ET51 with 225/40R18 tires; the North American buyer guide identifies the corresponding GTI wheel package. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://www.manualslib.com/manual/3006816/Volkswagen-Golf-2020.html ; https://www.volkswagen.de/idhub/content/dam/onehub_pkw/importers/ca/2021/en/showroom/golf-gti-2022/VWC_Digital_BuyersGuide_2022_Golf%20GTI_PDF_EN.pdf'),
 ('Volkswagen','MK8','Golf R',2022,2024,'19-inch Golf R standard package','US',true,
  '19x8 ET50','19x8 ET50','235/35R19 front / 235/35R19 rear','5x112','57.1mm','verified',
  'Volkswagen Mk8 Golf Wheel and Tire Guide assigns the 8Jx19 ET50 Estoril wheel to Golf R; Volkswagen owner information specifies 235/35R19 tires. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://www.manualslib.com/manual/3006816/Volkswagen-Golf-2020.html ; https://carmanuals2.com/volkswagen/golf-r-2022-owner-s-manual-123594'),
 ('Volkswagen','A7 Jetta','Jetta',2019,2024,'16-inch standard Jetta package','US',true,
  '16x6.5 ET46','16x6.5 ET46','205/60R16 front / 205/60R16 rear','5x112','57.1mm','verified',
  'Volkswagen of America technical specifications list the standard A7 Jetta package as 16x6.5 with 205/60R16 tires; Volkswagen wheel-allocation data specifies ET46. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Source: https://newspress-vwusamedia.s3.amazonaws.com/documents%2Foriginal%2F8191-2019JettaTechnicalSpecifications.pdf'),
 ('Volkswagen','A7 Jetta','GLI',2019,2024,'18-inch GLI standard package','US',true,
  '18x7.5 ET49','18x7.5 ET49','225/45R18 front / 225/45R18 rear','5x112','57.1mm','verified',
  'Volkswagen of America identifies 18-inch wheels as standard GLI equipment; Volkswagen wheel-allocation data specifies the factory 7.5Jx18 ET49 wheel with 225/45R18 tires. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Source: https://www.youtube.com/watch?v=bsho962-vS8'),
 ('Volkswagen','Arteon','SEL Premium R-Line',2019,2023,'20-inch Rosario R-Line package','US',true,
  '20x8 ET40','20x8 ET40','245/35R20 front / 245/35R20 rear','5x112','57.1mm','verified',
  'Volkswagen media information and the Arteon Wheel and Tire Guide specify the R-Line 20-inch Rosario package as 8Jx20 ET40 with 245/35R20 tires. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://cdn.uc.assets.prezly.com/b5ad1520-076f-4dce-aed7-bbe938bb2b3c/-/inline/no/EN_Arteon_Drive_2017.pdf ; https://dms.kfz-verlag.de/pub/more_downloads/en-ebook-vw-arteon-3h-0531.pdf'),
 ('Volkswagen','CC','VR6 / R-Line',2012,2017,'18-inch VR6 / R-Line package','US',true,
  '18x8 ET41','18x8 ET41','235/40R18 front / 235/40R18 rear','5x112','57.1mm','verified',
  'Volkswagen of America technical specifications list the CC 18x8 package with 235/40R18 tires; the Volkswagen service-manual wheel allocation specifies ET41 for the Daytona and Mallory factory wheels. Hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://newspress-vwusamedia.s3.amazonaws.com/documents%2Foriginal%2F6247-1422603158536a85ba5b823.pdf ; https://lemon-manuals.la/Volkswagen/2012/CC%20Sport%2C%202.0L%20Eng%20VIN%20N%2C%20Standard%20Trans/Repair%20and%20Diagnosis%20%28Single%20Page%29/Suspension/Wheels%20%26%20Tire%20System/Wheel%20%26%20Tire%20Guide/44%20Wheels%2C%20Tires%2C%20Wheel%20Alignment/Wheel%20Allocation/8%20J%20X%2018/');

delete from public.fitment_factory_baselines
where make='Volkswagen'
  and model in ('MK5','MK6','MK7 / MK7.5','MK8','A7 Jetta','Arteon','CC');

insert into public.fitment_factory_baselines (
 make,model,trim,year_start,year_end,package_name,market,is_default,
 front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
select make,model,trim,year_start,year_end,package_name,market,is_default,
 front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from volkswagen_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
 bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Volkswagen' and active
order by model,trim,year_start desc;
