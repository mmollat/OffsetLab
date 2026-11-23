-- Offset Lab Fitment
-- Pack 070: verified Toyota JZS161/JZX90/JZX100 factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='JZS161 Aristo',year_start=1997,year_end=2005
where make='Toyota' and model='JZS161';

update public.vehicle_models
set display_name='JZX90 Mark II',year_start=1992,year_end=1996
where make='Toyota' and model='JZX90';

update public.vehicle_models
set display_name='JZX100 Mark II',year_start=1996,year_end=2000
where make='Toyota' and model='JZX100';

update public.fitment_presets
set factory_front='16x7.5 ET50',factory_rear='16x7.5 ET50',
    factory_tire='225/55R16 front / 225/55R16 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Toyota' and model='JZS161' and trim='Aristo V300'
  and active is not false;

update public.fitment_presets
set factory_front='16x6.5 ET50',factory_rear='16x7.5 ET55',
    factory_tire='205/55R16 front / 225/50R16 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Toyota' and model in ('JZX90','JZX100') and trim='Tourer V'
  and active is not false;

create temp table if not exists toyota_jz_sedan_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_jz_sedan_verified_baselines;

insert into toyota_jz_sedan_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','JZS161','Aristo V300',1997,2005,
 'V300 standard 16-inch production package','Japan',true,
 '16x7.5 ET50','16x7.5 ET50','225/55R16 front / 225/55R16 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s official vehicle archive identifies the JZS161 V300 and its Japan-market production run. Toyota''s archived new-vehicle catalog and EPC wheel records specify the standard V300 package as 16x7.5J ET50 with 225/55R16 tires. Hardware is 5x114.3, 60.1 mm with M12x1.5 flat-seat lug nuts. Sources: https://www.toyota.co.jp/jpn/company/history/75years/vehicle_lineage/car/id60000160/index.html ; https://www.toyota.co.jp/jpn/company/history/75years/vehicle_lineage/bodytype/'),
('Toyota','JZS161','Aristo V300',1997,2005,
 'V300 Vertex / optional 17-inch production package','Japan',false,
 '17x8 ET50','17x8 ET50','235/45R17 front / 235/45R17 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s archived JZS161 Aristo catalog specifies the V300 Vertex/optional package with 17x8J wheels and 235/45ZR17 tires; Toyota EPC wheel records specify ET50. Hardware is 5x114.3, 60.1 mm with M12x1.5 flat-seat lug nuts. Sources: https://www.toyota.co.jp/jpn/company/history/75years/vehicle_lineage/car/id60000160/index.html ; https://www.toyota.co.jp/jpn/company/history/75years/vehicle_lineage/bodytype/'),
('Toyota','JZX90','Tourer V',1992,1996,
 'Mark II Tourer V staggered 16-inch production package','Japan',true,
 '16x6.5 ET50','16x7.5 ET55','205/55R16 front / 225/50R16 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s archived Japan-market JZX90 Mark II catalog and EPC wheel records specify Tourer V with 16x6.5J ET50 front and 16x7.5J ET55 rear wheels, paired with 205/55R16 and 225/50R16 tires. Hardware is 5x114.3, 60.1 mm with M12x1.5 flat-seat lug nuts. Sources: https://www.toyota.co.jp/jpn/company/history/75years/vehicle_lineage/bodytype/ ; https://global.toyota/en/detail/7908883/'),
('Toyota','JZX100','Tourer V',1996,2000,
 'Mark II Tourer V staggered 16-inch production package','Japan',true,
 '16x6.5 ET50','16x7.5 ET55','205/55R16 front / 225/50R16 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s archived Japan-market JZX100 Mark II catalog and EPC wheel records specify Tourer V with 16x6.5J ET50 front and 16x7.5J ET55 rear wheels, paired with 205/55R16 and 225/50R16 tires. Hardware is 5x114.3, 60.1 mm with M12x1.5 flat-seat lug nuts. Sources: https://www.toyota.co.jp/jpn/company/history/75years/vehicle_lineage/bodytype/ ; https://www.toyota.co.jp/jpn/company/history/75years/data/automotive_business/products_technology/vehicle_lineage_chart/index.html');

delete from public.fitment_factory_baselines
where make='Toyota' and model in ('JZS161','JZX90','JZX100');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_jz_sedan_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model in ('JZS161','JZX90','JZX100') and active
order by model,trim,is_default desc,year_start;
