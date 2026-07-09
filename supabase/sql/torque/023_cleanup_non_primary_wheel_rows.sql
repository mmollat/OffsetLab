-- Offset Lab Torque Hub
-- Pack 023: remove non-primary wheel rows from active wheel torque cards.
--
-- Plain SQL only. Safe to re-run.
-- Pack 022 removed duplicate generic wheel placeholders. This pass removes
-- rows that are not primary lug nut/bolt service specs when a generation
-- already has a normal lug row:
-- - generic "Wheel Fastener" donor rows
-- - spacer / adapter bolt rows
--
-- Conflicting wheel torque values are intentionally left in place for source
-- verification rather than guessing which value is correct.

with wheel_category as (
  select id
  from public.torque_categories
  where slug = 'wheels'
),
primary_lug_generations as (
  select distinct spec.generation_id
  from public.torque_specs spec
  join wheel_category category
    on category.id = spec.category_id
  where (
    lower(spec.fastener) like '%lug nut%'
    or lower(spec.fastener) like '%lug bolt%'
    or lower(spec.fastener) like '%wheel bolt%'
  )
    and lower(spec.fastener) not like '%spacer%'
    and lower(spec.fastener) not like '%adapter%'
    and lower(spec.component) not like '%spacer%'
    and lower(spec.component) not like '%adapter%'
),
non_primary_wheel_rows as (
  select spec.id
  from public.torque_specs spec
  join wheel_category category
    on category.id = spec.category_id
  join primary_lug_generations primary_generation
    on primary_generation.generation_id = spec.generation_id
  where spec.source_status in ('community', 'needs_review')
    and (
      lower(trim(spec.fastener)) = lower('Wheel Fastener')
      or lower(spec.fastener) like '%spacer%'
      or lower(spec.fastener) like '%adapter%'
      or lower(spec.component) like '%spacer%'
      or lower(spec.component) like '%adapter%'
    )
)
delete from public.torque_specs spec
using non_primary_wheel_rows non_primary
where spec.id = non_primary.id;
