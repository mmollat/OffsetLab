-- Offset Lab Fitment
-- Pack 029: keep OEM+ recommendations distinct from verified factory baselines.
--
-- These are conservative aftermarket recommendations, not factory data.
-- They replace exact OEM duplicates found after the verified-baseline audit.

update public.fitment_presets
set front = '19x9.5 ET18', rear = '20x10.5 ET18',
  front_tire = '275/35R19', rear_tire = '285/30R20',
  subtitle = case
    when trim = 'M4 Competition xDrive' then 'Subtle AWD-safe factory-plus stance'
    else 'Subtle factory-plus stance'
  end,
  poke_front = '2mm farther outward than factory',
  poke_rear = '2mm farther outward than factory',
  inner_front = '2mm more inner clearance than factory',
  inner_rear = '2mm more inner clearance than factory',
  verdict = 'A restrained OEM+ change that preserves factory wheel and tire sizing while moving both axles 2mm outward.',
  alternate = '20x10 ET18 front and 20x11 ET18 rear with 285/30R20 and 305/30R20 for the fuller Flush setup.'
where make = 'BMW' and model = 'G82'
  and trim in ('M4 Competition', 'M4 Competition xDrive')
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '17x7 +55', rear = '17x8.5 +65',
  front_tire = '215/45R17', rear_tire = '245/40R17',
  subtitle = 'AP2-size factory-plus upgrade for the AP1',
  poke_front = 'Slightly fuller than the AP1 factory wheel',
  poke_rear = 'Slightly fuller than the AP1 factory wheel',
  inner_front = 'Factory-like high-offset clearance',
  inner_rear = 'Factory-like high-offset clearance',
  verdict = 'A subtle AP1 upgrade using AP2-size 17-inch geometry while retaining conservative Honda offsets.',
  alternate = '17x7.5 +48 front and 17x9 +55 rear for the more assertive Flush setup.'
where make = 'Honda' and model = 'AP1' and trim = 'Base'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '17x7.5 +50', rear = '17x8.5 +60',
  front_tire = '215/45R17', rear_tire = '245/40R17',
  subtitle = 'Slightly wider, slightly fuller AP2 fitment',
  poke_front = 'About 11mm farther outward than factory',
  poke_rear = 'About 5mm farther outward than factory',
  inner_front = 'About 1mm less inner clearance than factory',
  inner_rear = 'About 5mm more inner clearance than factory',
  verdict = 'A conservative OEM+ AP2 setup with a half-inch wider front wheel and modestly fuller offsets.',
  alternate = '17x8 +50 front and 17x9 +50 rear with 225/45R17 and 255/40R17 for the Flush setup.'
where make = 'Honda' and model = 'AP2' and trim = 'Base'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '17x7.5 +50', rear = '17x9 +60',
  front_tire = '215/45R17', rear_tire = '255/40R17',
  subtitle = 'Slightly wider, slightly fuller CR fitment',
  poke_front = 'About 11mm farther outward than factory',
  poke_rear = 'About 11mm farther outward than factory',
  inner_front = 'About 1mm less inner clearance than factory',
  inner_rear = 'About 1mm less inner clearance than factory',
  verdict = 'A restrained CR upgrade that adds a half inch of wheel width at both axles without jumping to the Flush setup.',
  alternate = '17x8 +50 front and 17x9 +50 rear with 225/45R17 and 255/40R17 for the Flush setup.'
where make = 'Honda' and model = 'AP2' and trim = 'CR'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x9.5 +45', rear = '20x9.5 +45',
  front_tire = '275/40R20', rear_tire = '275/40R20',
  subtitle = 'Factory-diameter 20-inch performance setup',
  poke_front = 'Factory-like wheel position',
  poke_rear = 'Factory-like wheel position',
  inner_front = 'Factory-like inner clearance',
  inner_rear = 'Factory-like inner clearance',
  diameter = '20 inch',
  verdict = 'A practical OEM+ downsizing that preserves overall tire diameter while adding sidewall and reducing 21-inch wheel mass.',
  alternate = '21x10 +42 with 285/35R21 for the fuller Flush setup.'
where make = 'Hyundai' and model = 'NE' and trim = 'Ioniq 5 N'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '17x7.5 +40', rear = '17x7.5 +40',
  front_tire = '205/45R17', rear_tire = '205/45R17',
  subtitle = 'Subtle factory-plus width and stance',
  poke_front = 'About 11mm farther outward than factory',
  poke_rear = 'About 11mm farther outward than factory',
  inner_front = 'About 1mm less inner clearance than factory',
  inner_rear = 'About 1mm less inner clearance than factory',
  verdict = 'A true OEM+ ND setup: half an inch wider with a modest 5mm offset change and the stock tire size.',
  alternate = '17x8 +38 with 215/45R17 for a slightly safer version of the Flush setup.'
where make = 'Mazda' and model = 'ND'
  and trim in ('Club', 'Grand Touring')
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x9.5 ET44', rear = '21x12 ET43',
  front_tire = '255/35R20', rear_tire = '315/30R21',
  subtitle = 'Subtle factory-plus GT3 stance',
  poke_front = '2mm farther outward than factory',
  poke_rear = '2mm farther outward than factory',
  inner_front = '2mm more inner clearance than factory',
  inner_rear = '2mm more inner clearance than factory',
  verdict = 'A deliberately subtle GT3 OEM+ setup that retains factory wheel and tire sizing while moving each axle 2mm outward.',
  alternate = '20x10 ET44 front and 21x12 ET44 rear for a wider but still conservative setup.'
where make = 'Porsche' and model = '992' and trim = 'GT3'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '17x7 +4', rear = '17x7 +4',
  front_tire = '265/70R17', rear_tire = '265/70R17',
  subtitle = 'TRD Pro-style factory-plus 4Runner stance',
  poke_front = 'About 5mm farther outward than TRD Off-Road factory',
  poke_rear = 'About 5mm farther outward than TRD Off-Road factory',
  inner_front = 'About 17mm more inner clearance than factory',
  inner_rear = 'About 17mm more inner clearance than factory',
  verdict = 'A mild OEM+ 4Runner setup using TRD Pro-style wheel geometry with the factory 265/70R17 tire size.',
  alternate = '17x8.5 0 with 285/70R17 for the more capable Trail setup.'
where make = 'Toyota' and model = '5th Gen' and trim = 'TRD Off-Road'
  and style = 'oemplus' and active is not false;

select make, model, trim, front, rear, front_tire, rear_tire, subtitle
from public.fitment_presets
where active is not false and style = 'oemplus'
  and (make, model, trim) in (
    ('BMW', 'G82', 'M4 Competition'),
    ('BMW', 'G82', 'M4 Competition xDrive'),
    ('Honda', 'AP1', 'Base'),
    ('Honda', 'AP2', 'Base'),
    ('Honda', 'AP2', 'CR'),
    ('Hyundai', 'NE', 'Ioniq 5 N'),
    ('Mazda', 'ND', 'Club'),
    ('Mazda', 'ND', 'Grand Touring'),
    ('Porsche', '992', 'GT3'),
    ('Toyota', '5th Gen', 'TRD Off-Road')
  )
order by make, model, trim;
