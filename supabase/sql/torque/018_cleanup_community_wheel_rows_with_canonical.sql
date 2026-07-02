-- Offset Lab Torque Hub
-- Pack 018: remove community wheel rows when a canonical wheel row exists.
--
-- Plain SQL only. Safe to re-run.
-- Older imports created multiple community wheel baseline rows inside the same
-- generation, sometimes with donor/platform labels such as Toyota truck/SUV,
-- GR86/Supra, older Mercedes, older Porsche, or Jeep family baselines. When a
-- clean non-community Wheels row already exists for the same generation, keep
-- that canonical row and remove the community wheel clutter.

with duplicate_community_wheel_rows as (
  select community.id
  from public.torque_specs community
  join public.torque_categories category
    on category.id = community.category_id
   and category.slug = 'wheels'
  where community.source_status = 'community'
    and exists (
      select 1
      from public.torque_specs keeper
      where keeper.generation_id = community.generation_id
        and keeper.category_id = community.category_id
        and keeper.source_status <> 'community'
        and lower(trim(keeper.component)) = lower('Wheels')
        and lower(trim(keeper.fastener)) in (
          lower('Wheel lug nuts'),
          lower('Wheel lug bolts')
        )
    )
)
delete from public.torque_specs spec
using duplicate_community_wheel_rows duplicate
where spec.id = duplicate.id;
