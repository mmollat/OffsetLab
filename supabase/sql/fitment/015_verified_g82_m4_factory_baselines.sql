-- Offset Lab Fitment
-- Pack 015: verified BMW G82 M4 factory baselines and hub metadata.
--
-- Plain SQL only. Safe to re-run.
-- BMW publishes the G82 factory wheel widths, diameters, offsets, and tire
-- sizes. G8x M cars use 5x112 / 66.6 mm, not the older F8x 5x120 / 72.6 mm.

update public.fitment_presets
set
  bolt_pattern = '5x112',
  center_bore = '66.6mm'
where make = 'BMW'
  and model = 'G82'
  and active is not false;

create temp table if not exists g82_verified_baseline_rows (
  make text,
  model text,
  trim text,
  year_start int,
  year_end int,
  package_name text,
  market text,
  is_default boolean,
  front text,
  rear text,
  tire text,
  bolt_pattern text,
  center_bore text,
  source_status text,
  source_note text
) on commit drop;

truncate table g82_verified_baseline_rows;

insert into g82_verified_baseline_rows (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'BMW', 'G82', 'M4', 2021, null,
    'Base 18/19-inch factory setup', 'US', true,
    '18x9.5 ET20', '19x10.5 ET20',
    '275/40R18 front / 285/35R19 rear',
    '5x112', '66.6mm', 'verified',
    'Verified against BMW Group USA 2021 and 2025 M4 technical specifications for the six-speed manual model (9.5Jx18 front, 10.5Jx19 rear; 275/40R18 and 285/35R19) and BMW M wheel engineering guidance listing ET20 front/rear. G82 hub metadata cross-checked against the RAYS wheel application catalog. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0317577EN_US/the-new-2021-bmw-m3-sedan-and-m4-coupe?language=en_US ; https://www.bmw-m.com/en/topics/magazine-article-pool/bmw-m3-m4-rims-wheels.html/1000'
  ),
  (
    'BMW', 'G82', 'M4 Competition', 2021, null,
    'Competition 19/20-inch factory setup', 'US', true,
    '19x9.5 ET20', '20x10.5 ET20',
    '275/35R19 front / 285/30R20 rear',
    '5x112', '66.6mm', 'verified',
    'Verified against BMW Group USA G82 M4 Competition specifications (9.5Jx19 front, 10.5Jx20 rear; 275/35R19 and 285/30R20) and BMW M wheel engineering guidance listing ET20 front/rear. G82 hub metadata cross-checked against the RAYS wheel application catalog. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0317577EN_US/the-new-2021-bmw-m3-sedan-and-m4-coupe?language=en_US ; https://www.bmw-m.com/en/topics/magazine-article-pool/bmw-m3-m4-rims-wheels.html/1000'
  ),
  (
    'BMW', 'G82', 'M4 Competition xDrive', 2022, null,
    'Competition xDrive 19/20-inch factory setup', 'US', true,
    '19x9.5 ET20', '20x10.5 ET20',
    '275/35R19 front / 285/30R20 rear',
    '5x112', '66.6mm', 'verified',
    'Verified against BMW Group USA 2022 M4 Competition xDrive specifications (19-inch front and 20-inch rear forged wheels; 275/35R19 and 285/30R20) and BMW M wheel engineering guidance listing 9.5Jx19 ET20 front / 10.5Jx20 ET20 rear. G82 hub metadata cross-checked against the RAYS wheel application catalog. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0330025EN_US/the-new-2022-bmw-m3-competition-xdrive-sedan-and-m4-competition-xdrive-coupe?language=en_US ; https://www.bmw-m.com/en/topics/magazine-article-pool/bmw-m3-m4-rims-wheels.html/1000'
  );

update public.fitment_factory_baselines existing
set
  front = source.front,
  rear = source.rear,
  tire = source.tire,
  bolt_pattern = source.bolt_pattern,
  center_bore = source.center_bore,
  source_status = source.source_status,
  source_note = source.source_note,
  is_default = true,
  active = true,
  updated_at = now()
from g82_verified_baseline_rows source
where existing.make = source.make
  and existing.model = source.model
  and existing.trim = source.trim
  and existing.market = source.market
  and coalesce(existing.package_name, 'Default') = source.package_name;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  source.make, source.model, source.trim, source.year_start, source.year_end,
  source.package_name, source.market, source.is_default, source.front,
  source.rear, source.tire, source.bolt_pattern, source.center_bore,
  source.source_status, source.source_note
from g82_verified_baseline_rows source
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = source.make
    and existing.model = source.model
    and existing.trim = source.trim
    and existing.market = source.market
    and coalesce(existing.package_name, 'Default') = source.package_name
);

select
  count(*) as verified_g82_default_baselines
from public.fitment_factory_baselines
where make = 'BMW'
  and model = 'G82'
  and active
  and is_default
  and source_status = 'verified';
