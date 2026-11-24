-- Offset Lab Fitment
-- Pack 121: keep preset mirror fields aligned with verified default baselines.
-- The normalized baseline table remains the source of truth. These fields are
-- retained for compatibility with older reads and exports. Safe to re-run.

update public.fitment_presets preset
set factory_front = baseline.front,
    factory_rear = baseline.rear,
    factory_tire = baseline.tire,
    bolt_pattern = baseline.bolt_pattern,
    center_bore = baseline.center_bore
from public.fitment_factory_baselines baseline
where baseline.make = preset.make
  and baseline.model = preset.model
  and baseline.trim = preset.trim
  and baseline.active is not false
  and baseline.is_default = true
  and baseline.source_status = 'verified'
  and preset.active is not false;

select count(*) as active_presets_missing_verified_factory_mirror
from public.fitment_presets preset
join public.fitment_factory_baselines baseline
  on baseline.make = preset.make
 and baseline.model = preset.model
 and baseline.trim = preset.trim
 and baseline.active is not false
 and baseline.is_default = true
 and baseline.source_status = 'verified'
where preset.active is not false
  and (
    preset.factory_front is distinct from baseline.front
    or preset.factory_rear is distinct from baseline.rear
    or preset.factory_tire is distinct from baseline.tire
    or preset.bolt_pattern is distinct from baseline.bolt_pattern
    or preset.center_bore is distinct from baseline.center_bore
  );
