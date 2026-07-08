-- Offset Lab Torque Hub
-- Pack 022: remove redundant wheel placeholder rows.
--
-- Plain SQL only. Safe to re-run.
-- Keeps category coverage intact while removing duplicate/confusing wheel cards:
-- 1. Delete generic Wheels lug placeholder rows when the same generation has a
--    more specific lug nut/bolt row with the same Nm value.
-- 2. Collapse remaining duplicate wheel-fastener rows that share generation,
--    category, normalized fastener family, and Nm value.
--
-- This intentionally leaves conflicting wheel torque candidates in place for
-- source verification instead of guessing which value is correct.

with wheel_category as (
  select id
  from public.torque_categories
  where slug = 'wheels'
),
redundant_generic_rows as (
  select generic.id
  from public.torque_specs generic
  join wheel_category category
    on category.id = generic.category_id
  where lower(trim(generic.component)) = lower('Wheels')
    and lower(trim(generic.fastener)) in (
      lower('Wheel lug nuts'),
      lower('Wheel lug bolts')
    )
    and generic.source_status in ('community', 'needs_review')
    and exists (
      select 1
      from public.torque_specs keeper
      where keeper.id <> generic.id
        and keeper.generation_id = generic.generation_id
        and keeper.category_id = generic.category_id
        and keeper.torque_nm is not distinct from generic.torque_nm
        and keeper.angle_degrees is not distinct from generic.angle_degrees
        and lower(trim(keeper.component)) <> lower('Wheels')
        and (
          lower(keeper.fastener) like '%lug nut%'
          or lower(keeper.fastener) like '%lug bolt%'
          or lower(keeper.fastener) like '%wheel fastener%'
          or lower(keeper.fastener) like '%wheel bolt%'
        )
    )
),
delete_generic as (
  delete from public.torque_specs spec
  using redundant_generic_rows duplicate
  where spec.id = duplicate.id
  returning spec.id
),
remaining_wheel_rows as (
  select
    spec.id,
    row_number() over (
      partition by
        spec.generation_id,
        spec.category_id,
        case
          when lower(spec.fastener) like '%lug nut%' then 'lug-nut'
          when lower(spec.fastener) like '%lug bolt%' then 'lug-bolt'
          when lower(spec.fastener) like '%wheel bolt%' then 'lug-bolt'
          when lower(spec.fastener) like '%wheel fastener%' then 'wheel-fastener'
          else lower(trim(spec.fastener))
        end,
        spec.torque_nm,
        spec.angle_degrees
      order by
        case spec.source_status
          when 'verified' then 0
          when 'needs_review' then 1
          else 2
        end,
        case when lower(trim(spec.component)) = lower('Wheels') then 1 else 0 end,
        spec.created_at asc,
        spec.id asc
    ) as keep_rank
  from public.torque_specs spec
  join wheel_category category
    on category.id = spec.category_id
  where (
    lower(spec.fastener) like '%lug nut%'
    or lower(spec.fastener) like '%lug bolt%'
    or lower(spec.fastener) like '%wheel fastener%'
    or lower(spec.fastener) like '%wheel bolt%'
  )
),
duplicate_wheel_rows as (
  select id
  from remaining_wheel_rows
  where keep_rank > 1
)
delete from public.torque_specs spec
using duplicate_wheel_rows duplicate
where spec.id = duplicate.id;
