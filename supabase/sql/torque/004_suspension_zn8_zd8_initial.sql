-- Offset Lab Torque Hub
-- Pack 004: initial suspension coverage for Toyota GR86 / Subaru BRZ.
--
-- Plain SQL only. Safe to re-run.
-- Existing matching Torque Hub specs are retained and not overwritten.
--
-- These values are intentionally marked needs_review until exact model-year
-- Toyota/Subaru service manual URLs are attached in source_url.

with seed(make_slug, model_slug, generation_slug, component, fastener, torque_ft_lb, torque_nm, notes, warning, source_name, source_note) as (
  values
    ('toyota', 'gr86', 'zn8-gr86', 'Front Suspension', 'Front strut-to-steering knuckle bolts/nuts', 114, 155, 'Tighten with vehicle safely supported. Recheck alignment after loosening strut-to-knuckle hardware.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Toyota source before marking verified.'),
    ('toyota', 'gr86', 'zn8-gr86', 'Front Suspension', 'Front stabilizer link nut', 34, 46, 'Hold ball stud as needed while tightening. Inspect link boot condition.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Toyota source before marking verified.'),
    ('toyota', 'gr86', 'zn8-gr86', 'Front Suspension', 'Front lower arm rear bushing bracket bolts', 81, 110, 'Final tighten rubber-bushed suspension hardware at normal ride height when applicable.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Toyota source before marking verified.'),
    ('toyota', 'gr86', 'zn8-gr86', 'Rear Suspension', 'Rear shock absorber lower bolt/nut', 66, 90, 'Final tighten rubber-bushed suspension hardware at normal ride height when applicable.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Toyota source before marking verified.'),
    ('toyota', 'gr86', 'zn8-gr86', 'Rear Suspension', 'Rear stabilizer link nut', 28, 38, 'Hold ball stud as needed while tightening. Inspect link boot condition.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Toyota source before marking verified.'),
    ('toyota', 'gr86', 'zn8-gr86', 'Rear Suspension', 'Rear lower arm-to-subframe bolt/nut', 89, 120, 'Final tighten rubber-bushed suspension hardware at normal ride height when applicable.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Toyota source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 'Front Suspension', 'Front strut-to-steering knuckle bolts/nuts', 114, 155, 'Tighten with vehicle safely supported. Recheck alignment after loosening strut-to-knuckle hardware.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Subaru source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 'Front Suspension', 'Front stabilizer link nut', 34, 46, 'Hold ball stud as needed while tightening. Inspect link boot condition.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Subaru source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 'Front Suspension', 'Front lower arm rear bushing bracket bolts', 81, 110, 'Final tighten rubber-bushed suspension hardware at normal ride height when applicable.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Subaru source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 'Rear Suspension', 'Rear shock absorber lower bolt/nut', 66, 90, 'Final tighten rubber-bushed suspension hardware at normal ride height when applicable.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Subaru source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 'Rear Suspension', 'Rear stabilizer link nut', 28, 38, 'Hold ball stud as needed while tightening. Inspect link boot condition.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Subaru source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 'Rear Suspension', 'Rear lower arm-to-subframe bolt/nut', 89, 120, 'Final tighten rubber-bushed suspension hardware at normal ride height when applicable.', 'Suspension fasteners are safety-critical. Verify against the exact model-year service manual before using on customer vehicles.', 'Toyota GR86 / Subaru BRZ service reference', 'Initial ZN8/ZD8 suspension seed. Attach exact Subaru source before marking verified.')
)
insert into public.torque_specs (
  generation_id,
  category_id,
  component,
  fastener,
  torque_ft_lb,
  torque_nm,
  angle_degrees,
  notes,
  warning,
  source_status,
  source_name,
  source_url,
  source_note,
  source_checked_at
)
select
  generation_row.id,
  category_row.id,
  seed.component,
  seed.fastener,
  seed.torque_ft_lb::numeric,
  seed.torque_nm::numeric,
  null::numeric,
  seed.notes,
  seed.warning,
  'needs_review',
  seed.source_name,
  null,
  seed.source_note,
  now()
from seed
join public.torque_vehicle_makes make_row
  on make_row.slug = seed.make_slug
join public.torque_vehicle_models model_row
  on model_row.make_id = make_row.id
 and model_row.slug = seed.model_slug
join public.torque_vehicle_generations generation_row
  on generation_row.model_id = model_row.id
 and generation_row.slug = seed.generation_slug
join public.torque_categories category_row
  on category_row.slug = 'suspension'
where not exists (
  select 1
  from public.torque_specs existing
  where existing.generation_id = generation_row.id
    and existing.category_id = category_row.id
    and lower(existing.component) = lower(seed.component)
    and lower(existing.fastener) = lower(seed.fastener)
);
