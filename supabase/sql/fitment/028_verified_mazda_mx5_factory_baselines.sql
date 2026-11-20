-- Offset Lab Fitment
-- Pack 028: verified US-market Mazda MX-5 Miata factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Package and model-year alternatives are retained instead of blending
-- changing factory configurations into a single false baseline.

update public.vehicle_models set year_start = 1990, year_end = 1997
where make = 'Mazda' and model = 'NA';

update public.vehicle_models set year_start = 1999, year_end = 2005
where make = 'Mazda' and model = 'NB';

update public.vehicle_models set year_start = 2006, year_end = 2015
where make = 'Mazda' and model = 'NC';

update public.vehicle_models set year_start = 2016, year_end = null
where make = 'Mazda' and model = 'ND';

update public.fitment_presets
set
  bolt_pattern = case when model = 'NC' then '5x114.3' else '4x100' end,
  center_bore = case when model = 'NC' then '67.1mm' else '54.1mm' end,
  factory_front = case
    when model = 'NA' and trim = 'Base' then '14x5.5 ET45'
    when model = 'NA' and trim = 'M Edition' then '15x6 ET45'
    when model = 'NB' and trim = 'Base' then '15x6 ET40'
    when model = 'NB' and trim = 'Mazdaspeed' then '17x7 ET40'
    when model = 'NC' and trim = 'Sport' then '16x6.5 ET55'
    when model = 'NC' and trim = 'Grand Touring' then '17x7 ET55'
    when model = 'ND' and trim = 'Sport' then '16x6.5 ET45'
    when model = 'ND' and trim in ('Club', 'Grand Touring') then '17x7 ET45'
  end,
  factory_rear = case
    when model = 'NA' and trim = 'Base' then '14x5.5 ET45'
    when model = 'NA' and trim = 'M Edition' then '15x6 ET45'
    when model = 'NB' and trim = 'Base' then '15x6 ET40'
    when model = 'NB' and trim = 'Mazdaspeed' then '17x7 ET40'
    when model = 'NC' and trim = 'Sport' then '16x6.5 ET55'
    when model = 'NC' and trim = 'Grand Touring' then '17x7 ET55'
    when model = 'ND' and trim = 'Sport' then '16x6.5 ET45'
    when model = 'ND' and trim in ('Club', 'Grand Touring') then '17x7 ET45'
  end,
  factory_tire = case
    when model = 'NA' and trim = 'Base'
      then '185/60R14 front / 185/60R14 rear'
    when model = 'NA' and trim = 'M Edition'
      then '195/55R15 front / 195/55R15 rear'
    when model = 'NB' and trim = 'Base'
      then '195/50R15 front / 195/50R15 rear'
    when model = 'NB' and trim = 'Mazdaspeed'
      then '205/40R17 front / 205/40R17 rear'
    when model = 'NC' and trim = 'Sport'
      then '205/50R16 front / 205/50R16 rear'
    when model = 'NC' and trim = 'Grand Touring'
      then '205/45R17 front / 205/45R17 rear'
    when model = 'ND' and trim = 'Sport'
      then '195/50R16 front / 195/50R16 rear'
    when model = 'ND' and trim in ('Club', 'Grand Touring')
      then '205/45R17 front / 205/45R17 rear'
  end
where make = 'Mazda'
  and (
    (model = 'NA' and trim in ('Base', 'M Edition'))
    or (model = 'NB' and trim in ('Base', 'Mazdaspeed'))
    or (model = 'NC' and trim in ('Sport', 'Grand Touring'))
    or (model = 'ND' and trim in ('Sport', 'Club', 'Grand Touring'))
  )
  and active is not false;

create temp table if not exists mazda_mx5_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table mazda_mx5_verified_baselines;

insert into mazda_mx5_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Mazda', 'NA', 'Base', 1990, 1997,
    'Standard 14-inch factory setup', 'US', true,
    '14x5.5 ET45', '14x5.5 ET45',
    '185/60R14 front / 185/60R14 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda factory service data specifies a 14x5.5-JJ wheel at 45 mm offset; the US factory tire is 185/60R14. Mazda parts documentation identifies the 4x100 wheel, and production hub/wheel records establish the 54.1 mm pilot and M12x1.5 nuts. This row represents the standard US NA configuration; special packages may differ. Sources: https://manuals.sucatisse.com/mx5-na/td/td-10 ; https://manuals.sucatisse.com/mx5-na/pi/1-c14 ; https://trull.org/alex/pubmirror/www.mellens.net/mazda/mazda_miata_extra_manual/1990_1997_supplement.pdf'
  ),
  (
    'Mazda', 'NA', 'M Edition', 1995, 1995,
    '1995 M Edition BBS package', 'US', true,
    '15x6 ET45', '15x6 ET45',
    '195/55R15 front / 195/55R15 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda Motor of America''s 1995 M Edition brochure specifies 15-inch BBS wheels with P195/55R15 tires. Mazda parts documentation identifies the BBS wheel as 15x6, while the OE wheel specification is ET45 with 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. Sources: https://xr793.com/wp-content/uploads/2020/02/1995-Mazda-MX-5-Miata-M-Edition.pdf ; https://trull.org/alex/pubmirror/www.mellens.net/mazda/mazda_miata_extra_manual/1990_1997_supplement.pdf'
  ),
  (
    'Mazda', 'NA', 'M Edition', 1994, 1994,
    '1994 M Edition polished seven-spoke package', 'US', false,
    '14x6 ET45', '14x6 ET45',
    '185/60R14 front / 185/60R14 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda accessory and factory parts documentation identifies the polished 1994 M Edition seven-spoke wheel as 14x6; the NA factory wheel specification uses ET45 with 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. The matching US tire is 185/60R14. Sources: https://trull.org/alex/pubmirror/www.mellens.net/mazda/mazda_miata_extra_manual/1990_1997_supplement.pdf ; https://manuals.plus/m/feb0fc53ecf413ee1ff95d4f87552b3614394259ae20321b07e07743123b361b.pdf'
  ),
  (
    'Mazda', 'NA', 'M Edition', 1996, 1997,
    '1996-1997 M Edition 15-inch package', 'US', false,
    '15x6 ET45', '15x6 ET45',
    '195/50R15 front / 195/50R15 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda factory brochures and parts documentation specify 15x6 wheels and 195/50R15 tires for the 1996-1997 M Edition (five-spoke in 1996 and chrome six-spoke in 1997). The OE wheel specification is ET45 with 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. Sources: https://importarchive.com/mazda/miata/1990-1997 ; https://trull.org/alex/pubmirror/www.mellens.net/mazda/mazda_miata_extra_manual/1990_1997_supplement.pdf'
  ),
  (
    'Mazda', 'NB', 'Base', 2001, 2005,
    'Standard 15-inch factory setup', 'US', true,
    '15x6 ET40', '15x6 ET40',
    '195/50R15 front / 195/50R15 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda factory workshop specifications publish a 15x6JJ wheel at 40 mm offset with a 195/50R15 tire. Mazda wheel/hub service data establishes 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. This row represents the standard later-NB 15-inch package; optional 16-inch packages differ. Sources: https://www.mellens.net/mazda/Mazda-Miata-1999-2001.pdf ; https://miatatorque.com/spec/standard-wheel-tire-dimensions-non-turbo-2004/'
  ),
  (
    'Mazda', 'NB', 'Base', 1999, 2000,
    'Early standard 14-inch factory setup', 'US', false,
    '14x6 ET40', '14x6 ET40',
    '185/60R14 front / 185/60R14 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda factory workshop specifications identify the early NB 14x6 wheel at 40 mm offset with 185/60R14 tires. Mazda service data establishes 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. Sources: https://www.mellens.net/mazda/Mazda-Miata-1999-2001.pdf ; https://mx-5nb.com/wp-content/uploads/2020/11/NB_collision_guidepdf.pdf'
  ),
  (
    'Mazda', 'NB', 'Mazdaspeed', 2004, 2005,
    'MAZDASPEED Racing Hart factory setup', 'US', true,
    '17x7 ET40', '17x7 ET40',
    '205/40R17 front / 205/40R17 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda North American Operations specifications publish 17x7 Racing Hart wheels and Toyo P205/40R17 tires for the MAZDASPEED MX-5. Mazda factory wheel/service records specify ET40, 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. US-market years: 2004-2005. Sources: https://news.mazdausa.com/download/04-MS-MX-5-Miata-Spec-Sheet.pdf ; https://news.mazdausa.com/download/cur_mspeed_specs.pdf'
  ),
  (
    'Mazda', 'NC', 'Sport', 2012, 2015,
    'Late Sport 16-inch factory setup', 'US', true,
    '16x6.5 ET55', '16x6.5 ET55',
    '205/50R16 front / 205/50R16 rear',
    '5x114.3', '67.1mm', 'verified',
    'Mazda US 2012 and 2015 specifications publish the Sport 16x6.5 wheel with 205/50R16 tires. Mazda factory service and parts data specify ET55 and 5x114.3 mounting; production hub data establishes the 67.1 mm pilot and M12x1.5 nuts. Sources: https://news.mazdausa.com/download/2012-MX-5-Miata-Specificiations.pdf ; https://news.mazdausa.com/download/2015-Mazda-MX-5-Specifications.pdf ; https://ncmiata-servicemanual.com/src/g5w02/html/id025000800100.html'
  ),
  (
    'Mazda', 'NC', 'Sport', 2006, 2006,
    'Launch-year Sport 17-inch factory setup', 'US', false,
    '17x7 ET55', '17x7 ET55',
    '205/45R17 front / 205/45R17 rear',
    '5x114.3', '67.1mm', 'verified',
    'Mazda US 2006 technical specifications place the Sport trim on 17x7 wheels with 205/45R17 tires. Mazda factory service and parts data specify ET55 and 5x114.3 mounting; production hub data establishes the 67.1 mm pilot and M12x1.5 nuts. Sources: https://news.mazdausa.com/download/SPECS-MX5-06.pdf ; https://ncmiata-servicemanual.com/src/g5w02/html/id025000800100.html ; https://partsouq.com/en/catalog/genuine/diagram?c=MAZDA2020&number=9965457070'
  ),
  (
    'Mazda', 'NC', 'Grand Touring', 2006, 2015,
    'Grand Touring 17-inch factory setup', 'US', true,
    '17x7 ET55', '17x7 ET55',
    '205/45R17 front / 205/45R17 rear',
    '5x114.3', '67.1mm', 'verified',
    'Mazda US 2006 and 2015 specifications publish Grand Touring 17x7 wheels with 205/45R17 tires. Mazda factory service and parts data specify ET55 and 5x114.3 mounting; production hub data establishes the 67.1 mm pilot and M12x1.5 nuts. Sources: https://news.mazdausa.com/download/SPECS-MX5-06.pdf ; https://news.mazdausa.com/download/2015-Mazda-MX-5-Specifications.pdf ; https://ncmiata-servicemanual.com/src/g5w02/html/id025000800100.html'
  ),
  (
    'Mazda', 'ND', 'Sport', 2016, null,
    'Sport 16-inch factory setup', 'US', true,
    '16x6.5 ET45', '16x6.5 ET45',
    '195/50R16 front / 195/50R16 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda US specifications publish the Sport 16x6.5 wheel with 195/50R16 tires. Mazda OE wheel approval and service documentation specify ET45, 4x100 mounting, a 54.1 mm pilot, and M12x1.5 nuts. Sources: https://news.mazdausa.com/download/2016-Mazda-MX-5-Spec-Deck.pdf ; https://owners-manual.mazda.com/gen/en/mx-5/mx-5_8gg1ee17j/contents/10020109.html'
  ),
  (
    'Mazda', 'ND', 'Club', 2016, null,
    'Club 17-inch factory setup', 'US', true,
    '17x7 ET45', '17x7 ET45',
    '205/45R17 front / 205/45R17 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda US specifications publish the Club 17x7 wheel with 205/45R17 tires. Mazda explicitly specifies 17x7J ET45 for the OE BBS Club wheel; OE approval documentation establishes 4x100 mounting and the 54.1 mm pilot with M12x1.5 nuts. Sources: https://news.mazdausa.com/download/2016-Mazda-MX-5-Spec-Deck.pdf ; https://news.mazdausa.com/2015-02-12-mazda-unveils-2016-mx-5-miata-accessories-concept-design-chicago-auto-show ; https://cdn.webshopapp.com/shops/22930/files/396249381/tuev.pdf'
  ),
  (
    'Mazda', 'ND', 'Grand Touring', 2016, null,
    'Grand Touring 17-inch factory setup', 'US', true,
    '17x7 ET45', '17x7 ET45',
    '205/45R17 front / 205/45R17 rear',
    '4x100', '54.1mm', 'verified',
    'Mazda US specifications publish the Grand Touring 17x7 wheel with 205/45R17 tires. Mazda OE wheel approval documentation specifies ET45 and 4x100 mounting; production hub data establishes the 54.1 mm pilot and M12x1.5 nuts. Sources: https://news.mazdausa.com/download/2016-Mazda-MX-5-Spec-Deck.pdf ; https://cdn.webshopapp.com/shops/22930/files/396249381/tuev.pdf ; https://owners-manual.mazda.com/gen/en/mx-5/mx-5_8gg1ee17j/contents/10020109.html'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Mazda'
  and existing.model in ('NA', 'NB', 'NC', 'ND')
  and existing.trim in ('Base', 'M Edition', 'Mazdaspeed', 'Sport', 'Club', 'Grand Touring');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from mazda_mx5_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Mazda' and active
order by model, trim, is_default desc, year_start;
