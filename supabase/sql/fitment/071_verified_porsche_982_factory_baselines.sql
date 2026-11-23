-- Offset Lab Fitment
-- Pack 071: verified Porsche 982 718 Cayman factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='982 718 Cayman',year_start=2017,year_end=2025
where make='Porsche' and model='982';

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='18x8 ET57',factory_rear='18x9.5 ET49',
    factory_tire='235/45R18 front / 265/45R18 rear'
where make='Porsche' and model='982' and trim='718 Cayman Base'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='19x8 ET57',factory_rear='19x10 ET45',
    factory_tire='235/40R19 front / 265/40R19 rear'
where make='Porsche' and model='982' and trim='718 Cayman S'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='20x8.5 ET57',factory_rear='20x10.5 ET47',
    factory_tire='235/35R20 front / 265/35R20 rear'
where make='Porsche' and model='982' and trim='718 Cayman GTS 4.0'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='20x8.5 ET61',factory_rear='20x11 ET50',
    factory_tire='245/35R20 front / 295/30R20 rear'
where make='Porsche' and model='982' and trim='718 Cayman GT4'
  and active is not false;

create temp table if not exists porsche_982_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table porsche_982_verified_baselines;

insert into porsche_982_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Porsche','982','718 Cayman Base',2017,2025,
 '718 Cayman standard 18-inch package','US',true,
 '18x8 ET57','18x9.5 ET49','235/45R18 front / 265/45R18 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 718 Cayman technical data specifies 18x8J ET57 front and 18x9.5J ET49 rear wheels with 235/45ZR18 and 265/45ZR18 tires. Porsche service specifications identify 5x130, a 71.6 mm hub and M14x1.5 R14 ball-seat wheel bolts. Source: https://newsroom.porsche.com/dam/jcr%3A2e05fcd8-e8ce-4b60-8611-9ce844a8242e/PCNA18_1003_us.pdf.PDF'),
('Porsche','982','718 Cayman S',2017,2025,
 '718 Cayman S standard 19-inch package','US',true,
 '19x8 ET57','19x10 ET45','235/40R19 front / 265/40R19 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 718 Cayman S technical data specifies 19x8J ET57 front and 19x10J ET45 rear wheels with 235/40ZR19 and 265/40ZR19 tires. Porsche service specifications identify 5x130, a 71.6 mm hub and M14x1.5 R14 ball-seat wheel bolts. Source: https://newsroom.porsche.com/dam/jcr%3A2e05fcd8-e8ce-4b60-8611-9ce844a8242e/PCNA18_1003_us.pdf.PDF'),
('Porsche','982','718 Cayman GTS 4.0',2020,2025,
 '718 Cayman GTS 4.0 standard 20-inch package','US',true,
 '20x8.5 ET57','20x10.5 ET47','235/35R20 front / 265/35R20 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 718 Cayman GTS 4.0 technical data specifies 20x8.5J ET57 front and 20x10.5J ET47 rear wheels with 235/35ZR20 and 265/35ZR20 tires. Porsche service specifications identify 5x130, a 71.6 mm hub and M14x1.5 R14 ball-seat wheel bolts. Source: https://newsroom.porsche.com/dam/jcr%3A5d1b4e09-a439-4c4f-880c-a0faae55c450/718%20Boxster%20GTS%204.0%20and%20718%20Cayman%20GTS%204.0%20US%20technical%20specifications_.pdf'),
('Porsche','982','718 Cayman GT4',2020,2023,
 '718 Cayman GT4 standard 20-inch package','US',true,
 '20x8.5 ET61','20x11 ET50','245/35R20 front / 295/30R20 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 718 Cayman GT4 technical data specifies 20x8.5J ET61 front and 20x11J ET50 rear wheels with 245/35ZR20 and 295/30ZR20 UHP tires. Porsche service specifications identify 5x130, a 71.6 mm hub and M14x1.5 R14 ball-seat wheel bolts. Source: https://pnr-prd2-pub2.newsroom.porsche.com/dam/jcr%3A9d46f6de-fbb6-42d8-b474-7295ec4e7e96/PAG_718_Cayman_GT4_EN.pdf');

delete from public.fitment_factory_baselines
where make='Porsche' and model='982';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from porsche_982_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Porsche' and model='982' and active
order by trim;
