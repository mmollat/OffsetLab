-- Offset Lab Fitment
-- Pack 024: verified US-market Hyundai Genesis Coupe factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- BK1 and BK2 share wheel widths but not offsets, so each generation and
-- factory wheel package is represented explicitly for both engine choices.

update public.vehicle_models
set year_start = 2010, year_end = 2016
where make = 'Hyundai' and model = 'BK';

update public.fitment_presets
set
  bolt_pattern = '5x114.3',
  center_bore = '67.1mm',
  factory_front = '19x8 ET34',
  factory_rear = '19x8.5 ET32',
  factory_tire = '225/40R19 front / 245/40R19 rear'
where make = 'Hyundai' and model = 'BK'
  and trim in ('Genesis Coupe 2.0T', 'Genesis Coupe 3.8')
  and active is not false;

create temp table if not exists genesis_coupe_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table genesis_coupe_verified_baselines;

insert into genesis_coupe_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Hyundai', 'BK', 'Genesis Coupe 2.0T', 2013, 2014,
    'BK2 R-Spec 19-inch factory package', 'US', true,
    '19x8 ET34', '19x8.5 ET32',
    '225/40R19 front / 245/40R19 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai 2013 service data specifies the staggered 19x8/19x8.5 wheel and 225/40R19 / 245/40R19 tire package. Genuine BK2 wheels 52910-2M320 and 52910-2M330 are stamped ET34 front and ET32 rear. Hardware is 5x114.3, 67.1 mm, M12x1.5. Sources: https://web.heavenlysanctuary.com/Genesis_2.0T_2013.pdf ; https://www.hyundaipartscounter.com/oem-parts/hyundai-wheel-alloy-529102m320 ; https://www.redlineautoparts.com/hyundai/2013-2016-hyundai-genesis-coupe-19-oem-wheels-rims-w-tires-set-of-4-hg034/'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 2.0T', 2013, 2014,
    'BK2 18-inch factory package', 'US', false,
    '18x7.5 ET32', '18x8 ET30',
    '225/45R18 front / 245/45R18 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai service and 2014 specification documents list 18x7.5 front / 18x8 rear with 225/45R18 and 245/45R18 tires. Genuine BK2 wheels 52910-2M220 and 52910-2M230 are stamped ET32 front and ET30 rear. Sources: https://web.heavenlysanctuary.com/Genesis_2.0T_2013.pdf ; https://www.centuryu.com/uploads/1/4/4/6/144698822/2014_genesis_coupe.pdf ; https://www.hubcaphaven.com/p/9744/aly70839-hyundai-genesis-coupe-wheel-silver-painted-529102m220.html'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 2.0T', 2010, 2012,
    'BK1 Track/R-Spec 19-inch factory package', 'US', false,
    '19x8 ET35', '19x8.5 ET35',
    '225/40R19 front / 245/40R19 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai BK1 parts catalog records pair 225/40R19 and 245/40R19 tires with genuine front 52910-2M120 and rear 52910-2M130 wheels. OEM wheel markings specify 19x8 ET35 front / 19x8.5 ET35 rear. Sources: https://www.hyundaipartsdeal.com/parts-list/2010-hyundai-genesis_coupe/chassis/wheel_cap.html ; https://www.partshyundai.com/oem-parts/hyundai-wheel-alloy-529102m120 ; https://www.redlineautoparts.com/hyundai/genesis-coupe/2009-2012-hyundai-genesis-coupe-track-19-wheels-rims-set-of-4-damage-hg024/'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 2.0T', 2010, 2012,
    'BK1 18-inch factory package', 'US', false,
    '18x7.5 ET33', '18x8 ET33',
    '225/45R18 front / 245/45R18 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai 2010 brochure and BK1 parts catalog specify the 18x7.5 front / 18x8 rear package with 225/45R18 and 245/45R18 tires. Genuine 52910-2M020/2M030 wheel markings specify ET33. Sources: https://www.motorologist.com/wp-content/uploads/2010-Hyundai-Genesis-Coupe-brochure.pdf ; https://www.hyundaipartsdeal.com/parts-list/2010-hyundai-genesis_coupe/chassis/wheel_cap.html ; https://www.partshyundai.com/oem-parts/hyundai-wheel-alloy-529102m030'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 3.8', 2013, 2016,
    'BK2 R-Spec/Ultimate 19-inch factory package', 'US', true,
    '19x8 ET34', '19x8.5 ET32',
    '225/40R19 front / 245/40R19 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai 2013 service data specifies the staggered 19x8/19x8.5 wheel and 225/40R19 / 245/40R19 tire package. Genuine BK2 wheels 52910-2M320 and 52910-2M330 are stamped ET34 front and ET32 rear. Hardware is 5x114.3, 67.1 mm, M12x1.5. Sources: https://www.sportiveshyundai.fr/wp-content/uploads/bsk-pdf-manager/2019/09/10.0-Suspension-System-3.pdf ; https://www.hyundaipartscounter.com/oem-parts/hyundai-wheel-alloy-529102m320 ; https://www.redlineautoparts.com/hyundai/2013-2016-hyundai-genesis-coupe-19-oem-wheels-rims-w-tires-set-of-4-hg034/'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 3.8', 2013, 2016,
    'BK2 18-inch factory package', 'US', false,
    '18x7.5 ET32', '18x8 ET30',
    '225/45R18 front / 245/45R18 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai 2013 service and 2014 specification documents list 18x7.5 front / 18x8 rear with 225/45R18 and 245/45R18 tires. Genuine BK2 wheels 52910-2M220 and 52910-2M230 are stamped ET32 front and ET30 rear. Sources: https://www.sportiveshyundai.fr/wp-content/uploads/bsk-pdf-manager/2019/09/10.0-Suspension-System-3.pdf ; https://www.centuryu.com/uploads/1/4/4/6/144698822/2014_genesis_coupe.pdf ; https://www.hubcaphaven.com/c/3156/hyundai_genesis_wheels_rims.html'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 3.8', 2010, 2012,
    'BK1 Track 19-inch factory package', 'US', false,
    '19x8 ET35', '19x8.5 ET35',
    '225/40R19 front / 245/40R19 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai BK1 parts catalog records pair 225/40R19 and 245/40R19 tires with genuine front 52910-2M120 and rear 52910-2M130 wheels. OEM wheel markings specify 19x8 ET35 front / 19x8.5 ET35 rear. Sources: https://www.hyundaipartsdeal.com/parts-list/2010-hyundai-genesis_coupe/chassis/wheel_cap.html ; https://www.redlineautoparts.com/hyundai/genesis-coupe/2009-2012-hyundai-genesis-coupe-track-19-wheels-rims-set-of-4-damage-hg024/'
  ),
  (
    'Hyundai', 'BK', 'Genesis Coupe 3.8', 2010, 2012,
    'BK1 18-inch factory package', 'US', false,
    '18x7.5 ET33', '18x8 ET33',
    '225/45R18 front / 245/45R18 rear', '5x114.3', '67.1mm', 'verified',
    'Hyundai 2010 brochure and BK1 parts catalog specify the 18x7.5 front / 18x8 rear package with 225/45R18 and 245/45R18 tires. Genuine 52910-2M020/2M030 wheel markings specify ET33. Sources: https://www.motorologist.com/wp-content/uploads/2010-Hyundai-Genesis-Coupe-brochure.pdf ; https://www.hyundaipartsdeal.com/parts-list/2010-hyundai-genesis_coupe/chassis/wheel_cap.html'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Hyundai' and existing.model = 'BK'
  and existing.trim in ('Genesis Coupe 2.0T', 'Genesis Coupe 3.8');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from genesis_coupe_verified_baselines;

select trim, year_start, year_end, package_name, is_default, front, rear,
  tire, source_status
from public.fitment_factory_baselines
where make = 'Hyundai' and model = 'BK' and active
order by trim, is_default desc, year_start desc, package_name;
