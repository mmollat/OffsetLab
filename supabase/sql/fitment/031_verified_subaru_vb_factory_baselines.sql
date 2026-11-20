-- Offset Lab Fitment
-- Pack 031: verified US-market Subaru VB WRX factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Both the base 17-inch and upper-trim 18-inch factory packages are retained.

update public.vehicle_models
set year_start = 2022, year_end = null
where make = 'Subaru' and model = 'VB';

update public.fitment_presets
set bolt_pattern = '5x114.3',
    center_bore = '56.1mm',
    factory_front = '18x8.5 ET55',
    factory_rear = '18x8.5 ET55',
    factory_tire = '245/40R18 front / 245/40R18 rear'
where make = 'Subaru' and model = 'VB' and trim = 'WRX'
  and active is not false;

create temp table if not exists subaru_vb_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table subaru_vb_verified_baselines;

insert into subaru_vb_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Subaru', 'VB', 'WRX', 2022, null,
    'Premium/Limited/GT 18-inch factory package', 'US', true,
    '18x8.5 ET55', '18x8.5 ET55',
    '245/40R18 front / 245/40R18 rear',
    '5x114.3', '56.1mm', 'verified',
    'Subaru of America''s 2024 WRX trim comparison specifies 18x8.5 aluminum-alloy wheels and 245/40R18 tires as standard on Premium, Limited, and GT. Subaru production wheel 28111VC040/060 and OE interchange records specify ET55; VB hardware is 5x114.3 with a 56.1 mm hub pilot and M12x1.25 conical lug nuts. Sources: https://www.subaru.com/services/vehicles/pdf/trimComparison/2024/WRX ; https://www.subaru.com/content/dam/subaru/downloads/pdf/brochures/2024/2024_WRX_Brochure_031924.pdf ; https://wheelworksdetroit.com/18x8-5-subaru-wrx-28111vc040/'
  ),
  (
    'Subaru', 'VB', 'WRX', 2022, null,
    'Base 17-inch factory package', 'US', false,
    '17x8 ET55', '17x8 ET55',
    '235/45R17 front / 235/45R17 rear',
    '5x114.3', '56.1mm', 'verified',
    'Subaru of America''s 2024 WRX trim comparison and factory window-sticker data specify 17x8 aluminum-alloy wheels and 235/45R17 tires as standard on the base WRX. Subaru production wheel 28111VC030 and OE interchange records specify ET55; VB hardware is 5x114.3 with a 56.1 mm hub pilot and M12x1.25 conical lug nuts. Sources: https://www.subaru.com/services/vehicles/pdf/trimComparison/2024/WRX ; https://www.subaru.com/services/vehicles/windowsticker/JF1VBAB65R9802064 ; https://awrswheels.com/product/factory-oem-17-wheel-fits-2022-2024-subaru-wrx-base-28111vc030/'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Subaru' and existing.model = 'VB'
  and existing.trim = 'WRX';

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from subaru_vb_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Subaru' and model = 'VB' and trim = 'WRX' and active
order by is_default desc, year_start;
