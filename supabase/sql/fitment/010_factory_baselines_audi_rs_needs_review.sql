-- Initial Audi RS factory baseline candidate pack.
--
-- These rows are intentionally marked needs_review. They are copied from the
-- current Audi RS OEM+ preset values so the app has a stable baseline source
-- instead of inferring baselines from recommendation rows. Verify each row
-- against Audi ETKA, Monroney/window-sticker data, owner documentation, or
-- another OEM-grade source before changing source_status to verified.

update public.fitment_presets
set center_bore = '66.6mm'
where make = 'Audi'
  and active = true
  and center_bore = '66.6';

create temp table if not exists audi_rs_baseline_rows (
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

truncate table audi_rs_baseline_rows;

insert into audi_rs_baseline_rows (
  make,
  model,
  trim,
  year_start,
  year_end,
  package_name,
  market,
  is_default,
  front,
  rear,
  tire,
  bolt_pattern,
  center_bore,
  source_status,
  source_note
)
select distinct on (fp.make, fp.model, fp.trim)
  fp.make,
  fp.model,
  fp.trim,
  null::int as year_start,
  null::int as year_end,
  'Current OEM+ preset baseline candidate' as package_name,
  'US' as market,
  true as is_default,
  replace(replace(fp.front, ' +', ' ET'), ' -', ' ET-') as front,
  replace(replace(fp.rear, ' +', ' ET'), ' -', ' ET-') as rear,
  case
    when fp.front_tire = fp.rear_tire
      then fp.front_tire || ' front / ' || fp.rear_tire || ' rear'
    else fp.front_tire || ' front / ' || fp.rear_tire || ' rear'
  end as tire,
  fp.bolt_pattern,
  case
    when lower(fp.center_bore) like '%mm' then fp.center_bore
    else fp.center_bore || 'mm'
  end as center_bore,
  'needs_review' as source_status,
  'Initial Audi RS baseline candidate copied from the current OEM+ preset row. Verify against Audi ETKA/window sticker before marking verified.' as source_note
from public.fitment_presets fp
where fp.make = 'Audi'
  and fp.active = true
  and fp.style = 'oemplus'
  and fp.trim in (
    'TT RS',
    'RS3',
    'RS4',
    'RS5',
    'RS5 Coupe',
    'RS5 Sportback',
    'RS6 Avant',
    'RS7'
  )
order by fp.make, fp.model, fp.trim, fp.sort_order;

update public.fitment_factory_baselines existing
set
  front = br.front,
  rear = br.rear,
  tire = br.tire,
  bolt_pattern = br.bolt_pattern,
  center_bore = br.center_bore,
  source_status = br.source_status,
  source_note = br.source_note,
  updated_at = now()
from audi_rs_baseline_rows br
where existing.make = br.make
  and existing.model = br.model
  and existing.trim = br.trim
  and existing.market = br.market
  and coalesce(existing.year_start, 0) = coalesce(br.year_start, 0)
  and coalesce(existing.year_end, 9999) = coalesce(br.year_end, 9999)
  and coalesce(existing.package_name, 'Default') = coalesce(br.package_name, 'Default')
  and existing.active = true
  and existing.source_status <> 'verified';

update public.fitment_factory_baselines existing
set
  active = false,
  updated_at = now()
from audi_rs_baseline_rows br
where br.is_default = true
  and existing.make = br.make
  and existing.model = br.model
  and existing.trim = br.trim
  and existing.market = br.market
  and existing.is_default = true
  and existing.active = true
  and existing.source_status <> 'verified'
  and (
    coalesce(existing.year_start, 0) <> coalesce(br.year_start, 0)
    or coalesce(existing.year_end, 9999) <> coalesce(br.year_end, 9999)
    or coalesce(existing.package_name, 'Default') <> coalesce(br.package_name, 'Default')
  );

insert into public.fitment_factory_baselines (
  make,
  model,
  trim,
  year_start,
  year_end,
  package_name,
  market,
  is_default,
  front,
  rear,
  tire,
  bolt_pattern,
  center_bore,
  source_status,
  source_note
)
select
  br.make,
  br.model,
  br.trim,
  br.year_start,
  br.year_end,
  br.package_name,
  br.market,
  br.is_default,
  br.front,
  br.rear,
  br.tire,
  br.bolt_pattern,
  br.center_bore,
  br.source_status,
  br.source_note
from audi_rs_baseline_rows br
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = br.make
    and existing.model = br.model
    and existing.trim = br.trim
    and existing.market = br.market
    and coalesce(existing.year_start, 0) = coalesce(br.year_start, 0)
    and coalesce(existing.year_end, 9999) = coalesce(br.year_end, 9999)
    and coalesce(existing.package_name, 'Default') = coalesce(br.package_name, 'Default')
    and existing.active = true
)
and not (
  br.is_default = true
  and exists (
    select 1
    from public.fitment_factory_baselines existing_default
    where existing_default.make = br.make
      and existing_default.model = br.model
      and existing_default.trim = br.trim
      and existing_default.market = br.market
      and existing_default.is_default = true
      and existing_default.active = true
  )
);
