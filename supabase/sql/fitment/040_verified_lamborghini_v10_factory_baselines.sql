-- Offset Lab Fitment
-- Pack 040: verified Lamborghini Gallardo and Huracan factory baselines.
--
-- Plain SQL only. Safe to re-run. Wheel sizes and tires come from
-- Automobili Lamborghini technical data; exact offsets are corroborated by
-- genuine Lamborghini wheel part markings/catalog listings.

update public.vehicle_models
set year_start = case model
      when 'Gallardo LP560-4' then 2009
      when 'Gallardo Superleggera' then 2011
      when 'LP610' then 2015
      when 'Huracán EVO' then 2020
      when 'Huracán STO' then 2022
      when 'Huracán Tecnica' then 2023
      when 'Huracán Sterrato' then 2024
    end,
    year_end = case model
      when 'Gallardo LP560-4' then 2014
      when 'Gallardo Superleggera' then 2014
      when 'LP610' then 2019
      when 'Huracán EVO' then 2024
      when 'Huracán STO' then 2024
      when 'Huracán Tecnica' then 2024
      when 'Huracán Sterrato' then 2024
    end
where make = 'Lamborghini'
  and model in ('Gallardo LP560-4','Gallardo Superleggera','LP610',
    'Huracán EVO','Huracán STO','Huracán Tecnica','Huracán Sterrato');

-- Gallardo LP560-4 and LP570-4 Superleggera share the 19-inch staggered
-- production dimensions and wheel position.
update public.fitment_presets
set factory_front = '19x8.5 ET41.9',
    factory_rear = '19x11 ET55.3',
    factory_tire = '235/35R19 front / 295/30R19 rear',
    bolt_pattern = '5x112', center_bore = '57.1mm'
where make = 'Lamborghini'
  and model in ('Gallardo LP560-4','Gallardo Superleggera')
  and trim = 'Base' and active is not false;

-- Standard 20-inch Huracan package used by LP610-4, Performante, EVO, and
-- Tecnica. The five-lug platform has a split front/rear center bore.
update public.fitment_presets
set factory_front = '20x8.5 ET42',
    factory_rear = '20x11 ET40',
    factory_tire = '245/30R20 front / 305/30R20 rear',
    bolt_pattern = '5x112',
    center_bore = '57.1mm front / 66.5mm rear'
where make = 'Lamborghini'
  and (
    (model = 'LP610' and trim in ('Huracán LP610-4','Huracán Performante'))
    or (model in ('Huracán EVO','Huracán Tecnica') and trim = 'Base')
  ) and active is not false;

-- STO has dedicated center-lock wheels and a wider factory track.
update public.fitment_presets
set factory_front = '20x8.5 ET32',
    factory_rear = '20x11 ET29',
    factory_tire = '245/30R20 front / 305/30R20 rear',
    bolt_pattern = 'center lock', center_bore = 'factory center-lock hub'
where make = 'Lamborghini' and model = 'Huracán STO' and trim = 'Base'
  and active is not false;

-- Sterrato's dedicated 19-inch all-terrain package and wider front position.
update public.fitment_presets
set factory_front = '19x8.5 ET27',
    factory_rear = '19x11 ET40',
    factory_tire = '235/40R19 front / 285/40R19 rear',
    bolt_pattern = '5x112',
    center_bore = '57.1mm front / 66.5mm rear'
where make = 'Lamborghini' and model = 'Huracán Sterrato' and trim = 'Base'
  and active is not false;

-- Keep OEM+ deliberately modest but distinct from the verified factory setup.
update public.fitment_presets
set front = '19x8.5 +36', rear = '19x11 +49',
    front_tire = '235/35R19', rear_tire = '295/30R19'
where make = 'Lamborghini'
  and model in ('Gallardo LP560-4','Gallardo Superleggera')
  and trim = 'Base' and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x8.5 +36', rear = '20x11 +34',
    front_tire = '245/30R20', rear_tire = '305/30R20'
where make = 'Lamborghini'
  and (
    (model = 'LP610' and trim in ('Huracán LP610-4','Huracán Performante'))
    or (model in ('Huracán EVO','Huracán Tecnica') and trim = 'Base')
  ) and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x8.5 +26', rear = '20x11 +23',
    front_tire = '245/30R20', rear_tire = '305/30R20'
where make = 'Lamborghini' and model = 'Huracán STO' and trim = 'Base'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '19x8.5 +21', rear = '19x11 +34',
    front_tire = '235/40R19', rear_tire = '285/40R19'
where make = 'Lamborghini' and model = 'Huracán Sterrato' and trim = 'Base'
  and style = 'oemplus' and active is not false;

create temp table if not exists lamborghini_v10_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table lamborghini_v10_verified_baselines;

insert into lamborghini_v10_verified_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
values
 ('Lamborghini','Gallardo LP560-4','Base',2009,2014,
  '19-inch Apollo production package','US',true,
  '19x8.5 ET41.9','19x11 ET55.3',
  '235/35R19 front / 295/30R19 rear','5x112','57.1mm','verified',
  'Automobili Lamborghini product information identifies the LP560-4 Apollo 19-inch package; Lamborghini technical and tire documentation specifies 8.5x19 and 11x19 wheels with 235/35ZR19 and 295/30ZR19 tires. Genuine Lamborghini Apollo wheel part 400601025T is marked 8.5Jx19 ET41.9 and the matching rear 400601025G is marked 11Jx19 ET55.3. Hardware is 5x112, 57.1 mm, M14x1.5 wheel bolts. Sources: https://www.lamborghini.com/en-en/history/gallardo-lp-560-4-coupe ; https://teamspeed.com/forums/attachment.php?attachmentid=9128&d=1213280742 ; https://www.lamborghini.com/original/DAM/lamborghini/legal/regulations/2025-09-19_FILE_EPREL.pdf'),
 ('Lamborghini','Gallardo Superleggera','Base',2011,2014,
  '19-inch Scorpius forged production package','US',true,
  '19x8.5 ET41.9','19x11 ET55.3',
  '235/35R19 front / 295/30R19 rear','5x112','57.1mm','verified',
  'Automobili Lamborghini LP570-4 Superleggera technical data specifies 8.5x19 and 11x19 forged wheels with 235/35ZR19 and 295/30ZR19 P Zero Corsa tires. Genuine Lamborghini Scorpius parts 400601025R/AK and 400601025S/AL are marked ET41.9 front and ET55.3 rear. Hardware is 5x112, 57.1 mm, M14x1.5 wheel bolts. Source: https://preview.thenewsmarket.com/Previews/lamb/DocumentAssets/267110.pdf'),
 ('Lamborghini','LP610','Huracán LP610-4',2015,2019,
  '20-inch Giano production package','US',true,
  '20x8.5 ET42','20x11 ET40',
  '245/30R20 front / 305/30R20 rear','5x112',
  '57.1mm front / 66.5mm rear','verified',
  'Automobili Lamborghini US-market technical/options data specifies 20x8.5 front and 20x11 rear wheels for the LP610-4; Lamborghini tire documentation specifies 245/30R20 and 305/30R20. Genuine Giano/Mimas wheel parts 4T0601017 and 4T0601017A are marked ET42 front and ET40 rear. Five-lug hardware is 5x112 with split 57.1/66.5 mm bores and M14x1.5 conical bolts. Sources: https://www.exoticcarhacks.com/wp-content/uploads/2024/02/Lamborghini-Huracan-MY16-options-list_USAretail-14-10-2015-1.pdf ; https://www.lamborghini.com/original/DAM/lamborghini/legal/regulations/2025-09-19_FILE_EPREL.pdf'),
 ('Lamborghini','LP610','Huracán Performante',2018,2019,
  '20-inch forged production package','US',true,
  '20x8.5 ET42','20x11 ET40',
  '245/30R20 front / 305/30R20 rear','5x112',
  '57.1mm front / 66.5mm rear','verified',
  'Automobili Lamborghini Performante technical specifications explicitly list 8.5Jx20 ET42 front and 11Jx20 ET40 rear forged wheels with 245/30R20 and 305/30R20 tires. Five-lug hardware is 5x112 with split 57.1/66.5 mm bores and M14x1.5 conical bolts; center-lock wheels were optional. Source: https://www.lamborghini.com/en-en/history/huracan-performante'),
 ('Lamborghini','Huracán EVO','Base',2020,2024,
  '20-inch Aesir production package','US',true,
  '20x8.5 ET42','20x11 ET40',
  '245/30R20 front / 305/30R20 rear','5x112',
  '57.1mm front / 66.5mm rear','verified',
  'Automobili Lamborghini identifies 20-inch Aesir wheels as standard EVO equipment; official Lamborghini pre-owned vehicle data specifies 8.5Jx20 front and 11Jx20 rear with 245/30R20 and 305/30R20 tires. Genuine Aesir/Giano wheel parts retain ET42 front and ET40 rear. Five-lug hardware is 5x112 with split 57.1/66.5 mm bores and M14x1.5 conical bolts. Sources: https://www.lamborghini.com/en-en/history/huracan-evo ; https://preowned.lamborghini.com/de_de/vdp/30002386-2022-Hurac%C3%A1n-EVO-LP-610-2-RWD-Spyder-Nero-Ade'),
 ('Lamborghini','Huracán Tecnica','Base',2023,2024,
  '20-inch Damiso production package','US',true,
  '20x8.5 ET42','20x11 ET40',
  '245/30R20 front / 305/30R20 rear','5x112',
  '57.1mm front / 66.5mm rear','verified',
  'Automobili Lamborghini Tecnica brochure specifies 8.5Jx20 front and 11Jx20 rear wheels with 245/30R20 and 305/30R20 Bridgestone Potenza Sport tires. Genuine Lamborghini 20-inch wheel allocation retains ET42 front and ET40 rear. Five-lug hardware is 5x112 with split 57.1/66.5 mm bores and M14x1.5 conical bolts; center lock was optional. Source: https://www.lamborghini.com/original/DAM/lamborghini/facelift_2019/model_detail/huracan/tecnica/2024/06_24_brochure/Lamborghini%20Hurac%C3%A1n%20Tecnica_ES_WCAG.pdf'),
 ('Lamborghini','Huracán STO','Base',2022,2024,
  '20-inch STO forged center-lock package','US',true,
  '20x8.5 ET32','20x11 ET29',
  '245/30R20 front / 305/30R20 rear','center lock',
  'factory center-lock hub','verified',
  'Automobili Lamborghini STO technical data specifies 8.5Jx20 front and 11Jx20 rear wheels with 245/30R20 and 305/30R20 Bridgestone tires. Lamborghini parts allocation identifies genuine STO wheel family 4T3601017 as ET32 front and ET29 rear, mounted by a single center-lock nut. Sources: https://preview.thenewsmarket.com/Previews/lamb/DocumentAssets/572482_v2.pdf ; https://www.eurospares.es/lamborghini/huracan/2022-sto/part-diagrams/601-05-00/wheels-tyres-front ; https://www.eurospares.fr/lamborghini/huracan/2022-sto/part-diagrams/601-06-00/wheels-tyres-rear'),
 ('Lamborghini','Huracán Sterrato','Base',2024,2024,
  '19-inch Cerere all-terrain production package','US',true,
  '19x8.5 ET27','19x11 ET40',
  '235/40R19 front / 285/40R19 rear','5x112',
  '57.1mm front / 66.5mm rear','verified',
  'Automobili Lamborghini Sterrato technical brochure explicitly specifies 8.5Jx19 ET27 front and 11Jx19 ET40 rear Cerere wheels with 235/40R19 and 285/40R19 Bridgestone Dueler A/T002 tires. Five-lug hardware is 5x112 with split 57.1/66.5 mm bores and M14x1.5 conical bolts. Source: https://www.lamborghini.com/original/DAM/lamborghini/facelift_2019/model_detail/huracan/sterrato/2024/06_24_brochure/HURACAN%20STERRATO_DIGITAL_BROCHURE_DE_2024.pdf');

delete from public.fitment_factory_baselines existing
where existing.make = 'Lamborghini'
  and (
    existing.model in ('Gallardo LP560-4','Gallardo Superleggera',
      'Huracán EVO','Huracán STO','Huracán Tecnica','Huracán Sterrato')
    or (existing.model = 'LP610'
      and existing.trim in ('Huracán LP610-4','Huracán Performante'))
  );

insert into public.fitment_factory_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
select make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from lamborghini_v10_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
  bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make = 'Lamborghini' and active
order by model,trim,year_start desc;
