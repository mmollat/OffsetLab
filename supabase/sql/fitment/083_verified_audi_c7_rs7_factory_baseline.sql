-- Offset Lab Fitment
-- Pack 083: verified Audi C7/C7.5 RS 7 factory baseline.
-- Separates the former factory-identical OEM+ preset from the true baseline.
-- Plain SQL only and safe to re-run.

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9 ET35',factory_rear='20x9 ET35',
    factory_tire='275/35R20 square'
where make='Audi' and model='C7' and trim='RS7'
  and active is not false;

update public.fitment_presets
set front='20x9.5 +30',rear='20x9.5 +30',
    front_tire='285/35R20',rear_tire='285/35R20'
where make='Audi' and model='C7' and trim='RS7' and style='oemplus'
  and active is not false;

create temp table if not exists audi_c7_rs7_verified_baseline (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_c7_rs7_verified_baseline;

insert into audi_c7_rs7_verified_baseline
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','C7','RS7',2014,2018,'RS 7 standard 20-inch production package','North America/Europe',true,
 '20x9 ET35','20x9 ET35','275/35R20 square','5x112','66.6mm','verified',
 'Audi of America model-year service documentation identifies the C7 RS 7 production tire package as 275/35 R20 on both axles. Audi original forged wheel part 4G8 601 025 BA establishes the RS 7 application geometry as 9Jx20 ET35. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://static.nhtsa.gov/odi/tsbs/2014/MC-10216606-9999.pdf ; https://www.deutsche-parts.co.uk/4g8601025ba-alloy-wheel-9jx20-audi-rs7-2014-2018-new-genuine-part.html');

delete from public.fitment_factory_baselines
where make='Audi' and model='C7' and trim='RS7';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_c7_rs7_verified_baseline;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='C7' and trim='RS7' and active
order by is_default desc,year_start;
