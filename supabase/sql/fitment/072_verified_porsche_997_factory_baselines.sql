-- Offset Lab Fitment
-- Pack 072: verified Porsche 997 GT3 and Turbo factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='997 911',year_start=2005,year_end=2012
where make='Porsche' and model='997';

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='19x8.5 ET53',factory_rear='19x12 ET63',
    factory_tire='235/35R19 front / 305/30R19 rear'
where make='Porsche' and model='997' and trim='GT3' and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='19x8.5 ET56',factory_rear='19x11 ET51',
    factory_tire='235/35R19 front / 305/30R19 rear'
where make='Porsche' and model='997' and trim='Turbo' and active is not false;

create temp table if not exists porsche_997_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table porsche_997_verified_baselines;

insert into porsche_997_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Porsche','997','GT3',2010,2011,'997.2 GT3 19-inch production package','US',true,
 '19x8.5 ET53','19x12 ET63','235/35R19 front / 305/30R19 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s official motorsport regulations identify the series-production 997 GT3 wheel package as 19x8.5J ET53 front and 19x12J ET63 rear with 235/35ZR19 and 305/30ZR19 tires. Porsche''s approved-tire documentation confirms the 2010-2011 997 GT3 application. Hardware is center-lock on the 997.2 GT3 production wheel, with a 71.6 mm hub geometry. Sources: https://files.porsche.com/filestore/download/porschesportscup-germany/en/downloads-rules-regulations-2016/default/710a2ffa-676c-11ea-80c8-005056bbdc38/Regulations-Porsche-Sports-Cup-2020-%28available-only-in-German%29.pdf ; https://files.porsche.com/filestore/download/russia/none/porscheservice-tire-currentwintertires/default/30ff94cb-4b7d-11e7-bfe2-0019999cd470/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%B4%D0%BE%D0%BF%D1%83%D1%89%D0%B5%D0%BD%D0%BD%D1%8B%D1%85-%D0%B7%D0%B8%D0%BC%D0%BD%D0%B8%D1%85-%D1%88%D0%B8%D0%BD-%D0%B4%D0%BB%D1%8F-%D0%B0%D0%BA%D1%82%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D1%85-%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D0%B5%D0%B9.pdf'),
('Porsche','997','GT3',2007,2009,'997.1 GT3 19-inch production package','US',false,
 '19x8.5 ET53','19x12 ET68','235/35R19 front / 305/30R19 rear',
 '5x130','71.6mm','verified',
 'Porsche production-wheel and service records specify the 997.1 GT3 package as 19x8.5J ET53 front and 19x12J ET68 rear with 235/35ZR19 and 305/30ZR19 tires. Hardware is 5x130, 71.6 mm with M14x1.5 R14 ball-seat wheel bolts. Source: https://files.porsche.com/filestore/download/international/none/997-1st-c2-catalogue-tequipment/default/70c96d7e-3a37-41d6-b6ac-c60fee059a14/Download-Tequipment-brochure-%28PDF%3B-3-5-MB%29.pdf'),
('Porsche','997','Turbo',2007,2012,'997 Turbo 19-inch production package','US',true,
 '19x8.5 ET56','19x11 ET51','235/35R19 front / 305/30R19 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 997 Tequipment and service documentation specifies the Turbo wheel geometry as 19x8.5J ET56 front and 19x11J ET51 rear; the production summer package uses 235/35ZR19 and 305/30ZR19 tires. Hardware is 5x130, 71.6 mm with M14x1.5 R14 ball-seat wheel bolts. Sources: https://files.porsche.com/filestore/download/international/none/997-1st-c2-catalogue-tequipment/default/70c96d7e-3a37-41d6-b6ac-c60fee059a14/Download-Tequipment-brochure-%28PDF%3B-3-5-MB%29.pdf ; https://pnr-prd2-pub2.newsroom.porsche.com/en/press-kits/50-years-porsche-turbo/The-911-Turbo-generations.html');

delete from public.fitment_factory_baselines
where make='Porsche' and model='997';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from porsche_997_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Porsche' and model='997' and active
order by trim,is_default desc,year_start;
