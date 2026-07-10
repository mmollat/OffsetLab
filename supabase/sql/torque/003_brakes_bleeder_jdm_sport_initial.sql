-- Offset Lab Torque Hub
-- Pack 003: initial brake bleeder screw torque coverage.
--
-- Plain SQL only. Safe to re-run.
-- Existing matching Torque Hub specs are retained and not overwritten.
--
-- This is a conservative Brakes category starter pack. It intentionally adds
-- only brake bleeder screw torque, not caliper/bracket/suspension specs.
-- Marked needs_review until exact model-year service manual URLs are attached.

with seed(make_slug, model_slug, generation_slug, torque_ft_lb, torque_nm, source_name, source_note) as (
  values
    ('toyota', 'gr86', 'zn8-gr86', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Toyota GR86 service source before marking verified.'),
    ('subaru', 'brz', 'zd8-brz', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Subaru BRZ service source before marking verified.'),
    ('toyota', 'gr-corolla', 'e210-gr-corolla', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Toyota GR Corolla service source before marking verified.'),
    ('toyota', 'supra', 'a90-a91-gr-supra', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Toyota GR Supra service source before marking verified.'),
    ('honda', 'civic-type-r', 'fk8-civic-type-r', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Honda Civic Type R service source before marking verified.'),
    ('honda', 'civic-type-r', 'fl5-civic-type-r', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Honda Civic Type R service source before marking verified.'),
    ('honda', 'civic', 'fc-fk-10th-gen-civic', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Honda Civic service source before marking verified.'),
    ('honda', 'civic', 'fe-fl-11th-gen-civic', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Honda Civic service source before marking verified.'),
    ('honda', 's2000', 'ap1-s2000', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Honda S2000 service source before marking verified.'),
    ('honda', 's2000', 'ap2-s2000', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Honda S2000 service source before marking verified.'),
    ('acura', 'rsx', 'dc5-rsx', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Acura RSX service source before marking verified.'),
    ('acura', 'integra', 'de4-integra', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Acura Integra service source before marking verified.'),
    ('mazda', 'mx-5-miata', 'nd-mx-5-miata', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Mazda MX-5 service source before marking verified.'),
    ('subaru', 'wrx-sti', 'va-wrx-sti', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Subaru WRX/STI service source before marking verified.'),
    ('nissan', 'z', 'rz34-z', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Nissan Z service source before marking verified.'),
    ('nissan', '370z', 'z34-370z', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Nissan 370Z service source before marking verified.'),
    ('nissan', '350z', 'z33-350z', 8, 11, 'Common brake bleeder screw torque reference', 'Initial brake baseline. Attach exact Nissan 350Z service source before marking verified.')
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
  'Brake Bleeder',
  'Brake bleeder screw',
  seed.torque_ft_lb::numeric,
  seed.torque_nm::numeric,
  null::numeric,
  'Small fastener. Use care and do not over-tighten.',
  'Bleeder screws are easy to damage. Verify against the exact service manual before using on customer vehicles.',
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
  on category_row.slug = 'brakes'
where not exists (
  select 1
  from public.torque_specs existing
  where existing.generation_id = generation_row.id
    and existing.category_id = category_row.id
    and lower(existing.component) = lower('Brake Bleeder')
    and lower(existing.fastener) = lower('Brake bleeder screw')
);

