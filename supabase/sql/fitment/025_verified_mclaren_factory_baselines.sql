-- Offset Lab Fitment
-- Pack 025: verified US-market McLaren factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Artura uses a different hub bore from the earlier Sports/Super Series cars.

update public.vehicle_models set year_start = 2016, year_end = 2021
where make = 'McLaren' and model = '570S';

update public.vehicle_models set year_start = 2018, year_end = 2023
where make = 'McLaren' and model = '720S';

update public.vehicle_models set year_start = 2023, year_end = null
where make = 'McLaren' and model = 'Artura';

update public.fitment_presets
set
  bolt_pattern = '5x112',
  center_bore = case when model = 'Artura' then '66.6mm' else '57.1mm' end,
  factory_front = case
    when model = '570S' then '19x8 ET32.5'
    when model = '720S' then '19x9 ET41.65'
    when model = 'Artura' then '19x8.5 ET43'
  end,
  factory_rear = case
    when model = '570S' then '20x10 ET24.25'
    when model = '720S' then '20x11 ET24.75'
    when model = 'Artura' then '20x10.5 ET49'
  end,
  factory_tire = case
    when model = '570S' then '225/35ZR19 front / 285/35ZR20 rear'
    when model = '720S' then '245/35ZR19 front / 305/30ZR20 rear'
    when model = 'Artura' then '235/35ZR19 front / 295/35ZR20 rear'
  end
where make = 'McLaren' and model in ('570S', '720S', 'Artura')
  and trim = 'Base' and active is not false;

create temp table if not exists mclaren_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table mclaren_verified_baselines;

insert into mclaren_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'McLaren', '570S', 'Base', 2016, 2021,
    'Standard 19/20-inch factory setup', 'US', true,
    '19x8 ET32.5', '20x10 ET24.25',
    '225/35ZR19 front / 285/35ZR20 rear',
    '5x112', '57.1mm', 'verified',
    'McLaren owner/product documentation and OE-spec tyre records specify 19x8 front / 20x10 rear wheels with 225/35ZR19 and 285/35ZR20 tyres. Factory wheel markings document ET32.5 front and ET24.25 rear. Sports Series hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://static1.squarespace.com/static/600991761b8df26d5bdb3914/t/67094ef0bf498c00d856618b/1728663288242/570s%2BEnglish.pdf ; https://www.michelin.ca/en/auto/manufacturers/mclaren/570s ; https://fmbwheels.com/mclaren-570s-570gt-p13-2016-2021-wheel-fitment-guide/'
  ),
  (
    'McLaren', '720S', 'Base', 2018, 2023,
    'Standard 19/20-inch factory setup', 'US', true,
    '19x9 ET41.65', '20x11 ET24.75',
    '245/35ZR19 front / 305/30ZR20 rear',
    '5x112', '57.1mm', 'verified',
    'McLaren 720S product and owner documentation specify 19x9 front / 20x11 rear wheels with 245/35ZR19 and 305/30ZR20 tyres. Factory wheel markings document ET41.65 front and ET24.75 rear. Super Series hardware is 5x112, 57.1 mm, M14x1.5 ball-seat bolts. Sources: https://xr793.com/wp-content/uploads/2022/11/2021-McLaren-720S.pdf ; https://www.michelin.co.uk/auto/browse-tyres/by-vehicle/mclaren/720s/720s/2025/4.0-v8-bi-turbo-720/245---35-R-19-93%28Y%29_305---30-R-20-103%28Y%29 ; https://fmbwheels.com/mclaren-720s-765lt-750s-2018-2027-wheel-fitment-guide/'
  ),
  (
    'McLaren', 'Artura', 'Base', 2023, null,
    'Standard 19/20-inch factory setup', 'US', true,
    '19x8.5 ET43', '20x10.5 ET49',
    '235/35ZR19 front / 295/35ZR20 rear',
    '5x112', '66.6mm', 'verified',
    'McLaren Artura owner manual and technical specification publish 19x8.5 front / 20x10.5 rear wheels with 235/35ZR19 and 295/35ZR20 tyres. Swiss vehicle homologation records specify ET43 front and ET49 rear; Artura hardware is 5x112, 66.6 mm, M14x1.5 wheel bolts. Sources: https://mclaren-web.s3.eu-west-2.amazonaws.com/files/Owner%20Manual%20-%20Artura%20-%20Europe%20-%20English.pdf ; https://cms-assets-production.mclaren.com/1209/Global_Artura_Product_Brochure.pdf ; https://onyxforgedwheels.com/en/forged-wheels-mclaren-artura-2022'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'McLaren' and existing.model in ('570S', '720S', 'Artura')
  and existing.trim = 'Base';

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from mclaren_verified_baselines;

select model, trim, year_start, year_end, front, rear, tire, bolt_pattern,
  center_bore, source_status
from public.fitment_factory_baselines
where make = 'McLaren' and active
order by model;
