-- Offset Lab Torque Hub
-- Pack 035: resolve Porsche 997 wheel-fastener ambiguity.
--
-- Plain SQL only. Safe to re-run.
-- Porsche service information distinguishes three hardware/year cases:
-- - Silver conventional wheel bolts through MY2011: 96 ft-lb / 130 Nm
-- - Silver conventional bolts from MY2012, or black bolts: 118 ft-lb / 160 Nm
-- - Central wheel locks: 443 ft-lb / 600 Nm
--
-- Porsche confirms that the facelifted 997 GT3 adopted center-lock wheels for
-- MY2010. The GT3 and GT3 RS rows therefore identify the early five-lug and
-- later center-lock applications explicitly instead of presenting two generic,
-- conflicting wheel-bolt values.

with conventional(spec_id, fastener, torque_ft_lb, torque_nm, notes, warning, source_note) as (
  values
    (
      'ddf405fb-5b56-4825-bba2-ae1813077346'::uuid,
      'Silver conventional wheel bolts (through MY2011)',
      96::numeric,
      130::numeric,
      'Porsche service information specifies 96 ft-lb / 130 Nm for silver conventional wheel bolts through model year 2011.',
      'Conventional wheel bolts only. Do not use this value for black bolts, MY2012 silver bolts, or center-lock wheels. Verify the fastener type and model year before service.',
      'Porsche manufacturer certificate 4440 ENU 88/21: silver wheel bolts through MY2011 are tightened to 130 Nm.'
    ),
    (
      'f93fedca-84be-47ff-93ae-f14da5fad95c'::uuid,
      'Black conventional bolts or MY2012 silver bolts',
      118::numeric,
      160::numeric,
      'Porsche service information specifies 118 ft-lb / 160 Nm for black conventional wheel bolts and for silver conventional bolts from model year 2012.',
      'Conventional wheel bolts only. Do not use this value for earlier silver bolts or center-lock wheels. Verify the fastener type and model year before service.',
      'Porsche manufacturer certificate 4440 ENU 88/21: silver wheel bolts from MY2012 and black wheel bolts are tightened to 160 Nm.'
    ),
    (
      '16ab02a3-8cc0-4355-ad35-171afd0877c7'::uuid,
      'Conventional five-lug wheel bolts (997.1 GT3)',
      96::numeric,
      130::numeric,
      'The pre-facelift 997 GT3 uses conventional five-lug wheel bolts; Porsche specifies 96 ft-lb / 130 Nm for the applicable silver bolts.',
      'Applies to conventional five-lug 997.1 GT3 wheels only. MY2010-and-later 997.2 GT3 center-lock wheels require 600 Nm and the complete Porsche center-lock procedure.',
      'Porsche documentation identifies center locks as a MY2010 GT3 change; Porsche service information specifies 130 Nm for pre-MY2012 silver conventional wheel bolts.'
    ),
    (
      '9690d2ee-560a-492e-b2a9-178bd522148b'::uuid,
      'Conventional five-lug wheel bolts (997.1 GT3 RS)',
      96::numeric,
      130::numeric,
      'The pre-facelift 997 GT3 RS uses conventional five-lug wheel bolts; Porsche specifies 96 ft-lb / 130 Nm for the applicable silver bolts.',
      'Applies to conventional five-lug 997.1 GT3 RS wheels only. Facelift 997.2 GT3 RS center-lock wheels require 600 Nm and the complete Porsche center-lock procedure.',
      'Porsche service information specifies 130 Nm for pre-MY2012 silver conventional wheel bolts; later 997 GT applications with center lock are covered separately.'
    )
)
update public.torque_specs spec
set
  component = 'Wheels',
  fastener = conventional.fastener,
  torque_ft_lb = conventional.torque_ft_lb,
  torque_nm = conventional.torque_nm,
  angle_degrees = null,
  notes = conventional.notes,
  warning = conventional.warning,
  source_status = 'verified',
  source_name = 'Porsche 911 (997) manufacturer certificate 4440 ENU 88/21',
  source_url = 'https://static.nhtsa.gov/odi/tsbs/2021/MC-10203009-0001.pdf',
  source_note = conventional.source_note,
  source_checked_at = now()
from conventional
where spec.id = conventional.spec_id;

with center_lock(spec_id, fastener, notes, warning, source_note) as (
  values
    (
      '1b71b32b-454c-44c0-9f57-9ca38bccc5fc'::uuid,
      'Center-lock wheel nut (MY2010-2011 997.2 GT3)',
      'Porsche specifies 443 ft-lb / 600 Nm for 997 center-lock wheels. Follow the complete Porsche lubrication, inspection, tightening, locking, and verification procedure.',
      'Center-lock wheels are safety-critical. This value does not apply to five-lug 997.1 GT3 wheels. Use Porsche-specified tools and procedures, or have a qualified Porsche technician perform or verify the work.',
      'Porsche confirms center-lock hubs for the MY2010 facelifted 997 GT3; recall campaign 6/11 specifies 600 Nm for affected 997 central wheel locks.'
    ),
    (
      '0cc79504-c450-4efa-bb3c-2cd87fd60656'::uuid,
      'Center-lock wheel nut (997.2 GT3 RS)',
      'Porsche specifies 443 ft-lb / 600 Nm for 997 center-lock wheels. Follow the complete Porsche lubrication, inspection, tightening, locking, and verification procedure.',
      'Center-lock wheels are safety-critical. This value does not apply to five-lug 997.1 GT3 RS wheels. Use Porsche-specified tools and procedures, or have a qualified Porsche technician perform or verify the work.',
      'Porsche recall campaign 6/11 expressly covers 997 GT3 RS central wheel locks and specifies 600 Nm.'
    )
)
update public.torque_specs spec
set
  component = 'Wheels',
  fastener = center_lock.fastener,
  torque_ft_lb = 443,
  torque_nm = 600,
  angle_degrees = null,
  notes = center_lock.notes,
  warning = center_lock.warning,
  source_status = 'verified',
  source_name = 'Porsche recall campaign 6/11 EN AB01',
  source_url = 'https://static.nhtsa.gov/odi/rcl/2011/RCRIT-11V285-8833.pdf',
  source_note = center_lock.source_note,
  source_checked_at = now()
from center_lock
where spec.id = center_lock.spec_id;

-- The broad 997 page includes models equipped with an original or retrofitted
-- central lock, so add the hardware-specific value without implying that every
-- 997 uses it.
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
  generation.id,
  category.id,
  'Wheels',
  'Center-lock wheel nut (equipped vehicles)',
  443,
  600,
  null,
  'Porsche specifies 443 ft-lb / 600 Nm for 997 center-lock wheels. Follow the complete Porsche lubrication, inspection, tightening, locking, and verification procedure.',
  'Only for 997 vehicles actually equipped with Porsche central wheel locks. Never apply this value to conventional five-lug wheel bolts.',
  'verified',
  'Porsche recall campaign 6/11 EN AB01',
  'https://static.nhtsa.gov/odi/rcl/2011/RCRIT-11V285-8833.pdf',
  'Porsche recall campaign 6/11 covers affected 997 central-lock applications and specifies 600 Nm as the standard requirement.',
  now()
from public.torque_vehicle_generations generation
join public.torque_vehicle_models model on model.id = generation.model_id
join public.torque_vehicle_makes make on make.id = model.make_id
cross join public.torque_categories category
where make.slug = 'porsche'
  and generation.slug = '997'
  and category.slug = 'wheels'
  and not exists (
    select 1
    from public.torque_specs existing
    where existing.generation_id = generation.id
      and existing.category_id = category.id
      and existing.fastener = 'Center-lock wheel nut (equipped vehicles)'
  );

select
  count(*) filter (where spec.source_status = 'verified') as verified_997_wheel_rows,
  count(*) filter (where spec.source_status <> 'verified') as remaining_unverified_997_wheel_rows
from public.torque_specs spec
join public.torque_vehicle_generations generation on generation.id = spec.generation_id
join public.torque_categories category on category.id = spec.category_id
where generation.slug in ('997', '997-gt3', '997-gt3-rs')
  and category.slug = 'wheels';
