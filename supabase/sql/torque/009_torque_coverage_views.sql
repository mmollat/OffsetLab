-- Offset Lab Torque Hub
-- Pack 009: coverage views for active fitment vehicles.
--
-- Plain SQL only. Safe to re-run.
-- These views make TorqueHub gaps visible without one-off scripts:
-- - torque_fitment_coverage: one row per active fitment vehicle
-- - torque_fitment_category_gaps: one row per missing category

create or replace view public.torque_fitment_coverage as
with fitment as (
  select
    vm.make,
    vm.model,
    coalesce(vm.display_name, vm.model) as display_name,
    case
      when coalesce(vm.display_name, vm.model) like '% - %'
        then nullif(trim(split_part(coalesce(vm.display_name, vm.model), ' - ', 2)), '')
      else coalesce(vm.display_name, vm.model)
    end as model_name,
    coalesce(vm.display_name, vm.model) as generation_name,
    vm.year_start,
    vm.year_end,
    trim(both '-' from regexp_replace(lower(vm.make), '[^a-z0-9]+', '-', 'g')) as make_slug,
    trim(both '-' from regexp_replace(lower(
      case
        when coalesce(vm.display_name, vm.model) like '% - %'
          then nullif(trim(split_part(coalesce(vm.display_name, vm.model), ' - ', 2)), '')
        else coalesce(vm.display_name, vm.model)
      end
    ), '[^a-z0-9]+', '-', 'g')) as model_slug,
    trim(both '-' from regexp_replace(lower(coalesce(vm.display_name, vm.model)), '[^a-z0-9]+', '-', 'g')) as generation_slug
  from public.vehicle_models vm
  where vm.active = true
),
trim_counts as (
  select
    make,
    model,
    count(distinct trim) as trim_count
  from public.vehicle_trims
  where active = true
  group by make, model
),
matched as (
  select
    f.*,
    coalesce(tc.trim_count, 0) as trim_count,
    make_row.id as torque_make_id,
    make_row.name as torque_make_name,
    model_row.id as torque_model_id,
    model_row.name as torque_model_name,
    generation_row.id as torque_generation_id,
    generation_row.name as torque_generation_name
  from fitment f
  left join trim_counts tc
    on tc.make = f.make
    and tc.model = f.model
  left join public.torque_vehicle_makes make_row
    on make_row.slug = f.make_slug
  left join public.torque_vehicle_models model_row
    on model_row.make_id = make_row.id
    and model_row.slug = f.model_slug
  left join public.torque_vehicle_generations generation_row
    on generation_row.model_id = model_row.id
    and generation_row.slug = f.generation_slug
),
category_specs as (
  select
    m.make,
    m.model,
    m.display_name,
    m.model_name,
    m.generation_name,
    m.year_start,
    m.year_end,
    m.trim_count,
    m.torque_make_id,
    m.torque_make_name,
    m.torque_model_id,
    m.torque_model_name,
    m.torque_generation_id,
    m.torque_generation_name,
    category.id as category_id,
    category.slug as category_slug,
    category.sort_order as category_sort_order,
    count(spec.id) as category_spec_count
  from matched m
  cross join public.torque_categories category
  left join public.torque_specs spec
    on spec.generation_id = m.torque_generation_id
    and spec.category_id = category.id
  group by
    m.make,
    m.model,
    m.display_name,
    m.model_name,
    m.generation_name,
    m.year_start,
    m.year_end,
    m.trim_count,
    m.torque_make_id,
    m.torque_make_name,
    m.torque_model_id,
    m.torque_model_name,
    m.torque_generation_id,
    m.torque_generation_name,
    category.id,
    category.slug,
    category.sort_order
)
select
  make,
  model,
  display_name,
  model_name,
  generation_name,
  year_start,
  year_end,
  trim_count,
  torque_make_id,
  torque_make_name,
  torque_model_id,
  torque_model_name,
  torque_generation_id,
  torque_generation_name,
  sum(category_spec_count)::int as spec_count,
  count(category_id)::int as category_count,
  count(category_id) filter (where category_spec_count > 0)::int as categories_present_count,
  count(category_id) filter (where category_spec_count = 0)::int as categories_missing_count,
  coalesce(
    array_agg(category_slug order by category_sort_order)
      filter (where category_spec_count > 0),
    '{}'::text[]
  ) as categories_present,
  coalesce(
    array_agg(category_slug order by category_sort_order)
      filter (where category_spec_count = 0),
    '{}'::text[]
  ) as categories_missing,
  case
    when torque_make_id is null then 'missing_make'
    when torque_model_id is null then 'missing_model'
    when torque_generation_id is null then 'missing_generation'
    when sum(category_spec_count) = 0 then 'missing_specs'
    when count(category_id) filter (where category_spec_count = 0) = 0 then 'complete'
    else 'partial'
  end as coverage_status
from category_specs
group by
  make,
  model,
  display_name,
  model_name,
  generation_name,
  year_start,
  year_end,
  trim_count,
  torque_make_id,
  torque_make_name,
  torque_model_id,
  torque_model_name,
  torque_generation_id,
  torque_generation_name
order by make, model;

comment on view public.torque_fitment_coverage is
  'TorqueHub coverage summary for active fitment vehicles, including missing torque categories.';

create or replace view public.torque_fitment_category_gaps as
select
  coverage.make,
  coverage.model,
  coverage.display_name,
  coverage.model_name,
  coverage.generation_name,
  coverage.trim_count,
  coverage.torque_generation_id,
  coverage.torque_generation_name,
  missing_category.slug as missing_category,
  missing_category.name as missing_category_name,
  missing_category.sort_order as missing_category_sort_order,
  coverage.spec_count,
  coverage.categories_present,
  coverage.coverage_status
from public.torque_fitment_coverage coverage
cross join lateral unnest(coverage.categories_missing) as missing(slug)
join public.torque_categories missing_category
  on missing_category.slug = missing.slug
where coverage.coverage_status <> 'complete'
order by
  coverage.make,
  coverage.model,
  missing_category.sort_order;

comment on view public.torque_fitment_category_gaps is
  'One row per missing TorqueHub category for active fitment vehicles.';

grant select on public.torque_fitment_coverage to anon, authenticated;
grant select on public.torque_fitment_category_gaps to anon, authenticated;
