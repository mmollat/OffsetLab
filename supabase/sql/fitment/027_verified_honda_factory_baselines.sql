-- Offset Lab Fitment
-- Pack 027: verified US-market Honda factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Honda's German-market homologation documents supply the original wheel
-- offsets, bolt patterns, and hub bores; Honda US specifications establish
-- the matching US-market wheel and tire packages.

update public.vehicle_models set year_start = 2000, year_end = 2003
where make = 'Honda' and model = 'AP1';

update public.vehicle_models set year_start = 2004, year_end = 2009
where make = 'Honda' and model = 'AP2';

update public.vehicle_models set year_start = 2017, year_end = 2020
where make = 'Honda' and model = 'FC1';

update public.vehicle_models set year_start = 2017, year_end = 2021
where make = 'Honda' and model in ('FK7', 'FK8');

update public.vehicle_models set year_start = 2023, year_end = null
where make = 'Honda' and model = 'FL5';

update public.fitment_presets
set
  bolt_pattern = case
    when model in ('FK8', 'FL5') then '5x120'
    else '5x114.3'
  end,
  center_bore = case
    when model in ('AP1', 'AP2') then '70.1mm front / 64.1mm rear'
    else '64.1mm'
  end,
  factory_front = case
    when model = 'AP1' then '16x6.5 ET55'
    when model = 'AP2' then '17x7 ET55'
    when model in ('FC1', 'FK7') then '18x8 ET50'
    when model = 'FK8' then '20x8.5 ET60'
    when model = 'FL5' then '19x9.5 ET60'
  end,
  factory_rear = case
    when model = 'AP1' then '16x7.5 ET65'
    when model = 'AP2' then '17x8.5 ET65'
    when model in ('FC1', 'FK7') then '18x8 ET50'
    when model = 'FK8' then '20x8.5 ET60'
    when model = 'FL5' then '19x9.5 ET60'
  end,
  factory_tire = case
    when model = 'AP1' then '205/55R16 front / 225/50R16 rear'
    when model = 'AP2' and trim = 'Base'
      then '215/45R17 front / 245/40R17 rear'
    when model = 'AP2' and trim = 'CR'
      then '215/45R17 front / 255/40R17 rear'
    when model in ('FC1', 'FK7')
      then '235/40R18 front / 235/40R18 rear'
    when model = 'FK8'
      then '245/30ZR20 front / 245/30ZR20 rear'
    when model = 'FL5'
      then '265/30ZR19 front / 265/30ZR19 rear'
  end
where make = 'Honda'
  and (
    (model = 'AP1' and trim = 'Base')
    or (model = 'AP2' and trim in ('Base', 'CR'))
    or (model = 'FC1' and trim = 'Si')
    or (model = 'FK7' and trim = 'Sport')
    or (model in ('FK8', 'FL5') and trim = 'Type R')
  )
  and active is not false;

create temp table if not exists honda_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table honda_verified_baselines;

insert into honda_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Honda', 'AP1', 'Base', 2000, 2003,
    'Standard 16-inch factory setup', 'US', true,
    '16x6.5 ET55', '16x7.5 ET65',
    '205/55R16 front / 225/50R16 rear',
    '5x114.3', '70.1mm front / 64.1mm rear', 'verified',
    'Honda US specifications publish 16x6.5 front and 16x7.5 rear wheels with 205/55R16 and 225/50R16 tires. Honda type-approval documentation specifies ET55 front, ET65 rear, 5x114.3 mounting, and the S2000 wheel/hub fitment. The S2000 uses its characteristic larger front wheel pilot and smaller rear pilot, preventing front/rear wheel interchange. US-market years: 2000-2003. Sources: https://hondanews.com/en-US/releases/release-f50455566be9846606e481004c34c6d5-2003-honda-s2000-specifications ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/ap_s2000.pdf'
  ),
  (
    'Honda', 'AP2', 'Base', 2004, 2009,
    'Standard 17-inch factory setup', 'US', true,
    '17x7 ET55', '17x8.5 ET65',
    '215/45R17 front / 245/40R17 rear',
    '5x114.3', '70.1mm front / 64.1mm rear', 'verified',
    'Honda US chassis specifications publish 17x7 front and 17x8.5 rear wheels with 215/45R17 and 245/40R17 tires. Honda type-approval documentation specifies ET55 front, ET65 rear and 5x114.3 mounting. The S2000 uses a 70.1 mm front wheel pilot and 64.1 mm rear wheel pilot. US-market years: 2004-2009. Sources: https://hondanews.com/en-US/releases/release-0a883d51b49ea932518ce5004c34c4b1-2004-honda-s2000-chassis ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/ap_s2000.pdf'
  ),
  (
    'Honda', 'AP2', 'CR', 2008, 2009,
    'Club Racer 17-inch factory setup', 'US', true,
    '17x7 ET55', '17x8.5 ET65',
    '215/45R17 front / 255/40R17 rear',
    '5x114.3', '70.1mm front / 64.1mm rear', 'verified',
    'Honda US S2000 CR specifications publish 17x7 front and 17x8.5 rear wheels with 215/45R17 front and CR-specific 255/40R17 rear tires. Honda type-approval documentation establishes ET55 front, ET65 rear and 5x114.3 mounting; Honda OE wheels are 44700-S2A-A61 front and 42700-S2A-A61 rear. The S2000 wheel pilots are 70.1 mm front and 64.1 mm rear. US-market years: 2008-2009. Sources: https://hondanews.com/en-US/honda-automobiles/releases/release-5dbe902175c45502744cfd004c34be73-2008-honda-s2000-specifications-and-features ; https://hondanews.com/en-US/releases/release-ab0437e144cd5d07298e97004c34be70-2008-honda-s2000-chassis ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/ap_s2000.pdf'
  ),
  (
    'Honda', 'FC1', 'Si', 2017, 2020,
    'Standard 18-inch factory setup', 'US', true,
    '18x8 ET50', '18x8 ET50',
    '235/40R18 front / 235/40R18 rear',
    '5x114.3', '64.1mm', 'verified',
    'Honda US specifications publish the Civic Si sedan 18-inch wheel and 235/40R18 tire package. Honda Genuine Accessory/OE documentation specifies the matching 18x8 wheel at ET50; Honda platform homologation establishes 5x114.3 mounting and a 64.1 mm hub pilot. The database retains its established FC1 label for this Si sedan entry. US-market years: 2017-2020. Sources: https://hondanews.com/en-US/honda-automobiles/releases/release-fd34ed6adcef44ffac7f1cf42c1813c8-2020-civic-si-specifications-features ; https://www.hondapartsonline.net/oem-parts/honda-18-wheel-8w18tea100a'
  ),
  (
    'Honda', 'FK7', 'Sport', 2017, 2021,
    'Sport 18-inch factory setup', 'US', true,
    '18x8 ET50', '18x8 ET50',
    '235/40R18 front / 235/40R18 rear',
    '5x114.3', '64.1mm', 'verified',
    'Honda US specifications publish the Civic Hatchback Sport 18-inch wheel and 235/40R18 tire package. Honda type-approval documentation specifies 18x8 ET50, a 5x114.3 bolt pattern, and a nominal 64 mm hub pilot (64.1 mm production specification). US-market years: 2017-2021. Sources: https://hondanews.com/en-US/releases/release-0105593f978caa92e9791e015d0300cc-2021-civic-hatchback-specifications-features ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/fk7_civic-5-tuerer_typ_fk.pdf'
  ),
  (
    'Honda', 'FK8', 'Type R', 2017, 2021,
    'Standard 20-inch factory setup', 'US', true,
    '20x8.5 ET60', '20x8.5 ET60',
    '245/30ZR20 front / 245/30ZR20 rear',
    '5x120', '64.1mm', 'verified',
    'Honda US specifications publish 20x8.5 wheels and 245/30ZR20 tires for the FK8 Civic Type R. Honda type-approval documentation specifies ET60, a 5x120 bolt pattern, and a nominal 64 mm hub pilot (64.1 mm production specification). US-market years: 2017-2021. Sources: https://hondanews.com/en-US/releases/release-0105593f978caa92e9791e015d009911-2021-civic-type-r-specifications-features ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/fk8_civic-type-r_typ_fk.pdf'
  ),
  (
    'Honda', 'FL5', 'Type R', 2023, null,
    'Standard 19-inch factory setup', 'US', true,
    '19x9.5 ET60', '19x9.5 ET60',
    '265/30ZR19 front / 265/30ZR19 rear',
    '5x120', '64.1mm', 'verified',
    'Honda US press-kit specifications publish 19x9.5 wheels and 265/30ZR19 tires for the FL5 Civic Type R. Honda type-approval documentation specifies ET60, a 5x120 bolt pattern, and a nominal 64 mm hub pilot (64.1 mm production specification); the US OE wheel is 42700-T60-A92. US-market years: 2023-present. Sources: https://hondanews.com/en-US/honda-automobiles/releases/release-907c81858bdfe231c1cc3d0f70179fdc-2023-honda-civic-type-r-press-kit ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/fl4_civic_typ_fe.pdf'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Honda'
  and (
    (existing.model = 'AP1' and existing.trim = 'Base')
    or (existing.model = 'AP2' and existing.trim in ('Base', 'CR'))
    or (existing.model = 'FC1' and existing.trim = 'Si')
    or (existing.model = 'FK7' and existing.trim = 'Sport')
    or (existing.model in ('FK8', 'FL5') and existing.trim = 'Type R')
  );

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from honda_verified_baselines;

select model, trim, year_start, year_end, front, rear, tire, bolt_pattern,
  center_bore, source_status
from public.fitment_factory_baselines
where make = 'Honda' and active
order by model, trim;
