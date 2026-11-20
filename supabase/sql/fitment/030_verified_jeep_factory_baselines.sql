-- Offset Lab Fitment
-- Pack 030: verified US-market Jeep JK, JL, and JT factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Combined trim selectors are split because Sport/Sahara, Sport/Overland,
-- and Rubicon/Mojave do not share the same factory wheel specification.

update public.vehicle_models set year_start = 2007, year_end = 2018
where make = 'Jeep' and model = 'JK';

update public.vehicle_models set year_start = 2018, year_end = null
where make = 'Jeep' and model = 'JL';

update public.vehicle_models set year_start = 2020, year_end = null
where make = 'Jeep' and model = 'JT';

update public.vehicle_trims set active = false
where make = 'Jeep' and (
  (model = 'JK' and trim = 'Sport / Sahara') or
  (model = 'JL' and trim = 'Sport / Sahara') or
  (model = 'JT' and trim in ('Sport / Overland', 'Rubicon / Mojave'))
);

insert into public.vehicle_trims (make, model, trim, display_name, active, sort_order)
select 'Jeep', source.model, source.trim, source.trim, true, source.sort_order
from (values
  ('JK', 'Sport', 1500), ('JK', 'Sahara', 1501),
  ('JL', 'Sport', 1510), ('JL', 'Sahara', 1511),
  ('JT', 'Sport', 1520), ('JT', 'Overland', 1521),
  ('JT', 'Rubicon', 1522), ('JT', 'Mojave', 1523)
) as source(model, trim, sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make = 'Jeep' and existing.model = source.model
    and existing.trim = source.trim
);

update public.vehicle_trims
set active = true,
    display_name = trim,
    sort_order = case
      when model = 'JK' and trim = 'Sport' then 1500
      when model = 'JK' and trim = 'Sahara' then 1501
      when model = 'JK' and trim = 'Rubicon' then 1502
      when model = 'JL' and trim = 'Sport' then 1510
      when model = 'JL' and trim = 'Sahara' then 1511
      when model = 'JL' and trim = 'Rubicon' then 1512
      when model = 'JL' and trim = '392 Rubicon' then 1513
      when model = 'JT' and trim = 'Sport' then 1520
      when model = 'JT' and trim = 'Overland' then 1521
      when model = 'JT' and trim = 'Rubicon' then 1522
      when model = 'JT' and trim = 'Mojave' then 1523
    end
where make = 'Jeep' and trim in
  ('Sport', 'Sahara', 'Rubicon', '392 Rubicon', 'Overland', 'Mojave');

-- Preserve the existing aftermarket recommendations while separating trims.
insert into public.fitment_presets (
  make, model, trim, style, title, subtitle, front, rear, front_tire, rear_tire,
  poke_front, poke_rear, inner_front, inner_rear, diameter, aggression, daily,
  risk, verdict, warnings, alternate, active, sort_order, bolt_pattern,
  center_bore, factory_front, factory_rear, factory_tire
)
select source.make, source.model, target.trim, source.style, source.title,
  source.subtitle, source.front, source.rear, source.front_tire, source.rear_tire,
  source.poke_front, source.poke_rear, source.inner_front, source.inner_rear,
  source.diameter, source.aggression, source.daily, source.risk, source.verdict,
  source.warnings, source.alternate, true, source.sort_order, source.bolt_pattern,
  source.center_bore, null, null, null
from public.fitment_presets source
join (values
  ('JK', 'Sport / Sahara', 'Sport'), ('JK', 'Sport / Sahara', 'Sahara'),
  ('JL', 'Sport / Sahara', 'Sport'), ('JL', 'Sport / Sahara', 'Sahara'),
  ('JT', 'Sport / Overland', 'Sport'), ('JT', 'Sport / Overland', 'Overland'),
  ('JT', 'Rubicon / Mojave', 'Rubicon'), ('JT', 'Rubicon / Mojave', 'Mojave')
) as target(model, source_trim, trim)
  on target.model = source.model and target.source_trim = source.trim
where source.make = 'Jeep' and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make = source.make and existing.model = source.model
      and existing.trim = target.trim and existing.style = source.style
  );

update public.fitment_presets set active = false
where make = 'Jeep' and (
  (model in ('JK', 'JL') and trim = 'Sport / Sahara') or
  (model = 'JT' and trim in ('Sport / Overland', 'Rubicon / Mojave'))
);

update public.fitment_presets
set bolt_pattern = '5x127', center_bore = '71.5mm',
  factory_front = case
    when model = 'JK' and trim = 'Sport' then '16x7 ET44.45'
    when model = 'JK' and trim in ('Sahara', 'Rubicon') then
      case when trim = 'Sahara' then '18x7.5 ET44.45' else '17x7.5 ET44.45' end
    when model = 'JL' and trim = 'Sahara' then '18x7.5 ET44.45'
    when model = 'JL' and trim = '392 Rubicon' then '17x8 ET12'
    when model in ('JL', 'JT') then
      case when model = 'JT' and trim = 'Overland' then '18x7.5 ET44.45'
           when model = 'JT' and trim = 'Mojave' then '17x7.5 ET37.17'
           else '17x7.5 ET44.45' end
  end,
  factory_rear = case
    when model = 'JK' and trim = 'Sport' then '16x7 ET44.45'
    when model = 'JK' and trim in ('Sahara', 'Rubicon') then
      case when trim = 'Sahara' then '18x7.5 ET44.45' else '17x7.5 ET44.45' end
    when model = 'JL' and trim = 'Sahara' then '18x7.5 ET44.45'
    when model = 'JL' and trim = '392 Rubicon' then '17x8 ET12'
    when model in ('JL', 'JT') then
      case when model = 'JT' and trim = 'Overland' then '18x7.5 ET44.45'
           when model = 'JT' and trim = 'Mojave' then '17x7.5 ET37.17'
           else '17x7.5 ET44.45' end
  end,
  factory_tire = case
    when model = 'JK' and trim = 'Sport' then '225/75R16 front / 225/75R16 rear'
    when model = 'JK' and trim = 'Sahara' then '255/70R18 front / 255/70R18 rear'
    when model = 'JK' and trim = 'Rubicon' then '255/75R17 front / 255/75R17 rear'
    when model = 'JL' and trim = 'Sport' then '245/75R17 front / 245/75R17 rear'
    when model = 'JL' and trim = 'Sahara' then '255/70R18 front / 255/70R18 rear'
    when model = 'JL' and trim = 'Rubicon' then '285/70R17 front / 285/70R17 rear'
    when model = 'JL' and trim = '392 Rubicon' then '315/70R17 front / 315/70R17 rear'
    when model = 'JT' and trim = 'Sport' then '245/75R17 front / 245/75R17 rear'
    when model = 'JT' and trim = 'Overland' then '255/70R18 front / 255/70R18 rear'
    when model = 'JT' and trim in ('Rubicon', 'Mojave') then '285/70R17 front / 285/70R17 rear'
  end
where make = 'Jeep' and active is not false;

-- A 2024+ 392 starts on 35-inch tires, so its OEM+ recommendation must not
-- downgrade it to the older 33-inch baseline.
update public.fitment_presets
set front = '17x8.5 +18', rear = '17x8.5 +18',
    front_tire = '315/70R17', rear_tire = '315/70R17'
where make = 'Jeep' and model = 'JL' and trim = '392 Rubicon'
  and style = 'oemplus' and active is not false;

create temp table if not exists jeep_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table jeep_verified_baselines;

insert into jeep_verified_baselines values
('Jeep','JK','Sport',2007,2018,'Sport 16-inch factory setup','US',true,
 '16x7 ET44.45','16x7 ET44.45','225/75R16 front / 225/75R16 rear','5x127','71.5mm','verified',
 'The 2018 Jeep Wrangler JK specification sheet lists P225/75R16 as standard on Sport. The official Mopar catalog for the 2018 JK Sport identifies the production 16x7 wheel as ET44.45 with 5x127 mounting; JK hardware uses 1/2-20 wheel nuts and a 71.5 mm hub pilot. Sources: https://www.fcapresskit.ca/2018/Contents/Text/PDFs/Jeep/Wrangler_JK/CN_2018_JP_Wrangler_JK_SP.pdf ; https://store.mopar.com/v-2018-jeep-wrangler-jk--unlimited-sport--3-6l-v6-gas/wheels--wheels-tires-and-hardware'),
('Jeep','JK','Sahara',2007,2018,'Sahara 18-inch factory setup','US',true,
 '18x7.5 ET44.45','18x7.5 ET44.45','255/70R18 front / 255/70R18 rear','5x127','71.5mm','verified',
 'Jeep''s 2018 JK specification sheet lists P255/70R18 as standard on Sahara. The official Mopar catalog identifies the JK production 18x7.5 wheel as ET44.45 with 5x127 mounting; JK hardware uses 1/2-20 wheel nuts and a 71.5 mm hub pilot. Sources: https://www.fcapresskit.ca/2018/Contents/Text/PDFs/Jeep/Wrangler_JK/CN_2018_JP_Wrangler_JK_SP.pdf ; https://store.mopar.com/v-2018-jeep-wrangler-jk--unlimited-sahara--3-6l-v6-gas/wheels--wheels-tires-and-hardware'),
('Jeep','JK','Rubicon',2007,2018,'Rubicon 17-inch factory setup','US',true,
 '17x7.5 ET44.45','17x7.5 ET44.45','255/75R17 front / 255/75R17 rear','5x127','71.5mm','verified',
 'Jeep''s 2018 JK publications specify the Rubicon 17-inch wheel with LT255/75R17 tires. The official Mopar JK catalog identifies the 17x7.5 production wheel as ET44.45 with 5x127 mounting; JK hardware uses 1/2-20 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2018JP_Wrangler_JK_SPfomog98ru906ulan5eg7d89s4s.pdf ; https://parts.moparonlineparts.com/v-2018-jeep-wrangler-jk--unlimited-sport--3-6l-v6-gas/wheels--wheels-tires-and-hardware'),
('Jeep','JL','Sport',2018,null,'Sport 17-inch factory setup','US',true,
 '17x7.5 ET44.45','17x7.5 ET44.45','245/75R17 front / 245/75R17 rear','5x127','71.5mm','verified',
 'The 2024 Jeep Wrangler specification sheet lists 17x7.5 wheels and P245/75R17 tires for Sport. Mopar production wheel 6SV82DD5AA confirms ET44.45 and 5x127; JL hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Wrangler_SP5fcgnuvfl399adn0lfjsosc427.pdf ; https://parts.moparonlineparts.com/oem-parts/mopar-wheel-17x7-5-6sv82dd5aa'),
('Jeep','JL','Sahara',2018,null,'Sahara 18-inch factory setup','US',true,
 '18x7.5 ET44.45','18x7.5 ET44.45','255/70R18 front / 255/70R18 rear','5x127','71.5mm','verified',
 'The 2024 Jeep Wrangler specification sheet lists 18x7.5 wheels and 255/70R18 tires for Sahara. Mopar production wheel 7AF472STAB confirms ET44.45 and 5x127; JL hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Wrangler_SP5fcgnuvfl399adn0lfjsosc427.pdf ; https://parts.moparonlineparts.com/oem-parts/mopar-wheel-18x7-5-7af472stab'),
('Jeep','JL','Rubicon',2018,null,'Rubicon 17-inch factory setup','US',true,
 '17x7.5 ET44.45','17x7.5 ET44.45','285/70R17 front / 285/70R17 rear','5x127','71.5mm','verified',
 'Jeep''s Wrangler specifications list 17x7.5 wheels and LT285/70R17 tires as standard on Rubicon. Mopar production wheel 6BZ391XFAB confirms ET44.45 and 5x127; JL hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Wrangler_SP5fcgnuvfl399adn0lfjsosc427.pdf ; https://parts.moparonlineparts.com/oem-parts/mopar-aluminum-wheel-6bz391xfab'),
('Jeep','JL','392 Rubicon',2024,null,'2024+ Rubicon 392 35-inch factory setup','US',true,
 '17x8 ET12','17x8 ET12','315/70R17 front / 315/70R17 rear','5x127','71.5mm','verified',
 'Jeep''s 2024 specification sheet makes the 17x8 beadlock-capable wheel and LT315/70R17 tire standard on Rubicon 392. Genuine Mopar wheel 68628321AA is the 2024+ 17x8 production wheel; OE interchange data specifies ET12, 5x127, and the 71.5 mm pilot. JL hardware uses M14x1.5 wheel nuts. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Wrangler_SP5fcgnuvfl399adn0lfjsosc427.pdf ; https://store.mopar.com/oem-parts/mopar-aluminum-wheel-68628321aa ; https://allusedrims.com/collections/taxes/products/afwrje512717m56-0134-jeep-wheels'),
('Jeep','JL','392 Rubicon',2021,2023,'2021-2023 Rubicon 392 33-inch factory setup','US',false,
 '17x7.5 ET44.45','17x7.5 ET44.45','285/70R17 front / 285/70R17 rear','5x127','71.5mm','verified',
 'Jeep''s 2022 Wrangler specification lists LT285/70R17C as standard on Rubicon 392. The official 2021 Rubicon 392 Mopar catalog identifies its 17x7.5 production wheel as ET44.45 with 5x127 mounting; JL hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2022_JP_Wrangler_SP.pdf ; https://store.mopar.com/v-2021-jeep-wrangler--unlimited-rubicon-392--6-4l-v8-gas/wheels--wheels-tires-and-hardware'),
('Jeep','JT','Sport',2020,null,'Sport 17-inch factory setup','US',true,
 '17x7.5 ET44.45','17x7.5 ET44.45','245/75R17 front / 245/75R17 rear','5x127','71.5mm','verified',
 'The 2024 Jeep Gladiator specification sheet lists 245/75R17 as standard on Sport. Genuine Mopar Gladiator wheel 4755290AA confirms 17x7.5, ET44.45, and 5x127; JT hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Gladiator_SPqsblublp94vcjnfthqnmb0dt0q.pdf ; https://parts.moparonlineparts.com/oem-parts/mopar-wheel-17x7-5-4755290aa'),
('Jeep','JT','Overland',2020,2023,'Overland 18-inch factory setup','US',true,
 '18x7.5 ET44.45','18x7.5 ET44.45','255/70R18 front / 255/70R18 rear','5x127','71.5mm','verified',
 'Jeep''s 2023 Gladiator fleet guide specifies the Overland 18-inch factory wheel and 255/70R18 tire. Mopar production-wheel records establish the 18x7.5 ET44.45 geometry and 5x127 mounting; JT hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://www.stellantisfleet.com/content/dam/fca-fleet/na/fleet/en_us/shopping-tools/brochures-literature/docs/23MY_FBG_Interactive_Q04_8.11.pdf ; https://parts.moparonlineparts.com/v-2022-jeep-gladiator--rubicon--3-6l-v6-gas/wheels--wheels-tires-and-hardware'),
('Jeep','JT','Rubicon',2020,null,'Rubicon 17-inch factory setup','US',true,
 '17x7.5 ET44.45','17x7.5 ET44.45','285/70R17 front / 285/70R17 rear','5x127','71.5mm','verified',
 'The 2024 Jeep Gladiator specification sheet lists LT285/70R17 as standard on Rubicon. Genuine Mopar Gladiator wheel 6KC871A7AA confirms 17x7.5 ET44.45 and 5x127; JT hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Gladiator_SPqsblublp94vcjnfthqnmb0dt0q.pdf ; https://parts.moparonlineparts.com/v-2022-jeep-gladiator--rubicon--3-6l-v6-gas/wheels--wheels-tires-and-hardware'),
('Jeep','JT','Mojave',2020,null,'Mojave 17-inch factory setup','US',true,
 '17x7.5 ET37.17','17x7.5 ET37.17','285/70R17 front / 285/70R17 rear','5x127','71.5mm','verified',
 'The 2024 Jeep Gladiator specification sheet lists LT285/70R17 as standard on Mojave. Genuine Mopar Mojave-family wheel 6PJ791XWAA confirms 17x7.5 ET37.17 and 5x127; JT hardware uses M14x1.5 wheel nuts and a 71.5 mm hub pilot. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2024_JP_Gladiator_SPqsblublp94vcjnfthqnmb0dt0q.pdf ; https://parts.moparonlineparts.com/oem-parts/mopar-wheel-17x7-5-6pj791xwaa');

delete from public.fitment_factory_baselines existing
where existing.make = 'Jeep' and existing.model in ('JK','JL','JT');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
from jeep_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front, rear,
  tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Jeep' and active
order by model, trim, is_default desc, year_start;
