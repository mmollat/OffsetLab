-- Offset Lab Fitment
-- Pack 049: verified first-generation Lexus RC factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set year_start = 2015, year_end = 2025
where make = 'Lexus' and model = 'XC10';

update public.fitment_presets
set factory_front = '18x8 ET45',
    factory_rear = '18x8 ET45',
    factory_tire = '235/45R18 front / 235/45R18 rear',
    bolt_pattern = '5x114.3',
    center_bore = '60.1mm'
where make = 'Lexus' and model = 'XC10' and trim = 'RC350'
  and active is not false;

update public.fitment_presets
set factory_front = '19x9 ET50',
    factory_rear = '19x10 ET41',
    factory_tire = '255/35R19 front / 275/35R19 rear',
    bolt_pattern = '5x114.3',
    center_bore = '60.1mm'
where make = 'Lexus' and model = 'XC10' and trim = 'RC F'
  and active is not false;

create temp table if not exists lexus_xc10_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table lexus_xc10_verified_baselines;

insert into lexus_xc10_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
('Lexus','XC10','RC350',2015,2025,
 'RC 350 standard 18-inch production package','US',true,
 '18x8 ET45','18x8 ET45',
 '235/45R18 front / 235/45R18 rear','5x114.3','60.1mm','verified',
 'Lexus model documentation and the original Monroney equipment record specify 18-inch aluminum wheels with 235/45R18 tires on the standard RC 350. The genuine Lexus wheel catalog identifies the production wheel as 18x8J, and Lexus technical guidance identifies the applicable OEM offset as +45 mm. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://cdn.dealereprocess.org/cdn/brochures/lexus/2015-rc350.pdf ; https://s3.amazonaws.com/cdn.autoipacket.com/data/137/2320/1126582475/msrp/1126582475.20210608.080657-msrp-01.pdf ; https://www.lexuspartsnow.com/parts-list/2015-lexus-rc350/power_train_chassis/disc_wheel_wheel_cap.html ; https://static.nhtsa.gov/odi/tsbs/2019/MC-10155230-9999.pdf'),
('Lexus','XC10','RC F',2015,2025,
 'RC F standard forged 19-inch production package','US',true,
 '19x9 ET50','19x10 ET41',
 '255/35R19 front / 275/35R19 rear','5x114.3','60.1mm','verified',
 'Lexus USA RC F product information and the owner manual specify the 19x9 front and 19x10 rear forged wheel package with 255/35ZR19 and 275/35ZR19 tires. The production wheels are ET50 front and ET41 rear; hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. The 2025 Final Edition retained the same tire sizing. Sources: https://pressroom.lexus.com/2015-lexus-rc-f-product-news/ ; https://www.lexus.com/content/dam/lexus/documents/brochures/models/2015/MY15_RCF_Brochure_ZMagSetting.pdf ; https://s3cf792cad773e861.jimcontent.com/download/version/1612380820/module/15675465322/name/Lexus%20RC%20Owner%27s%20Manual.pdf ; https://pressroom.lexus.com/2025-lexus-rc-and-rc-f-a-sonorous-swan-song/');

delete from public.fitment_factory_baselines
where make = 'Lexus' and model = 'XC10';

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market, is_default,
       front, rear, tire, bolt_pattern, center_bore, source_status, source_note
from lexus_xc10_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front, rear,
       tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Lexus' and model = 'XC10' and active
order by trim;
