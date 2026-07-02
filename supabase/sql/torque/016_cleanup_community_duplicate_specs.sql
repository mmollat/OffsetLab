-- Offset Lab Torque Hub
-- Pack 016: remove community rows duplicated by non-community rows.
--
-- Plain SQL only. Safe to re-run.
-- Deletes only community rows that have an exact non-community keeper in the
-- same generation/category/fastener/torque/angle group. This cleans up older
-- trim-labeled/imported rows that render as duplicate cards after the
-- fitment-driven needs_review/verified coverage rows were added.

with duplicate_community_rows as (
  select community.id
  from public.torque_specs community
  where community.source_status = 'community'
    and exists (
      select 1
      from public.torque_specs keeper
      where keeper.id <> community.id
        and keeper.source_status <> 'community'
        and keeper.generation_id = community.generation_id
        and keeper.category_id = community.category_id
        and lower(trim(keeper.fastener)) = lower(trim(community.fastener))
        and keeper.torque_ft_lb is not distinct from community.torque_ft_lb
        and keeper.torque_nm is not distinct from community.torque_nm
        and keeper.angle_degrees is not distinct from community.angle_degrees
    )
)
delete from public.torque_specs spec
using duplicate_community_rows duplicate
where spec.id = duplicate.id;
